//
//  BBStepView.h
//  BB
//
//  Created by FengZi on 14-1-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBStepView : UIView<UITableViewDelegate, UITableViewDataSource>
{
@private
    NSMutableArray      *_data;
    UITableView         *_tableView;
    
    int                 _height;
}

@property (nonatomic) NSMutableArray *data;

- (NSInteger)adaptFrameHeight;
- (void)loadData:(NSMutableArray*)data;
@end
