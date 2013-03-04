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
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
    [[GAI sharedInstance].defaultTracker trackView:@"OtherViewController"];

    _tableView.scrollEnabled = NO;
    _scrollView.directionalLockEnabled = YES;
    _itemarray = [[BlogInfo sharedManager] getItemarray];
    CGRect rect = CGRectMake(0, 0, 320.0f, 320.0f);
    
    for (NSInteger i = 0; i < _itemarray.count; i ++)
    {
        rect.origin.x = i * rect.size.width;
        
        NSDictionary *dict = _itemarray[i];
        NSString *imageurl = [dict objectForKey:@"imageurl"];
        imageview = [[UIImageView alloc] initWithFrame:rect];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = [[UIImage alloc] init];
        if (!imageurl.length) {
            image = [UIImage imageNamed:@"noimage.gif"];
            [imageview setImage:image];
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
        
        _scrollView.contentSize = CGSizeMake(rect.size.width * [_itemarray count], rect.size.height);
        _scrollView.pagingEnabled = YES;

    }
    _scrollView.contentOffset = CGPointMake(320.0 * _selected, 0);
    
    to_left = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 140.0f, 40.0f, 40.0f)];
    to_right = [[UIButton alloc] initWithFrame:CGRectMake(275.0f, 140.0f, 40.0f, 40.0f)];
    [to_left setBackgroundImage:[UIImage imageNamed:@"to_left.png"] forState:UIControlStateNormal];
    [to_left addTarget:self
                action:@selector(to_left:) forControlEvents:UIControlEventTouchUpInside];
    [to_right setBackgroundImage:[UIImage imageNamed:@"to_right.png"] forState:UIControlStateNormal];
    [to_right addTarget:self
                action:@selector(to_right:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:to_left];
    [self.view addSubview:to_right];
    [self hiddenButton];
    
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

- (void)to_left:(UIButton *)button
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.0];
    _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x - 320, 0);
    [UIView commitAnimations];
    _selected = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    [self hiddenButton];
}

- (void)to_right:(UIButton *)button
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.0];
    _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + 320, 0);
    [UIView commitAnimations];
    _selected = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    [self hiddenButton];
}

- (void)hiddenButton {
    if (_selected == 0) {
        [to_left setAlpha:0.02];
    } else {
        [to_left setAlpha:0.7];
    }
    if (_selected == (_itemarray.count - 1)) {
        [to_right setAlpha:0.02];
    } else {
        [to_right setAlpha:0.7];
    }
    
    _item = [_itemarray[_selected] objectForKey:@"title"];
    _blog = [_itemarray[_selected] objectForKey:@"blog"];
    NSDate *date = [_itemarray[_selected] objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    _date = [formatter stringFromDate:date];
    [_tableView reloadData];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelay:1.0];
    [to_left setAlpha:0.02];
    [to_right setAlpha:0.02];
    [UIView commitAnimations];
}

- (IBAction)pressSaveButton:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(
                                   [[BlogInfo sharedManager] getImageCache:[_itemarray[_selected] objectForKey:@"imageurl"]], self,
                                   //[UIImage imageNamed:@"noimage.gif"], self,
                                   @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
}

-(void)savingImageIsFinished:(UIImage*)image
    didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error)
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"フォトアルバムに保存しました"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        NSLog(@"error");
    }
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
    [self hiddenButton];
}

@end
