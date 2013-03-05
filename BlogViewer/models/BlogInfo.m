//
//  BlogInfo.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/18.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "BlogInfo.h"
#import "AFNetworking.h"

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

- (void)getRssArraywithCompletion:(void(^)(NSArray *responceObject, NSError *error))completion
{
    NSString *urlStr = @"http://133.242.129.55/work/blog.php";
    //NSString *urlStr = @"http://133.242.129.55/work/blog2.php";
    //NSString *urlStr = @"http://blg615.goo.ne.jp/nekolog.php";
    //NSString *urlStr = @"http://blg615.goo.ne.jp/sp_recommend_blog/cat";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0f];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        if (error) {
            completion(nil, error);
            return;
        }
        completion(jsonObject, nil);
        return;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        return;
    }];
    [operation start];
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
    
    for (int i = 0; i < _favoritearray.count; i++)
    {
        if ([[_favoritearray[i] objectForKey:@"link"] isEqualToString:[favoritedict objectForKey:@"link"]])
        {
            [self removeFavoritearray:i];
            return;
        }
    }
    [_favoritearray insertObject:favoritedict atIndex:0];
    //[self save];
}

- (NSArray *)getFavoritevarray
{
    return _favoritearray;
}

- (BOOL)removeFavoritearray:(NSInteger)index
{
    if (index >= _favoritearray.count || index < 0) {
        return false;
    }
    [_favoritearray removeObjectAtIndex:index];
    return true;
}

- (void)setImageCache:(UIImage *)image imageurl:(NSString *)imageurl
{
    if (!_imageCache) {
        _imageCache =[[NSMutableDictionary alloc] init];
    }
    if (![[_imageCache allKeys] containsObject:imageurl]) {
        [_imageCache setObject:image forKey:imageurl];
    }
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
    /*
    _imagecache_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _imagecache_directory = [_imagecache_paths objectAtIndex:0];
    _imagecache_filePath = [_imagecache_directory stringByAppendingPathComponent:@"imagecache_data.dat"];
    [NSKeyedArchiver archiveRootObject:_imageCache toFile:_imagecache_filePath];
    */
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
    /*
    _imagecache_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _imagecache_directory = [_imagecache_paths objectAtIndex:0];
    _imagecache_filePath = [_imagecache_directory stringByAppendingPathComponent:@"imagecache_data.dat"];
    _imageCache = [NSKeyedUnarchiver unarchiveObjectWithFile:_imagecache_filePath];
    */
}

@end
