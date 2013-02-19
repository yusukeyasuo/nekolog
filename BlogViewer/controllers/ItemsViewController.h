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
    NSArray *_rssarray;
    int _rssno;
    NSMutableArray *_itemarray;
    IBOutlet UISegmentedControl *_popular_new;
    NSXMLParser *_xmlparser;
    NSString *_currentelement;
    NSMutableDictionary *_itemdict;
    NSMutableString *_currentblog;
    NSMutableString *_currenttitle;
    NSMutableString *_currentdate;
    NSMutableString *_currentlink;
    NSMutableString *_currentdescription;
    BOOL _initem;
}

@end
