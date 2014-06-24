//
//  BBUserBaseInfoView.h
//  BB
//
//  Created by FengZi on 14-1-28.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBDueDatePickerView.h"

@protocol BBUserBaseInfoViewDelegate <NSObject>

- (void)afterCommit;

@end

@interface BBUserBaseInfoView : UIView<UITextFieldDelegate, BBDueDatePickerViewDelegate>
{
    UITextField         *_ageTextField;
    UITextField         *_heightTextField;
    UITextField         *_weightTextField;
    UITextField         *_dueDateTextField;
    BBDueDatePickerView *_dueDatePickerView;
}
@property (nonatomic) id <BBUserBaseInfoViewDelegate> delegate;
@end
