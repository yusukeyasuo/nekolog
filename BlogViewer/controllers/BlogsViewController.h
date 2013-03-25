//
//  BlogsViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BlogsViewController : UITableViewController <NSXMLParserDelegate>
{
    UIActivityIndicatorView *_indicator;
    UIRefreshControl *_refreshControl;
    
    NSArray *_rssarray;
    NSMutableArray *_blogarray;
    NSXMLParser *_xmlparser;
    NSMutableDictionary *_blogdict;
    
    NSString *_currentelement;
    NSMutableString *_currentblog;
    NSMutableString *_currentimage;
    NSMutableString *_currentdate;
    
    int _rssno;
    BOOL _initem;
    BOOL _inimage;
    BOOL _refreshFlg;
}
- (IBAction)pressRefreshButton:(id)sender;


@end
