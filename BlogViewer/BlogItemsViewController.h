//
//  BlogItemsViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BlogItemsViewController : UITableViewController <NSXMLParserDelegate>
{
    UIActivityIndicatorView *_indicator;
    UIRefreshControl *_refreshControl;
    
    NSNumber *_blogno;
    NSMutableArray *_itemarray;
    NSArray *_rssarray;
    NSXMLParser *_xmlparser;
    NSString *_currentelement;
    NSMutableDictionary *_itemdict;
    NSMutableString *_currenttitle;
    NSMutableString *_currentdate;
    NSMutableString *_currentlink;
    NSMutableString *_currentdescription;
    NSString *_imageurl;
}

@property (nonatomic, strong) NSNumber *blogno;

@end
