//
//  ItemsViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController <NSXMLParserDelegate>
{
    IBOutlet UISegmentedControl *_popular_new;
    UIRefreshControl *_refreshControl;
    UIActivityIndicatorView *_indicator;
    
    NSArray *_rssarray;
    NSMutableArray *_itemarray;
    NSXMLParser *_xmlparser;
    NSString *_currentelement;
    NSMutableDictionary *_itemdict;
    NSMutableString *_currentblog;
    NSMutableString *_currenttitle;
    NSMutableString *_currentdate;
    NSMutableString *_currentlink;
    NSMutableString *_currentdescription;
    NSString *_imageurl;
    BOOL _initem;
    int _rssno;
}
- (IBAction)pressRefreshButton:(id)sender;

@end
