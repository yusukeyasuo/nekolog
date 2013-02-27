//
//  FavoriteViewController.m
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "FavoriteViewController.h"
#import "BlogInfo.h"
#import "ItemCell.h"
#import "AFNetworking.h"
#import "WebViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    _favoritearray = [[BlogInfo sharedManager] getFavoritevarray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ItemCell *cell = sender;
    WebViewController *webController = segue.destinationViewController;
    webController.hidesBottomBarWhenPushed = YES;
    webController.itemdict = _favoritearray[cell.tag];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favoritearray.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    
    if (!cell) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = [_favoritearray objectAtIndex:indexPath.row];
    
    NSDate *date = [dict objectForKey:@"date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSString *datestr = [formatter stringFromDate:date];
    
    cell.tag = indexPath.row;
    cell.thumbnail.image = [[UIImage alloc] init];
    cell.itemtitle.text = [dict objectForKey:@"title"];
    cell.blogtitle.text = [dict objectForKey:@"blog"];
    cell.updated.text = datestr;
    
    NSString *imageurl = [dict objectForKey:@"imageurl"];
    if (imageurl.length < 5) {
        [cell.thumbnail setImage:[UIImage imageNamed:@"noimage.gif"]];
        CALayer *layer = [cell.thumbnail layer];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth: 1.f];
        [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    } else {
        __block ItemCell *bCell = cell;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dict objectForKey:@"imageurl"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
        [cell.thumbnail setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *_image) {
                                       [[BlogInfo sharedManager] setImageCache:_image imageurl:[dict objectForKey:@"imageurl"]];
                                       [bCell.thumbnail setImage:_image];
                                       CALayer *layer = [bCell.thumbnail layer];
                                       [layer setMasksToBounds:YES];
                                       [layer setBorderWidth: 1.f];
                                       [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   }];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([[BlogInfo sharedManager] removeFavoritearray:indexPath.row]) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
