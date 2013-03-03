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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
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
        cell.icon.image = [UIImage imageNamed:@"nekoicon.png"];
        cell.icon.layer.cornerRadius = 8.0;
        cell.icon.clipsToBounds = YES;
        cell.appname.text = @"ねこログ";
        cell.version.text = @"version 1.0.0";
        cell.copyright.text = @"(c) NTT Resonant Inc.";
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"AppinfoCell";
        AppinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.appinfo.text = @"ねこログは、ペットやかわいい動物ブログが多い、gooブログの中で、“ねこ”に関するブログの新着情報が閲覧できるアプリです。\n\n厳選したねこブログであなたに癒しを与えます+｡:.ﾟヽ(*´∀`)ﾉﾟ.:｡+ﾟ";
        return cell;
        
    } else if (indexPath.row == 2) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = @"ねこ好きの方必見のFacebookページ";
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = @"gooブログ公式投稿アプリ";
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
