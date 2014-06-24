//
//  BBMoreViewController.h
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface BBMoreViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
@private
    NSMutableArray  *_data;
    
    GADBannerView   *_adBannerView;
}
@end
