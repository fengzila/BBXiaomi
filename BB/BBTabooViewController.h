//
//  BBTabooViewController.h
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTabooTableView.h"

@interface BBTabooViewController : UIViewController<UINavigationControllerDelegate, BBTabooTableViewDelegate>
{
@private
    BBTabooTableView          *_dietView;
    BBTabooTableView          *_behaviorView;
    
    NSInteger                 _lastPosition;
    BOOL                      _tabbarIsHidden;
    
    NSArray                   *_segTitleArr;
}

@end
