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
    UIButton *to_left;
    UIButton *to_right;
    
    NSArray *_itemarray;
    NSInteger _selected;
    NSString *_item;
    NSString *_blog;
    NSString *_date;
}

@property (nonatomic) NSInteger selected;

- (IBAction)pressSaveButton:(id)sender;

@end
