//
//  ScrollViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIScrollView *_scrollView;
    UIImageView *imageview;
    UIButton *to_left;
    UIButton *to_right;
    UIActionSheet *_actionsheet;

    
    NSArray *_itemarray;
    NSInteger _selected;
    NSString *_item;
    NSString *_blog;
    NSString *_date;
    CGRect _screenrect;
}

@property (nonatomic) NSInteger selected;

- (IBAction)pressSaveButton:(id)sender;

@end
