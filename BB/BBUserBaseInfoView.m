//
//  BBUserBaseInfoView.m
//  BB
//
//  Created by FengZi on 14-1-28.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBUserBaseInfoView.h"

@implementation BBUserBaseInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *baseView = [[UIView alloc] initWithFrame:self.frame];
        baseView.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
        [self addSubview:baseView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
        [baseView addGestureRecognizer:tap];
        
        UIView *inputContanerView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth - 15 * 2, kDeviceHeight - 180)];
        inputContanerView.backgroundColor = [UIColor whiteColor];
        inputContanerView.layer.masksToBounds = YES;
        inputContanerView.layer.cornerRadius = 10.0;
        [inputContanerView addGestureRecognizer:tap];
        [self addSubview:inputContanerView];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        NSString *ageStr = [ud objectForKey:kUserBaseInfoAge];
        NSString *heightStr = [ud objectForKey:kUserBaseInfoHeight];
        NSString *weightStr = [ud objectForKey:kUserBaseInfoWeight];
        NSString *dueDateStr = [ud objectForKey:kUserBaseInfoDueDate];
        
        NSInteger height = 30;
        NSInteger rowHeight = 35;
        NSInteger textFieldPadding = 10;
        NSInteger unitPadding = 5;
        
        UIColor *unitColor = [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1];
        // 创建年龄
        UILabel *ageTitleLabel = [self titleLabelWithStr:@"年龄"];
        ageTitleLabel.frame = CGRectMake(10, height + 10, 80, rowHeight);
        [inputContanerView addSubview:ageTitleLabel];
        
        _ageTextField = [self inputTextFileWithStr:ageStr];
        _ageTextField.frame = CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + textFieldPadding, height + 10, inputContanerView.width - 30 - ageTitleLabel.width - 60, rowHeight);
        _ageTextField.tag = 1;
        [inputContanerView addSubview:_ageTextField];
        
        UILabel *ageUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + 10 + _ageTextField.width + unitPadding, height + 10, 50, rowHeight)];
        ageUnitLabel.text = @"周岁";
        ageUnitLabel.contentMode = UIViewContentModeLeft;
        ageUnitLabel.textColor = unitColor;
        [inputContanerView addSubview:ageUnitLabel];
        
        height += ageTitleLabel.height + 15;
        
        // 创建身高
        UILabel *heightTitleLabel = [self titleLabelWithStr:@"身高"];
        heightTitleLabel.frame = CGRectMake(10, height + 10, 80, rowHeight);
        [inputContanerView addSubview:heightTitleLabel];
        
        _heightTextField = [self inputTextFileWithStr:heightStr];
        _heightTextField.frame = CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + textFieldPadding, height + 10, inputContanerView.width - 30 - ageTitleLabel.width - 60, rowHeight);
        [inputContanerView addSubview:_heightTextField];
        _heightTextField.tag = 2;
        
        UILabel *heightUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + 10 + _ageTextField.width + unitPadding, height + 10, 50, rowHeight)];
        heightUnitLabel.text = @"cm";
        heightUnitLabel.contentMode = UIViewContentModeLeft;
        [inputContanerView addSubview:heightUnitLabel];
        heightUnitLabel.textColor = unitColor;
        
        height += heightTitleLabel.height + 15;
        
        // 创建孕前体重
        UILabel *weightTitleLabel = [self titleLabelWithStr:@"孕前体重"];
        weightTitleLabel.frame = CGRectMake(10, height + 10, 80, rowHeight);
        [inputContanerView addSubview:weightTitleLabel];
        
        _weightTextField = [self inputTextFileWithStr:weightStr];
        _weightTextField.frame = CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + textFieldPadding, height + 10, inputContanerView.width - 30 - ageTitleLabel.width - 60, rowHeight);
        [inputContanerView addSubview:_weightTextField];
        _weightTextField.tag = 3;
        
        UILabel *weightUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + 10 + _ageTextField.width + unitPadding, height + 10, 50, rowHeight)];
        weightUnitLabel.text = @"kg";
        weightUnitLabel.contentMode = UIViewContentModeLeft;
        [inputContanerView addSubview:weightUnitLabel];
        weightUnitLabel.textColor = unitColor;
        
        height += weightTitleLabel.height + 15;
        
        // 创建预产期
        UILabel *dueDateTitleLabel = [self titleLabelWithStr:@"预产期"];
        dueDateTitleLabel.frame = CGRectMake(10, height + 10, 80, rowHeight);
        [inputContanerView addSubview:dueDateTitleLabel];
        
        _dueDateTextField = [self inputTextFileWithStr:dueDateStr];
        _dueDateTextField.frame = CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + textFieldPadding, height + 10, inputContanerView.width - 30 - ageTitleLabel.width - 60, rowHeight);
        [inputContanerView addSubview:_dueDateTextField];
        _dueDateTextField.tag = 4;
        
        UIButton *duedateUnitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [duedateUnitBtn setFrame:CGRectMake(ageTitleLabel.origin.x + ageTitleLabel.width + 10 + _ageTextField.width, height + 8, 41, 41)];
        [duedateUnitBtn addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [duedateUnitBtn setBackgroundImage:[UIImage imageNamed:@"editWeek"] forState:UIControlStateNormal];
        
        [inputContanerView addSubview:duedateUnitBtn];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitBtn setFrame:CGRectMake(kDeviceWidth / 2 - inputContanerView.width / 2, inputContanerView.height + 30, inputContanerView.width, 46)];
        [commitBtn addTarget:self action:@selector(commitBtnTouch) forControlEvents:UIControlEventTouchUpInside];
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_big"] forState:UIControlStateNormal];
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"btn_big_press"] forState:UIControlStateHighlighted];
        [baseView addSubview:commitBtn];
        
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth / 2 - inputContanerView.width / 2, inputContanerView.height + 30, inputContanerView.width, 46)];
        btnLabel.text = @"确定";
        btnLabel.backgroundColor = [UIColor clearColor];
        btnLabel.textColor = [UIColor whiteColor];
        btnLabel.textAlignment = NSTextAlignmentCenter;
        btnLabel.font = [UIFont boldSystemFontOfSize:20];
        [baseView addSubview:btnLabel];
        
        _dueDatePickerView = [[BBDueDatePickerView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight) WithDueDate:dueDateStr];
        _dueDatePickerView.delegate = self;
        [self addSubview:_dueDatePickerView];
    }
    return self;
}

- (UILabel*)titleLabelWithStr:(NSString*)str
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [NSString stringWithFormat:@"%@", str];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return titleLabel;
}

- (UITextField*)inputTextFileWithStr:(NSString*)str
{
    UITextField *textField = [[UITextField alloc] init];
    textField.background = [UIImage imageNamed:@"bg_inputField"];
    // 外框类型
    [textField setBorderStyle:UITextBorderStyleNone];
    // 是否以密码形式显示
    textField.secureTextEntry = NO;
    // 默认显示内容
    textField.text = str;
    // 键盘显示类型
    textField.keyboardType = UIKeyboardTypeNumberPad;
    // 键盘返回类型
    textField.returnKeyType = UIReturnKeyDone;
    // 设置居中输入
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.userInteractionEnabled = YES;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    
    return textField;
}

- (void)removeKeyboard
{
    NSLog(@"removeKeyBoard-----");
    [_ageTextField resignFirstResponder];
    [_heightTextField resignFirstResponder];
    [_weightTextField resignFirstResponder];
    [_dueDateTextField resignFirstResponder];
    if (_dueDatePickerView.tag == 1)
    {
        [_dueDatePickerView hiddenWithAnimation];
        _dueDatePickerView.tag = 2;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"removeKeyBoard-----tag is %d", textField.tag);
    [self removeKeyboard];
    if (textField.tag == 4)
    {
        [self showDatePicker];
        return NO;
    }
    return YES;
}

- (void)commitBtnTouch
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSInteger age = [_ageTextField.text intValue];
    if (age > 60 || age < 15)
    {
        _ageTextField.background = [UIImage imageNamed:@"bg_inputField_error"];
        return;
    }
    _ageTextField.background = [UIImage imageNamed:@"bg_inputField"];
    
    NSInteger height = [_heightTextField.text intValue];
    if (height > 220 || height < 50)
    {
        _heightTextField.background = [UIImage imageNamed:@"bg_inputField_error"];
        return;
    }
    _heightTextField.background = [UIImage imageNamed:@"bg_inputField"];
    
    NSInteger weight = [_weightTextField.text intValue];
    if (weight > 220 || weight < 20)
    {
        _weightTextField.background = [UIImage imageNamed:@"bg_inputField_error"];
        return;
    }
    _weightTextField.background = [UIImage imageNamed:@"bg_inputField"];
    
    if (_dueDateTextField.text.length == 0)
    {
        _dueDateTextField.background = [UIImage imageNamed:@"bg_inputField_error"];
        return;
    }
    _dueDateTextField.background = [UIImage imageNamed:@"bg_inputField"];
    
    [ud setObject:_ageTextField.text forKey:kUserBaseInfoAge];
    [ud setObject:_heightTextField.text forKey:kUserBaseInfoHeight];
    [ud setObject:_weightTextField.text forKey:kUserBaseInfoWeight];
    [ud setObject:_dueDateTextField.text forKey:kUserBaseInfoDueDate];
    [ud synchronize];
    
    [_dueDatePickerView setDueDate:_dueDateTextField.text];
    
    [self.delegate afterCommit];
}

- (void)datePickerSelectValue:(NSString*)value
{
    _dueDateTextField.text = value;
}

- (void)showDatePicker
{
    [_dueDatePickerView setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [_dueDatePickerView showWithAnimation];
    _dueDatePickerView.tag = 1;
}

- (void)removeDatePicker
{
    [_dueDatePickerView setFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight)];
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
