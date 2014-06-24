//
//  BBCookViewController.h
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCycleScrollView.h"
#import "BBDatePickerView.h"
#import "BBChangeView.h"
#import "BBCycleScrollCell.h"
#import "BBUserBaseInfoView.h"
#import "DCPathButton.h"
#import "UMSocial.h"
#import "GADBannerView.h"

@interface BBCookViewController : UIViewController<BBCycleScrollViewDatasource, BBCycleScrollViewDelegate, BBDatePickerViewDelegate, UIScrollViewDelegate, BBCycleScrollCellDelegate, BBChangeViewDelegate, UINavigationControllerDelegate, BBUserBaseInfoViewDelegate, UIAlertViewDelegate, DCPathButtonDelegate, UMSocialUIDelegate>
{
@private
    UIView              *_listView;
    BBCycleScrollView   *_csView;
    BBChangeView        *_helpView;
    BBDatePickerView    *_pickerView;
    BBUserBaseInfoView  *_userBaseView;
    UIView              *_newUserView;
    UIImageView         *_itemBaseView;
    UIView              *_moreBtnsView;
    DCPathButton        *_dcPathButton;
    GADBannerView       *_adBannerView;
    
    NSString            *_curWeek;
    NSArray             *_data;
    int                 _lastPosition;
    BOOL                _tabbarIsHidden;
}

@end
