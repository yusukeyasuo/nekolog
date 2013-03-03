//
//  ApptitleCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/01.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApptitleCell : UITableViewCell
{
    IBOutlet UIImageView *_icon;
    IBOutlet UILabel *_appname;
    IBOutlet UILabel *_version;
    IBOutlet UILabel *_copyright;
}

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *appname;
@property (nonatomic, strong) UILabel *version;
@property (nonatomic, strong) UILabel *copyright;

@end
