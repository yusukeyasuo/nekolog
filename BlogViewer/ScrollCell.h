//
//  ScrollCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCell : UITableViewCell
{
    IBOutlet UILabel *_itemLabel;
    IBOutlet UILabel *_blogLabel;
    IBOutlet UILabel *_dateLabel;
}

@property (nonatomic,strong) UILabel *itemLabel;
@property (nonatomic,strong) UILabel *blogLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@end
