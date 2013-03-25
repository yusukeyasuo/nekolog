//
//  FavoriteWebViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/03/05.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "FavoriteWebViewController.h"
#import "AppDelegate.h"
#import "BlogInfo.h"

@interface FavoriteWebViewController ()

@end

@implementation FavoriteWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *gaStr = [NSString stringWithFormat:@"FavoriteWebViewController|%@", [_itemdict objectForKey:@"link"]];
    [[GAI sharedInstance].defaultTracker trackView:gaStr];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate checkNetworkAccess])
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"インターネット接続がオフラインのようです。"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
	// Do any additional setup after loading the view.
    _blogurl = [[_itemdict objectForKey:@"link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _blogurl = [_blogurl stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.title = [_itemdict objectForKey:@"title"];
    
    // お気に入りに登録されているか確認
    for (NSDictionary *dict in [[BlogInfo sharedManager] getFavoritevarray])
    {
        if ([[dict objectForKey:@"link"] isEqualToString:[_itemdict objectForKey:@"link"]])
        {
            _favoritebutton.image = [UIImage imageNamed:@"favorite.png"];
            _favoritestatus = YES;
            break;
        } else {
            _favoritestatus = NO;
        }
    }
    
    // シェア方法を選択
    _shareitems = @[@"Twitterに投稿", @"Facebookに投稿", @"Safariで開く", @"通報する"];
    
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

- (IBAction)pressFavoriteButton:(id)sender
{
    if (_favoritestatus) {
        _favoritebutton.image = [UIImage imageNamed:@"star.png"];
        _favoritestatus = NO;
    } else {
        _favoritebutton.image = [UIImage imageNamed:@"favorite.png"];
        _favoritestatus = YES;
    }
    [[BlogInfo sharedManager] addFavoritearray:_itemdict];
}

- (void)showMailView
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"blogoo@nttr.co.jp"]];
    [picker setSubject:@"記事の通報 - ねこログ"];
    NSString *emailBody = [NSString stringWithFormat:@"以下の記事を通報します。\n\n【記事タイトル】\n%@\n【記事URL】\n%@\n【通報理由】\n ", _itemdict[@"title"], _itemdict[@"link"]];
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
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
        [slComposeViewController addURL:[NSURL URLWithString:_blogurl]];
        [self presentViewController:slComposeViewController animated:YES completion:nil];
    } else if (buttonIndex == 2) {
        NSURL *safari = [NSURL URLWithString:_blogurl];
        [[UIApplication sharedApplication] openURL:safari];
    } else if (buttonIndex == 3) {
        Class mail = (NSClassFromString(@"MFMailComposeViewController"));
        if (mail != nil){
            if ([mail canSendMail]){
                [self showMailView];
            } else {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"メールの起動ができませんでした。\nメールの設定をしてからご利用ください。"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            // save
            break;
        case MFMailComposeResultSent:
            // sent
            break;
        case MFMailComposeResultFailed:
            // failed
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"インターネット接続がオフラインのようです。"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
