//
//  ImageCell.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageview;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *cellindicator;


@end
