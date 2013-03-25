//
//  ImagesViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UICollectionViewController <NSXMLParserDelegate>
{
    UIActivityIndicatorView *_indicator;
    UIRefreshControl *_refreshControl;
    
    NSNumber *_blogno;
    NSMutableArray *_itemarray;
    NSArray *_rssarray;
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
    BOOL _inimage;
    int _rssno;
    BOOL _refreshFlg;
}
- (IBAction)pressRefreshButton:(id)sender;

@end
