//
//  BBMaterialView.h
//  BB
//
//  Created by FengZi on 13-12-31.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMaterialView : UIView <UITableViewDelegate, UITableViewDataSource>
{
@private
    NSMutableArray      *_data;
    UITableView         *_tableView;
}

@property (nonatomic) NSMutableArray *data;

- (NSInteger)adaptFrameHeight;
- (void)loadData:(NSMutableArray*)data;
@end
