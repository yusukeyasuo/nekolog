//
//  ItemCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ItemCell : UITableViewCell
{
    IBOutlet UIImageView *_thumbnail;
    IBOutlet UILabel *_itemtitle;
    IBOutlet UILabel *_blogtitle;
    IBOutlet UILabel *_updated;
}

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *itemtitle;
@property (nonatomic, strong) UILabel *blogtitle;
@property (nonatomic, strong) UILabel *updated;

@end
