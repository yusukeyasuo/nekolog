//
//  ItemsViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "ItemsViewController.h"
#import "WebViewController.h"
#import "ItemCell.h"
#import "AFNetworking.h"
#import "BlogInfo.h"

@interface ItemsViewController ()

@end

@implementation ItemsViewController

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
    [[BlogInfo sharedManager] load];
    NSLog(@"ItemViewController");
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_indicator setCenter:CGPointMake(160.0f, 240.0f)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    _indicator.hidden = YES;
    
    _rssarray = [[BlogInfo sharedManager] getRssArray];
    if ([[BlogInfo sharedManager] getItemarray] == nil) {
        [self refresh];
    } else {
        _itemarray = (NSMutableArray *)[[BlogInfo sharedManager] getItemarray];
        [self.tableView reloadData];
    }
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        [_xmlparser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
    
}

- (void)refresh
{
    _itemarray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _rssno = 0;
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [self getRss:_rssno];
}

- (IBAction)pressRefreshButton:(id)sender {
    [self refresh];
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
        _initem = YES;
        _itemdict = [[NSMutableDictionary alloc] init];
		_currenttitle = [[NSMutableString alloc] init];
		_currentdate = [[NSMutableString alloc] init];
		_currentdescription = [[NSMutableString alloc] init];
		_currentlink = [[NSMutableString alloc] init];
    }
    if ([elementName isEqualToString:@"image"]) {
        _inimage = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([_currentelement isEqualToString:@"title"]) {
        if (!_initem) {
            if (!_inimage) {
                [_currentblog appendString:string];
            }
        } else {
            [_currenttitle appendString:string];
        }
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
        [_itemdict setObject:_currentblog forKey:@"blog"];
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
    if (++_rssno == _rssarray.count) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:FALSE];
        [_itemarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        [[BlogInfo sharedManager] setItemarray:_itemarray];
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
    return _itemarray.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    
    if (!cell) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = [_itemarray objectAtIndex:indexPath.row];
    
    NSDate *date = [dict objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSString *datestr = [formatter stringFromDate:date];
    
    cell.tag = indexPath.row;
    cell.thumbnail.image = [[UIImage alloc] init];
    cell.itemtitle.text = [dict objectForKey:@"title"];
    cell.blogtitle.text = [dict objectForKey:@"blog"];
    NSLog(@"blog: %@", cell.blogtitle.text);
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

@end
