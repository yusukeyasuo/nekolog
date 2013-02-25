//
//  BlogInfo.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/18.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "BlogInfo.h"

@implementation BlogInfo


static BlogInfo *_sharedInstance = nil;

+ (BlogInfo *)sharedManager
{
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

- (NSArray *)getRssArray
{
    _rssarray = @[@"http://blog.goo.ne.jp/kuru0214/rss2.xml",
                  @"http://blog.goo.ne.jp/mamejiro040411/rss2.xml",
                  @"http://blog.goo.ne.jp/nakachan777_2005/rss2.xml",
                  @"http://blog.goo.ne.jp/office-sakura/rss2.xml",
                  @"http://blog.goo.ne.jp/cat-margaux/rss2.xml",
                  @"http://blog.goo.ne.jp/e3goo12/rss2.xml",
                  @"http://blog.goo.ne.jp/amoryoryo/rss2.xml",
                  @"http://blog.goo.ne.jp/happy-kris/rss2.xml",
                  @"http://blog.goo.ne.jp/yu_no_neko/rss2.xml",
                  @"http://blog.goo.ne.jp/hanamaruday/rss2.xml",
                  @"http://blog.goo.ne.jp/sarang_2005/rss2.xml",
                  @"http://blog.goo.ne.jp/hinatamc/rss2.xml",
                  @"http://blog.goo.ne.jp/kijimuna5963/rss2.xml",
                  @"http://blog.goo.ne.jp/nekoosaki/rss2.xml",
                  @"http://blog.goo.ne.jp/4cat/rss2.xml",
                  @"http://blog.goo.ne.jp/tummy2010/rss2.xml",
                  @"http://blog.goo.ne.jp/mijimiji_0401/rss2.xml",
                  @"http://blog.goo.ne.jp/jack_bauer_ctu_la/rss2.xml"];

    
    return _rssarray;
}

- (void)setItemarray:(NSArray *)itemarray
{
    _itemarray = [[NSArray alloc] init];
    _itemarray = itemarray;
    [self save];
}

- (NSArray *)getItemarray
{
    return _itemarray;
}

- (void)setBlogarray:(NSArray *)blogarray
{
    _blogarray = [[NSArray alloc] init];
    _blogarray = blogarray;
    [self save];
}

- (NSArray *)getBlogarray
{
    return _blogarray;
}

- (void)addFavoritearray:(NSDictionary *)favoritedict
{
    if (!_favoritearray) {
        _favoritearray = [[NSMutableArray alloc] init];
    }
    [_favoritearray addObject:favoritedict];
    [self save];
}

- (NSArray *)getFavoritevarray
{
    return _favoritearray;
}

- (void)setImageCache:(UIImage *)image imageurl:(NSString *)imageurl
{
    if (!_imageCache) {
        _imageCache =[[NSMutableDictionary alloc] init];
    }
    [_imageCache setObject:image forKey:imageurl];
    //[self save];
}

- (UIImage *)getImageCache:(NSString *)imageurl
{
    if ([[_imageCache allKeys] containsObject:imageurl]) {
        return [_imageCache objectForKey:imageurl];
    }
    return nil;
}

- (BOOL)checkImageCache:(NSString *)imageurl
{
    return [[_imageCache allKeys] containsObject:imageurl];
}

// 永続化
- (void)save
{
    // _itemarray
    _itemarray_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _itemarray_directory = [_itemarray_paths objectAtIndex:0];
    _itemarray_filePath = [_itemarray_directory stringByAppendingPathComponent:@"itemarray_data.dat"];
    [NSKeyedArchiver archiveRootObject:_itemarray toFile:_itemarray_filePath];
    
    // _blogarray
    _blogarray_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _blogarray_directory = [_blogarray_paths objectAtIndex:0];
    _blogarray_filePath = [_blogarray_directory stringByAppendingPathComponent:@"blogarray_data.dat"];
    [NSKeyedArchiver archiveRootObject:_blogarray toFile:_blogarray_filePath];
    
    // favoritearray
    _favoritearray_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _favoritearray_directory = [_favoritearray_paths objectAtIndex:0];
    _favoritearray_filePath = [_favoritearray_directory stringByAppendingPathComponent:@"favoritearray_data.dat"];
    [NSKeyedArchiver archiveRootObject:_favoritearray toFile:_favoritearray_filePath];
    
    // imagecache
    _imagecache_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _imagecache_directory = [_imagecache_paths objectAtIndex:0];
    _imagecache_filePath = [_imagecache_directory stringByAppendingPathComponent:@"imagecache_data.dat"];
    [NSKeyedArchiver archiveRootObject:_imageCache toFile:_imagecache_filePath];
}

- (void)load
{
    // _itemarray
    _itemarray_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _itemarray_directory = [_itemarray_paths objectAtIndex:0];
    _itemarray_filePath = [_itemarray_directory stringByAppendingPathComponent:@"itemarray_data.dat"];
    _itemarray = [NSKeyedUnarchiver unarchiveObjectWithFile:_itemarray_filePath];
    
    // _blogarray
    _blogarray_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _blogarray_directory = [_blogarray_paths objectAtIndex:0];
    _blogarray_filePath = [_blogarray_directory stringByAppendingPathComponent:@"blogarray_data.dat"];
    _blogarray = [NSKeyedUnarchiver unarchiveObjectWithFile:_blogarray_filePath];
    
    // favoritearray
    _favoritearray_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _favoritearray_directory = [_favoritearray_paths objectAtIndex:0];
    _favoritearray_filePath = [_favoritearray_directory stringByAppendingPathComponent:@"favoritearray_data.dat"];
    _favoritearray = [NSKeyedUnarchiver unarchiveObjectWithFile:_favoritearray_filePath];
    
    // imagecache
    _imagecache_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _imagecache_directory = [_imagecache_paths objectAtIndex:0];
    _imagecache_filePath = [_imagecache_directory stringByAppendingPathComponent:@"imagecache_data.dat"];
    _imageCache = [NSKeyedUnarchiver unarchiveObjectWithFile:_imagecache_filePath];
}

@end
