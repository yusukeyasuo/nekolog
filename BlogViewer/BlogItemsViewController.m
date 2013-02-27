//
//  BlogItemsViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "BlogItemsViewController.h"
#import "BlogInfo.h"
#import "ItemCell.h"
#import "AFNetworking.h"
#import "WebViewController.h"

@interface BlogItemsViewController ()

@end

@implementation BlogItemsViewController
@synthesize blogno = _blogno;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_indicator setCenter:CGPointMake(160.0f, 240.0f)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    _indicator.hidden = YES;
    
    _rssarray = [[BlogInfo sharedManager] getRssArray];
    [self refresh];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    _itemarray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [self getRss:[_blogno intValue]];
}

- (void)getRss:(int)rssnumber
{
    if (rssnumber > _rssarray.count - 1) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[_rssarray objectAtIndex:rssnumber]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _xmlparser = [[NSXMLParser alloc] initWithData:responseObject];
        [_xmlparser setDelegate:self];
        [_xmlparser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ItemCell *cell = sender;
    WebViewController *webController = segue.destinationViewController;
    webController.hidesBottomBarWhenPushed = YES;
    webController.itemdict = _itemarray[cell.tag];
}

#pragma mark - XML parser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    _currentelement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        _itemdict = [[NSMutableDictionary alloc] init];
		_currenttitle = [[NSMutableString alloc] init];
		_currentdate = [[NSMutableString alloc] init];
		_currentdescription = [[NSMutableString alloc] init];
		_currentlink = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_currentelement isEqualToString:@"title"]) {
        [_currenttitle appendString:string];
    } else if ([_currentelement isEqualToString:@"link"]) {
        [_currentlink appendString:string];
    } else if ([_currentelement isEqualToString:@"description"]) {
        [_currentdescription appendString:string];
    } else if ([_currentelement isEqualToString:@"dc:date"]) {
        [_currentdate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [_itemdict setObject:self.title forKey:@"blog"];
        [_itemdict setObject:_currenttitle forKey:@"title"];
		[_itemdict setObject:_currentlink forKey:@"link"];
        NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:@"(<img.*?src=\")(.*?)(\".*?>)"
                                                                           options:0
                                                                             error:nil];
        NSArray *results = [regexp matchesInString:_currentdescription options:0 range:NSMakeRange(0, _currentdescription.length)];
        if (results.count > 1) {
            for (int i = 0; i < results.count; i++) {
                NSTextCheckingResult *result = [results objectAtIndex:i];
                NSRange match = [[_currentdescription substringWithRange:[result rangeAtIndex:2]] rangeOfString:@"emoji" options:NSRegularExpressionSearch];
                if (match.location != NSNotFound) {
                } else {
                    _imageurl = [_currentdescription substringWithRange:[result rangeAtIndex:2]];
                    break;
                }
            }
        }
		[_itemdict setObject:_imageurl forKey:@"imageurl"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSString *str = [_currentdate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSDate *date = [formatter dateFromString:str];
		[_itemdict setObject:date forKey:@"date"];
        
        [_itemarray addObject:[_itemdict copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_indicator stopAnimating];
    _indicator.hidden = YES;
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _itemarray.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [_itemarray objectAtIndex:indexPath.row];
    
    NSDate *date = [dict objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSString *datestr = [formatter stringFromDate:date];
    
    cell.tag = indexPath.row;
    cell.thumbnail.image = [[UIImage alloc] init];
    cell.itemtitle.text = [dict objectForKey:@"title"];
    cell.blogtitle.text = [dict objectForKey:@"blog"];
    cell.updated.text = datestr;
    
    NSString *imageurl = [dict objectForKey:@"imageurl"];
    if (imageurl.length < 5) {
        [cell.thumbnail setImage:[UIImage imageNamed:@"noimage.gif"]];
        CALayer *layer = [cell.thumbnail layer];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth: 1.f];
        [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    } else {
        __block ItemCell *bCell = cell;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"imageurl"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        [cell.thumbnail setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *_image) {
                                       [bCell.thumbnail setImage:_image];
                                       CALayer *layer = [bCell.thumbnail layer];
                                       [layer setMasksToBounds:YES];
                                       [layer setBorderWidth: 1.f];
                                       [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   }];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
