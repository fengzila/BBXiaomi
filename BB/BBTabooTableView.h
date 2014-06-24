//
//  BBDietView.h
//  BB
//
//  Created by FengZi on 14-1-14.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBTabooTableViewDelegate <NSObject>

- (void)pushInfoVCWithData:(NSString*)str;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface BBTabooTableView : UIView<UITableViewDelegate, UITableViewDataSource>
{
@private
    UITableView         *_tableView;
}

@property (nonatomic) NSArray* data;
@property (nonatomic) id <BBTabooTableViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame Data:(NSArray*)data;

@end
