//
//  WebViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/19.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "WebViewController.h"
#import "BlogInfo.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize itemdict = _itemdict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _blogurl = [[_itemdict objectForKey:@"link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _blogurl = [_blogurl stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.title = [_itemdict objectForKey:@"title"];
    
    // シェア方法を選択
    _shareitems = @[@"Twitterに投稿", @"Facebookに投稿", @"Safariで開く", @"お気に入りに登録"];
    
    _indicator.hidden = NO;
    [_indicator startAnimating];
    
    NSURL *url = [[NSURL alloc] initWithString:_blogurl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActionsheet:(id)sender
{
    _actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in _shareitems)
    {
        [_actionsheet addButtonWithTitle:title];
    }
    _actionsheet.cancelButtonIndex = [_actionsheet addButtonWithTitle:@"キャンセル"];
    [_actionsheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *sharestr = [NSString stringWithFormat:@"%@ #ねこログ", [_itemdict objectForKey:@"title"]];
    if (buttonIndex == 0) {
        SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposeViewController setInitialText:sharestr];
        [slComposeViewController addURL:[NSURL URLWithString:_blogurl]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [slComposeViewController setInitialText:sharestr];
        [slComposeViewController addURL:[NSURL URLWithString:_blogurl]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else if (buttonIndex == 2) {
        NSURL *safari = [NSURL URLWithString:_blogurl];
        [[UIApplication sharedApplication] openURL:safari];
    } else if (buttonIndex == 3) {
        [[BlogInfo sharedManager] addFavoritearray:_itemdict];
    }
}

#pragma mark - WebView delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    _indicator.hidden = YES;
    [_indicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _gobackbutton.enabled = webView.canGoBack;
    _goforwardbutton.enabled = webView.canGoForward;
    
    if (webView.canGoBack) {
        _gobackbutton.enabled = YES;
    } else {
        _gobackbutton.enabled = NO;
    }
    
    if (webView.canGoForward) {
        _goforwardbutton.enabled = YES;
    } else {
        _goforwardbutton.enabled = NO;
    }
}



@end