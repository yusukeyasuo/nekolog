//
//  AppDelegate.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "AppDelegate.h"
#import "BlogInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google Analyticsの設定
    
    // Exceptionのトラッキングはしない
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // トラッキング間隔は10秒
    [GAI sharedInstance].dispatchInterval = 10;
    // デバック出力はしない
    [GAI sharedInstance].debug = NO;
    // 通信にはHTTPSを使用する
    [[GAI sharedInstance].defaultTracker setUseHttps:YES];
    // トラッキングIDを設定
     [[GAI sharedInstance] trackerWithTrackingId:@"UA-38979150-1"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //NSLog(@"WillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //NSLog(@"DidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //NSLog(@"WillEnterForground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //NSLog(@"DidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //NSLog(@"WillTerminate");
}

// NW接続状況の確認
- (BOOL)checkNetworkAccess
{
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    }
    return YES;
}


@end
