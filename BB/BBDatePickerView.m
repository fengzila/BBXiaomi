//
//  BBDatePickerView.m
//  BB
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBDatePickerView.h"
#import "BBPickerView.h"

@implementation BBDatePickerView

- (id)initWithFrame:(CGRect)frame WithDate:(NSString*)date
{
    self = [super initWithFrame:frame];
    if (self) {
        _date = date;
        [self initData];
        _picker = [[BBPickerView alloc] initWithFrame:self.bounds];
        _picker.dataSource = self;
        _picker.backgroundColor = [UIColor clearColor];
        _picker.delegate = self;
        _picker.shouldBeTransparent = YES;
        _picker.horizontalScrolling = YES;
        
        //You can toggle Debug mode on selectors to see the layout
        _picker.debugEnabled = NO;
        
        [self addSubview:_picker];
        
        UIImageView *scaleView = [[UIImageView alloc] initWithFrame:self.bounds];
        scaleView.image = [UIImage imageNamed:@"scale"];
        [self addSubview:scaleView];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.image = [UIImage imageNamed:@"weekAlpa"];
        [self addSubview:imgView];
    }
    return self;
}

- (void)initData
{
    _data = [[NSMutableArray alloc] init];
    for (int i = 3; i <= 40; i++)
    {
        [_data addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)setDate:(NSString*)date
{
    _date = date;
    [_picker updateDate];
}

#pragma IZValueSelector dataSource
- (NSInteger)initSelectedIndex
{
    return [_date intValue] - 3;
}

- (NSInteger)numberOfRowsInSelector:(BBPickerView *)valueSelector
{
    return [_data count];
}

//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(BBPickerView *)valueSelector
{
    return 70.0;
}

- (CGFloat)rowWidthInSelector:(BBPickerView *)valueSelector
{
    return 70.0;
}

- (UIView *)selector:(BBPickerView *)valueSelector viewForRowAtIndex:(NSInteger)index
{
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, _picker.frame.size.height)];
    
    label.text = [NSString stringWithFormat:@"孕%@周", [_data objectAtIndex:index]];
    label.textAlignment =  NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = kPink;
    label.font = [UIFont boldSystemFontOfSize:18];
    return label;
}

- (CGRect)rectForSelectionInSelector:(BBPickerView *)valueSelector
{
    return CGRectMake(_picker.frame.size.width/2 - 35.0, 0.0, 70.0, 90.0);
}

#pragma IZValueSelector delegate
- (void)selector:(BBPickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index
{
    NSLog(@"Selected index %d",index);
    NSString *strSelectedValue = [_data objectAtIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
        [self.delegate selectedRow:index withString:strSelectedValue];
    }
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
