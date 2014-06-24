//
//  BBTipsView.m
//  BB
//
//  Created by FengZi on 14-1-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBTipsView.h"

@implementation BBTipsView

- (id)initWithFrame:(CGRect)frame Data:(NSMutableArray*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        
        NSInteger height = [data count] * 80;
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 8.0;
        [self addSubview:_tableView];
    }
    return self;
}

- (NSInteger)adaptFrameHeight
{
    return _tableView.height;
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义静态标识符
    static NSString *cellIdentifier = @"cell";
    NSInteger row = [indexPath row];
    
    // 检查表视图中是否存在闲置的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *text = [NSString stringWithFormat:@"%@", [_data objectAtIndex:row]];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    //设置一个行高上限
    CGSize size = CGSizeMake(kDeviceWidth, 2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setFrame:CGRectMake(0, 0, _tableView.width, labelSize.height)];
    
    return cell;
}

//#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
