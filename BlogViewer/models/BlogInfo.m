//
//  BlogInfo.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/18.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "BlogInfo.h"

@implementation BlogInfo

@synthesize bloginfo = _bloginfo;

static BlogInfo *_sharedInstance = nil;

+ (BlogInfo *)sharedManager
{
    // インスタンスをつくる
    if (!_sharedInstance) {
        _sharedInstance = [[BlogInfo alloc] init];
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    return self;
}

- (NSArray *)getBlogInfo
{
    NSDictionary *kuru0214 = @{@"blogname": @"くるねこ大和", @"url": @"http://blog.goo.ne.jp/kuru0214"};
    //NSDictionary *kuru0214 = @{@"blogname": @"くるねこ大和", @"url": @"http://blog.goo.ne.jp/kuru0214", @"thumbnail": @"kuru0214.jpg"};
    NSDictionary *mamejiro040411 = @{@"blogname": @"でぶアメショと愛の無い生活。", @"url": @"http://blog.goo.ne.jp/mamejiro040411", @"thumbnail": @"mamejiro040411.jpg"};
    NSDictionary *nakachan777_2005 = @{@"blogname": @"気ままに・・・にゃん！　我が家のにゃんず", @"url": @"http://blog.goo.ne.jp/nakachan777_2005", @"thumbnail": @"nakachan777_2005.jpg"};
    NSDictionary *office_sakura = @{@"blogname": @"さくらのにゃんこ", @"url": @"http://blog.goo.ne.jp/office-sakura", @"thumbnail": @"office-sakura.jpg"};
    _bloginfo = @[kuru0214, mamejiro040411, nakachan777_2005, office_sakura];
    
    return _bloginfo;
}


@end
