//
//  FavoriteCell.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/05.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

@synthesize thumbnail = _thumbnail;
@synthesize itemtitle = _itemtitle;
@synthesize blogtitle = _blogtitle;
@synthesize updated = _updated;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    // thmbnail
    _thumbnail = [[UIImageView alloc] init];
    _thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnail.clipsToBounds = YES;
    [self.contentView addSubview:_thumbnail];
    
    // itemtitle
    _itemtitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _itemtitle.font = [UIFont boldSystemFontOfSize:16.0f];
    _itemtitle.textColor = [UIColor blackColor];
    _itemtitle.backgroundColor = [UIColor clearColor];
    _itemtitle.numberOfLines = 2;
    [self.contentView addSubview:_itemtitle];
    
    // blogtitle
    _blogtitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _blogtitle.font = [UIFont systemFontOfSize:13.0f];
    _blogtitle.textColor = [UIColor darkGrayColor];
    _blogtitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_blogtitle];
    
    // updated
    _updated = [[UILabel alloc] initWithFrame:CGRectZero];
    _updated.font = [UIFont systemFontOfSize:13.0f];
    _updated.textColor = [UIColor darkGrayColor];
    _updated.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_updated];
    
    return self;
}

- (void)layoutSubviews
{
    CGRect  rect;
    
    [super layoutSubviews];
    
    // contentView
    CGRect  bounds;
    bounds = self.contentView.bounds;
    
    NSLog(@"width: %f", bounds.size.width);
    
    if (bounds.size.width < 320) {
        // thmbnail
        rect = CGRectMake(5.0f, 10.0f, 60.0f, 60.0f);
        _thumbnail.frame = rect;
        
        // itemtitle
        rect = CGRectMake(72.0f, 8.0f, 227.0f, 42.0f);
        _itemtitle.frame = rect;
        
        // blogtitle
        rect = CGRectMake(72.0f, 52.0f, 147.0f, 21.0f);
        _blogtitle.frame = rect;
        
        // updated
        rect = CGRectMake(228.0f, 52.0f, 72.0f, 21.0f);
        _updated.frame = rect;
    } else {
        // thmbnail
        rect = CGRectMake(5.0f, 10.0f, 60.0f, 60.0f);
        _thumbnail.frame = rect;
        
        // itemtitle
        rect = CGRectMake(72.0f, 8.0f, 676.0f, 42.0f);
        _itemtitle.frame = rect;
        
        // blogtitle
        rect = CGRectMake(72.0f, 52.0f, 570.0f, 21.0f);
        _blogtitle.frame = rect;
        
        // updated
        rect = CGRectMake(676.0f, 52.0f, 72.0f, 21.0f);
        _updated.frame = rect;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 1.0,  // Start color
        0.9, 0.9, 0.9, 1.0 }; // End color
    //0.79, 0.79, 0.79, 1.0 }; // End color
    //0.502, 0.502, 0.502, 1.0 }; // End color
    //0.33, 0.33, 0.33, 1.0 }; // End color
    colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                   locations, num_locations);
    
    CGPoint startPoint = CGPointMake(self.frame.size.width/2, 0.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}


@end
