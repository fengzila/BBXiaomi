//
//  BBMaterialView.m
//  BB
//
//  Created by FengZi on 13-12-31.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBMaterialView.h"

@implementation BBMaterialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = [[NSMutableArray alloc] init];
        
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 8.0;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)loadData:(NSMutableArray*)data
{
    _data = data;
    NSInteger height = [_data count] * 44;
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, height);
    [_tableView reloadData];
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
    
    cell.textLabel.text = [[_data objectAtIndex:row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.detailTextLabel.text = [[_data objectAtIndex:row] objectForKey:@"weight"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

//#pragma mark - TableView Delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
