//
//  FavoriteWebViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/05.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FavoriteWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    NSDictionary *_itemdict;
    NSString *_blogurl;
    NSArray *_shareitems;
    UIActionSheet *_actionsheet;
    IBOutlet UIActivityIndicatorView *_indicator;
    IBOutlet UIBarButtonItem *_gobackbutton;
    IBOutlet UIBarButtonItem *_goforwardbutton;
    IBOutlet UIBarButtonItem *_refreshbutton;
    IBOutlet UIWebView *_webview;
    IBOutlet UIBarButtonItem *_favoritebutton;
    
    BOOL _favoritestatus;
}

@property (nonatomic, strong) NSDictionary *itemdict;

- (IBAction)pressFavoriteButton:(id)sender;


@end
