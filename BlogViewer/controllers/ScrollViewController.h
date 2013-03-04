//
//  ScrollViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIScrollView *_scrollView;
    UIImageView *imageview;
    //UIImageView *to_left;
    //UIImageView *to_right;
    UIButton *to_left;
    UIButton *to_right;
    
    NSArray *_itemarray;
    NSArray *_imagearray;
    NSMutableArray *_imageviewarray;
    NSInteger _selected;
    NSString *_item;
    NSString *_blog;
    NSString *_date;
}

@property (nonatomic) NSInteger selected;

@end
