//
//  BBDueDatePickerView.m
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBDueDatePickerView.h"

@implementation BBDueDatePickerView

- (id)initWithFrame:(CGRect)frame WithDueDate:(NSString*)dueDate
{
    self = [super initWithFrame:frame];
    if (self) {
        _dueDate = dueDate;
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor clearColor];

        [self addSubview:_bgView];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 120 + 216 + 46)];
        [self addSubview:_containerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimation)];
        [self addGestureRecognizer:tap];
        
        UIImageView *containerBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _containerView.width, 120)];
        containerBgImg.image = [UIImage imageNamed:@"bg_input"];
        
        [_containerView addSubview:containerBgImg];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, _containerView.width - 40, 30)];
        _tipsLabel.text = @"请选择您的预产期";
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        [_containerView addSubview:_tipsLabel];
        
        NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:15.f],UITextAttributeFont, nil];
        NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:15.f],UITextAttributeFont, nil];
        
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"预产期", @"末次月经时间"]];
        [_segmentedControl setFrame:CGRectMake(kDeviceWidth / 2 - 250 / 2, containerBgImg.height - 45 - 15, 250, 45)];
        [_segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
        
        _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        _segmentedControl.tintColor = kPink;
        _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
        [_segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
        [_containerView addSubview:_segmentedControl];
        
        _picker = [[UIDatePicker alloc] init];
        // 设置时区
        [_picker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        // 设置UIDatePicker的显示模式
        [_picker setDatePickerMode:UIDatePickerModeDate];
        _picker.backgroundColor = kGray;
        [self setPickerByDueDate];
        
        _picker.frame = CGRectMake(0, containerBgImg.height, self.width, 216);
        [_containerView addSubview:_picker];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        {
            [commitBtn setFrame:CGRectMake(15, containerBgImg.height + _picker.height, self.width - 15 * 2, 46)];
        }
        else
        {
            [commitBtn setFrame:CGRectMake(0, containerBgImg.height + _picker.height, self.width, 46)];
        }
        [commitBtn addTarget:self action:@selector(commitBtnTouch) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_big"] forState:UIControlStateNormal];
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_big_press"] forState:UIControlStateHighlighted];
        [_containerView addSubview:commitBtn];
        
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, containerBgImg.height + _picker.height, self.width - 15 * 2, 46)];
        btnLabel.text = @"确定";
        btnLabel.backgroundColor = [UIColor clearColor];
        btnLabel.textColor = [UIColor whiteColor];
        btnLabel.textAlignment = NSTextAlignmentCenter;
        btnLabel.font = [UIFont boldSystemFontOfSize:20];
        [_containerView addSubview:btnLabel];
    }
    return self;
}

- (void)showWithAnimation
{
    [UIView animateWithDuration:0.6
                     animations:^{
                         _bgView.backgroundColor = [UIColor blackColor];
                         _bgView.alpha = 0.6f;
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                         {
                             _containerView.frame = CGRectMake(0, kDeviceHeight - 120 - 216 - 46 - 44 - 18, kDeviceWidth, 120 + 216 + 46);
                         }
                         else
                         {
                             _containerView.frame = CGRectMake(0, kDeviceHeight - 120 - 216 - 46 - 44, kDeviceWidth, 120 + 216 + 46);
                         }
                     }];
}

- (void)hiddenWithAnimation
{
    _bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.6
                     animations:^{
                         _containerView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 120 + 216 + 46);
                         [self.delegate removeDatePicker];
                     }];
}

- (void)segmentAction:(UISegmentedControl*)sender
{
    NSLog(@"segmentAction------%d", sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex == 0)
    {
        _tipsLabel.text = @"请选择老婆大人的预产期。";
        _tipsLabel.frame = CGRectMake(20, 10, _containerView.width - 40, 30);
        
        [self setPickerByDueDate];
    }
    else
    {
        _tipsLabel.text = @"请选择老婆大人最后一次月经的第一天，小秘会自动帮你计算出预产期。";
        _tipsLabel.frame = CGRectMake(20, 5, _containerView.width - 40, 60);
        
        [self setPickerByMenses];
    }
}

// 按照预产期设置picker
- (void)setPickerByDueDate
{
    // 排除前两周
    NSInteger tenMonthDiff = 38 * 7 * 24 * 60 * 60;
    // 设置当前显示时间
    if (_dueDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate *date=[formatter dateFromString:_dueDate];
        [_picker setDate:date animated:YES];
    }
    else
    {
        [_picker setDate:[NSDate dateWithTimeIntervalSinceNow:tenMonthDiff] animated:YES];
    }
    // 设置显示最小时间（此处为当前时间）
    [_picker setMinimumDate:[NSDate date]];
    // 设置显示最大时间（向之后的时间推十个月）
    [_picker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:tenMonthDiff]];
}

// 按照末次月经设置picker
- (void)setPickerByMenses
{
    NSInteger tenMonthDiff = 40 * 7 * 24 * 60 * 60;
    // 设置当前显示时间
    if (_dueDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dueDate= [dateFormatter dateFromString:_dueDate];
        
        NSDate *destDate = [dueDate dateByAddingTimeInterval:-tenMonthDiff];
        [_picker setDate:destDate animated:YES];
    }
    else
    {
        [_picker setDate:[NSDate dateWithTimeIntervalSinceNow:-1 * 30 * 24 * 60 * 60] animated:YES];
    }
    // 设置显示最小时间（此处为向过去时间推10个月）
    [_picker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:-tenMonthDiff]];
    // 设置显示最大时间（此处为当前时间）
    [_picker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:-2 * 7 * 24 * 60 * 60]];
}

- (void)commitBtnTouch
{
    NSDate *selected = [_picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    if (_segmentedControl.selectedSegmentIndex == 1)
    {
        // 输入的末次月经时间
//        NSArray *dateArr = [destDateString componentsSeparatedByString:@"-"];
//        NSInteger y = [[dateArr objectAtIndex:0] intValue];
//        NSInteger m = [[dateArr objectAtIndex:1] intValue];
//        NSInteger d = [[dateArr objectAtIndex:2] intValue];
        
        // 末次月经日期
        NSDate *mensesDate = [dateFormatter dateFromString:destDateString];
        
        NSDate *destDate = [mensesDate dateByAddingTimeInterval:40 * 7 * 24 * 60 * 60];
        destDateString = [dateFormatter stringFromDate:destDate];
    }

    [self.delegate datePickerSelectValue:destDateString];
    [self hiddenWithAnimation];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
