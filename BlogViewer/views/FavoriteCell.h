//
//  FavoriteCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/05.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FavoriteCell : UITableViewCell
{
    UIImageView *_thumbnail;
    UILabel *_itemtitle;
    UILabel *_blogtitle;
    UILabel *_updated;
}

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *itemtitle;
@property (nonatomic, strong) UILabel *blogtitle;
@property (nonatomic, strong) UILabel *updated;

@end
