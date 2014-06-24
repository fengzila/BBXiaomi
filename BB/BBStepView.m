//
//  BBStepView.m
//  BB
//
//  Created by FengZi on 14-1-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBStepView.h"
#import "GADBannerView.h"
#import "MobClick.h"

@implementation BBStepView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = [[NSMutableArray alloc] init];
        
        _height = 0;
        
        _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) style:UITableViewStylePlain];
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

- (NSInteger)adaptFrameHeight
{
    return _tableView.height;
}

- (void)loadData:(NSMutableArray*)data
{
    _data = data;
//    NSInteger height = [_data count] * 80;
//    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, height);
    [_tableView reloadData];
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, _height + 60);
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
    
    NSString *text = [NSString stringWithFormat:@"%d. %@",row + 1, [[_data objectAtIndex:row] objectForKey:@"method"]];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    //设置一个行高上限
    CGSize size = CGSizeMake(kDeviceWidth, 2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setFrame:CGRectMake(0, 0, _tableView.width, labelSize.height)];
    
    CGRect rect = cell.frame;
    rect.size.height = labelSize.height;
    cell.frame = rect;
    
    
    return cell;
}

//得到此view 所在的viewController
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    float h = cell.frame.size.height + 30;
    _height += h;
    return h;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    int rand = (arc4random() % 100) + 0;
    NSLog(@"rand = %d", rand);
    if (rand > [[MobClick getConfigParams:@"openIADRate"] intValue]) {
        return [[UIView alloc] init];
    }
    
    GADBannerView *adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad unit ID.
    adBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    adBannerView.rootViewController = [self viewController];
    
    // Initiate a generic request to load it with an ad.
    [adBannerView loadRequest:[GADRequest request]];
    
    return adBannerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
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