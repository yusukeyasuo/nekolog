//
//  BlogCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/18.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BlogCell : UITableViewCell
{
    IBOutlet UIImageView *_thumbnail;
    IBOutlet UILabel *_blogtitle;
    IBOutlet UILabel *_updated;
}

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *blogtitle;
@property (nonatomic, strong) UILabel *updated;

@end
