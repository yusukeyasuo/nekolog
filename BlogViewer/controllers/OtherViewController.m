//
//  OtherViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "OtherViewController.h"
#import "ApptitleCell.h"
#import "AppinfoCell.h"
#import "TextCell.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GAI sharedInstance].defaultTracker trackView:@"OtherViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80.0f;
    } else if (indexPath.row == 1) {
        return 111.0f;
    } else {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"ApptitleCell";
        ApptitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.icon.image = [UIImage imageNamed:@"icon.png"];
        cell.icon.layer.cornerRadius = 8.0;
        cell.icon.clipsToBounds = YES;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"AppinfoCell";
        AppinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
        
    } else if (indexPath.row == 2) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = @"ねこ好き必見のFacebookページ";
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = @"gooブログ公式投稿アプリ";
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) { // facebook
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/204845989642548"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/blog.goo.ne.jp"]];
        }
    } else if (indexPath.row == 3) { // gooblog app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/jp/app/gooburogu/id543105971"]];
    }
    
}

@end
