//
//  BBPickerView.h
//  BB
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBPickerView;

@protocol BBPickerViewDelegate <NSObject>

- (void)selector:(BBPickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index;

- (NSInteger)initSelectedIndex;

@end

@protocol BBPickerViewDataSource <NSObject>
- (NSInteger)numberOfRowsInSelector:(BBPickerView *)valueSelector;
- (UIView *)selector:(BBPickerView *)valueSelector viewForRowAtIndex:(NSInteger) index;
- (CGRect)rectForSelectionInSelector:(BBPickerView *)valueSelector;
- (CGFloat)rowHeightInSelector:(BBPickerView *)valueSelector;
- (CGFloat)rowWidthInSelector:(BBPickerView *)valueSelector;
@end



@interface BBPickerView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) IBOutlet id <BBPickerViewDelegate> delegate;
@property (nonatomic,assign) IBOutlet id <BBPickerViewDataSource> dataSource;
@property (nonatomic,assign) BOOL shouldBeTransparent;
@property (nonatomic,assign) BOOL horizontalScrolling;

@property (nonatomic,assign) BOOL debugEnabled;

- (id)initWithFrame:(CGRect)frame;

- (void)reloadData;

- (void)updateDate;

@end
