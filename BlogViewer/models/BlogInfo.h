//
//  BlogInfo.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/18.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogInfo : NSObject
{
    NSArray *_bloginfo;
}

@property (nonatomic, strong) NSArray *bloginfo;

+ (BlogInfo *)sharedManager;
- (NSArray *)getBlogInfo;

@end
