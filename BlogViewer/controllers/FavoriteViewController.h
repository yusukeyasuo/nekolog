//
//  FavoriteViewController.h
//  BlogViewer
//
//  Created by yusuke_yasuo on 2013/02/15.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FavoriteViewController : UITableViewController
{
    IBOutlet UIBarButtonItem *_editbutton;
    
    NSArray *_favoritearray;
}

@end
