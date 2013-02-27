//
//  ScrollCell.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "ScrollCell.h"

@implementation ScrollCell

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
