//
//  ApptitleCell.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/01.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "ApptitleCell.h"

@implementation ApptitleCell

@synthesize icon = _icon;
@synthesize appname = _appname;
@synthesize version = _version;
@synthesize copyright = _copyright;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
