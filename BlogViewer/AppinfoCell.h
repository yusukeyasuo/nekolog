//
//  AppinfoCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/01.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppinfoCell : UITableViewCell
{
    IBOutlet UILabel *_appinfo;
}

@property (nonatomic, strong) UILabel *appinfo;

@end
