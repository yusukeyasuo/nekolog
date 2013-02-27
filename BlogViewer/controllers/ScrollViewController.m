//
//  ScrollViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "ScrollViewController.h"
#import "BlogInfo.h"
#import "AFNetworking.h"
#import "ScrollCell.h"
#import "WebViewController.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController
@synthesize selected = _selected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.scrollEnabled = NO;
    _itemarray = [[BlogInfo sharedManager] getItemarray];
    _imageviewarray = [[NSMutableArray alloc] init];
    CGRect rect = CGRectMake(0, 0, 320.0f, 320.0f);
    
    for (NSInteger i = 0; i < [_itemarray count]; i ++)
    {
        rect.origin.x = i * rect.size.width;
        
        NSDictionary *dict = _itemarray[i];
        NSString *imageurl = [dict objectForKey:@"imageurl"];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        if (imageurl.length < 5) {
            [imageview setImage:[UIImage imageNamed:@"noimage.gif"]];
        } else {
            if ([[BlogInfo sharedManager] getImageCache:[dict objectForKey:@"imageurl"]] != nil) {
                [imageview setImage:[[BlogInfo sharedManager] getImageCache:[dict objectForKey:@"imageurl"]]];
            } else {
                __block UIImageView *bImageview = imageview;
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"imageurl"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
                [imageview setImageWithURLRequest:request
                                      placeholderImage:nil
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *_image) {
                                                   [bImageview setImage:_image];
                                               } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               }];
            }
        }

        [_scrollView addSubview:imageview];
        [_imageviewarray addObject:imageview];
        _scrollView.contentSize = CGSizeMake(rect.size.width * [_itemarray count], rect.size.height);
        _scrollView.pagingEnabled = YES;
    }
    _scrollView.contentOffset = CGPointMake(320.0 * _selected, 0);
    _item = [_itemarray[_selected] objectForKey:@"title"];
    _blog = [_itemarray[_selected] objectForKey:@"blog"];
    NSDate *date = [_itemarray[_selected] objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    _date = [formatter stringFromDate:date];
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *webController = segue.destinationViewController;
    webController.hidesBottomBarWhenPushed = YES;
    webController.itemdict = _itemarray[_selected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.itemLabel.text = _item;
    cell.blogLabel.text = _blog;
    cell.dateLabel.text = _date;
    
    return cell;
}


# pragma mark - Scroll Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _selected = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _item = [_itemarray[_selected] objectForKey:@"title"];
    _blog = [_itemarray[_selected] objectForKey:@"blog"];
    NSDate *date = [_itemarray[_selected] objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    _date = [formatter stringFromDate:date];
    [_tableView reloadData];
}

@end
