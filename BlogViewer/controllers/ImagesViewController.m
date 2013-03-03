//
//  ImagesViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "ImagesViewController.h"
#import "AppDelegate.h"
#import "BlogInfo.h"
#import "AFNetworking.h"
#import "WebViewController.h"
#import "ScrollViewController.h"
#import "ImageCell.h"

@interface ImagesViewController ()

@end

@implementation ImagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [[GAI sharedInstance].defaultTracker trackView:@"ImageViewController"];

    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_indicator setCenter:CGPointMake(160.0f, 240.0f)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    _indicator.hidden = YES;
    
    _itemarray = (NSMutableArray *)[[BlogInfo sharedManager] getItemarray];
    if (_itemarray == nil) {
        [self refresh];
    } else {
        [self.collectionView reloadData];
    }
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
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
            _itemarray = [[NSMutableArray alloc] init];
            [self.collectionView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            _rssno = 0;
            _indicator.hidden = NO;
            [_indicator startAnimating];
            [self getRss:_rssno];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UICollectionViewCell *cell = sender;
    ScrollViewController *scrollController = segue.destinationViewController;
    scrollController.hidesBottomBarWhenPushed = YES;
    scrollController.selected = cell.tag;
    /*
    WebViewController *webController = segue.destinationViewController;
    webController.hidesBottomBarWhenPushed = YES;
    webController.itemdict = _itemarray[cell.tag];
    //*/
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
        _imageurl = [[NSString alloc] init];
    }
    if ([elementName isEqualToString:@"image"]) {
        _inimage = YES;
    }
    if ([elementName isEqualToString:@"enclosure"]) {
        _imageurl = [attributeDict objectForKey:@"url"];
        _imageurl = [_imageurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _imageurl = [_imageurl stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
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
        if (results.count) {
            for (int i = 0; i < results.count; i++) {
                NSTextCheckingResult *result = [results objectAtIndex:i];
                NSRange match = [[_currentdescription substringWithRange:[result rangeAtIndex:2]] rangeOfString:@"user_image" options:NSRegularExpressionSearch];
                if (match.location == NSNotFound) {
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
        [self.collectionView reloadData];
    }
    [self getRss:_rssno];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *dict = _itemarray[indexPath.row];
    
    cell.tag = indexPath.row;
    
    NSString *imageurl = [dict objectForKey:@"imageurl"];
    if (!imageurl.length) {
        [cell.imageview setImage:[UIImage imageNamed:@"noimage.gif"]];
    } else {
        __block ImageCell *bCell = cell;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"imageurl"]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        [cell.imageview setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *_image) {
                                        [[BlogInfo sharedManager] setImageCache:_image imageurl:[dict objectForKey:@"imageurl"]];
                                        [bCell.imageview setImage:_image];
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    }];
    }
    
    return cell;
}


- (IBAction)pressRefreshButton:(id)sender {
    [self refresh];
}
@end
