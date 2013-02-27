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
    NSArray *_rssarray;
    NSArray *_itemarray;
    NSArray *_blogarray;
    NSMutableArray *_favoritearray;
    NSMutableDictionary *_imageCache;
    
    NSArray *_itemarray_paths;
    NSString *_itemarray_directory;
    NSString *_itemarray_filePath;

    NSArray *_blogarray_paths;
    NSString *_blogarray_directory;
    NSString *_blogarray_filePath;
    
    NSArray *_favoritearray_paths;
    NSString *_favoritearray_directory;
    NSString *_favoritearray_filePath;

    NSArray *_imagecache_paths;
    NSString *_imagecache_directory;
    NSString *_imagecache_filePath;
}

@property (nonatomic, strong) NSArray *bloginfo;

+ (BlogInfo *)sharedManager;
- (NSArray *)getRssArray;
- (void)setItemarray:(NSArray *)itemarray;
- (NSArray *)getItemarray;
- (void)setBlogarray:(NSArray *)blogarray;
- (NSArray *)getBlogarray;
- (void)setImageCache:(UIImage *)image imageurl:(NSString *)imageurl;
- (UIImage *)getImageCache:(NSString *)imageurl;
- (void)addFavoritearray:(NSDictionary *)favoritedict;
- (BOOL)removeFavoritearray:(NSInteger)index;
- (NSArray *)getFavoritevarray;
- (BOOL)checkImageCache:(NSString *)imageurl;
- (void)save;
- (void)load;

@end
