//
//  BBDatePickerView.h
//  BB
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBPickerView.h"

@protocol BBDatePickerViewDelegate <NSObject>

- (void)selectedRow:(int)row withString:(NSString *)text;

@end

@interface BBDatePickerView : UIView<BBPickerViewDelegate, BBPickerViewDataSource>
{
@private
    BBPickerView            *_picker;
    NSMutableArray          *_data;
    NSString                *_date;
}

@property (nonatomic) id <BBDatePickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithDate:(NSString*)date;
- (void)setDate:(NSString*)date;
@end
