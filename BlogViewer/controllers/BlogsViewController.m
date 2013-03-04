//
//  BlogsViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "BlogsViewController.h"
#import "AppDelegate.h"
#import "BlogCell.h"
#import "BlogInfo.h"
#import "AFNetworking.h"
#import "BlogItemsViewController.h"

@interface BlogsViewController ()

@end

@implementation BlogsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
    [[GAI sharedInstance].defaultTracker trackView:@"BlogViewController"];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_indicator setCenter:CGPointMake(160.0f, 240.0f)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    _indicator.hidden = YES;
    
    if ([[BlogInfo sharedManager] getBlogarray] == nil) {
        [self refresh];
    } else {
        _blogarray = (NSMutableArray *)[[BlogInfo sharedManager] getBlogarray];
        [self.tableView reloadData];
    }
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
}

- (void)refresh
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate checkNetworkAccess])
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"インターネット接続がオフラインのようです。"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        [_refreshControl endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return;
    }
    
    [[BlogInfo sharedManager] getRssArraywithCompletion:^(NSArray *responceObject, NSError *error) {
        if (error)
        {
        } else {
            _rssarray = responceObject;
            _blogarray = [[NSMutableArray alloc] init];
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            _rssno = 0;
            _indicator.hidden = NO;
            [_indicator startAnimating];
            [self getRss:_rssno];
        }
    }];
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
        _initem = NO;
        _inimage = NO;
        _currentblog = [[NSMutableString alloc] init];
        _currentimage = [[NSMutableString alloc] init];
        _currentdate = [[NSMutableString alloc] init];
        [_xmlparser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BlogCell *cell = sender;
    BlogItemsViewController *blogitemsController = segue.destinationViewController;
    blogitemsController.blogno = cell.tag;
    blogitemsController.title = [_blogarray[cell.tag] objectForKey:@"blog"];
}


#pragma mark - XML parser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    _currentelement = [elementName copy];
    
    _blogdict = [[NSMutableDictionary alloc] init];
    
    if ([elementName isEqualToString:@"image"]) {
        _inimage = YES;
    }
    if ([elementName isEqualToString:@"item"] && _initem == NO) {
        _initem = YES;
        [_blogdict setObject:_currentblog forKey:@"blog"];
        NSString *imagestr = [_currentimage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        imagestr = [imagestr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (imagestr.length)
            imagestr = [NSString stringWithFormat:@"%@?dw=60,dh=60,cw=60,ch=60,q=50,da=s,ds=s", imagestr];
        [_blogdict setObject:imagestr forKey:@"imageurl"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSString *datestr = [_currentdate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        datestr = [datestr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSDate *date = [formatter dateFromString:datestr];
		[_blogdict setObject:date forKey:@"date"];
        [_blogdict setObject:[_rssarray objectAtIndex:_rssno] forKey:@"rss"];
        
        [_blogarray addObject:[_blogdict copy]];
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_currentelement isEqualToString:@"title"]) {
        if (!_initem && !_inimage) {
            [_currentblog appendString:string];
        }
    } else if ([_currentelement isEqualToString:@"url"]) {
        [_currentimage appendString:string];
    } else if ([_currentelement isEqualToString:@"dc:date"]) {
        if (!_initem) {
            [_currentdate appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (++_rssno == _rssarray.count) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
        [_blogarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        [[BlogInfo sharedManager] setBlogarray:_blogarray];
        [_refreshControl endRefreshing];
        [self.tableView reloadData];
    }
    [self getRss:_rssno];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _blogarray.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogCell *cell = (BlogCell *)[tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
    
    if (!cell) {
        cell = [[BlogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlogCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = [_blogarray objectAtIndex:indexPath.row];
    
    NSDate *date = [dict objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSString *datestr = [formatter stringFromDate:date];
    
    cell.tag = indexPath.row;
    cell.thumbnail.image = [[UIImage alloc] init];
    cell.blogtitle.text = [dict objectForKey:@"blog"];
    cell.updated.text = datestr;
    
    NSString *imageurl = [dict objectForKey:@"imageurl"];
    if (!imageurl.length) {
        [cell.thumbnail setImage:[UIImage imageNamed:@"noimage.gif"]];
        CALayer *layer = [cell.thumbnail layer];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth: 1.f];
        [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    } else {
        __block BlogCell *bCell = cell;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"imageurl"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        [cell.thumbnail setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *_image) {
                                           [[BlogInfo sharedManager] setImageCache:_image imageurl:[dict objectForKey:@"imageurl"]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)pressRefreshButton:(id)sender {
    [self refresh];
}
@end
