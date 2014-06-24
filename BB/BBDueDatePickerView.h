//
//  BBDueDatePickerView.h
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBDueDatePickerViewDelegate <NSObject>

- (void)removeDatePicker;
- (void)datePickerSelectValue:(NSString*)value;

@end

@interface BBDueDatePickerView : UIView
{
@private
    UIView          *_bgView;
    UIView          *_containerView;
    UIDatePicker    *_picker;
    UILabel         *_tipsLabel;
    
    UISegmentedControl *_segmentedControl;
}
@property (nonatomic) id <BBDueDatePickerViewDelegate> delegate;
@property (nonatomic) NSString* dueDate;

- (id)initWithFrame:(CGRect)frame WithDueDate:(NSString*)dueDate;
- (void)showWithAnimation;
- (void)hiddenWithAnimation;
@end
