//
//  BBMainViewController.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBMainViewController.h"
#import "BBCookViewController.h"
#import "BBMoreViewController.h"
#import "BBBaseNavigationController.h"
#import "BBTabooViewController.h"
#import "BBChangeViewController.h"
#import "BBUserViewController.h"

BBMainViewController *instance = Nil;

@interface BBMainViewController ()

// 初始化数据
- (void)initData;

// 装在子视图控制器
- (void)loadViewControllers;

// 自定义tabbar视图
- (void)customTabbarView;

@end

@implementation BBMainViewController

+ (BBMainViewController*)mainVCInstance
{
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.hidden = YES;
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[UITabBar class]]) {
            view.frame = CGRectMake(0, 0, 320, 480);
        }
    }
    
    [self initData];
    
    [self customTabbarView];
    
    instance = self;
    
    [self loadViewControllers];
    
}

- (void)initData
{
    _imgs = @[@"nav_home", @"nav_taboo", @"nav_setting"];
    _titles = @[@"小秘一下", @"禁忌", @"设置"];
    _pos = @[[NSString stringWithFormat:@"%f", kDeviceWidth / 2], [NSString stringWithFormat:@"%f", kDeviceWidth / 4 - 10], [NSString stringWithFormat:@"%f", kDeviceWidth * 3 / 4 + 10]];
}

- (void)loadViewControllers
{   
    // 禁忌
    BBTabooViewController *tabooVC = [[BBTabooViewController alloc] init];
    BBBaseNavigationController *tabooNavigation = [[BBBaseNavigationController alloc] initWithRootViewController:tabooVC];
    
    // 首页
    BBCookViewController *cookVC = [[BBCookViewController alloc] init];
    BBBaseNavigationController *cookNavigation = [[BBBaseNavigationController alloc] initWithRootViewController:cookVC];
    
    // 更多
    BBMoreViewController *moreVC = [[BBMoreViewController alloc] init];
    BBBaseNavigationController *moreNavigation = [[BBBaseNavigationController alloc] initWithRootViewController:moreVC];
    
    NSArray *viewControllers = @[cookNavigation, tabooNavigation, moreNavigation];
    [self setViewControllers:viewControllers animated:YES];
}

- (void)customTabbarView
{
    // 自定义tabbar背景视图
    _tabbarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 59, kDeviceWidth, 59)];
    _tabbarBg.userInteractionEnabled = YES;
    _tabbarBg.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:_tabbarBg];
    
    _tabbarItemArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++)
    {
        int x = [_pos[i] intValue];
        
        BOOL withText = YES;
        if (i == 0) {
            withText = NO;
        }
        BBItemView *itemView = [[BBItemView alloc] initWithFrame:CGRectMake(x - 90 / 2, _tabbarBg.height/2.0 - 45.0/2, 90, 66) WithText:withText];
        itemView.tag = i;
        itemView.delegate = self;
        itemView.item.image = [UIImage imageNamed:_imgs[i]];
        NSString *selectItemImgName = [[NSString alloc] initWithFormat:@"%@_active", _imgs[i]];
        itemView.selectItem.image = [UIImage imageNamed:selectItemImgName];
        itemView.title.text = _titles[i];
        itemView.title.font = [UIFont systemFontOfSize:10];
        [_tabbarBg addSubview:itemView];
        
        if (i == 0)
        {
            [itemView.title setTextColor:kPink];
        }
        else
        {
            [itemView.title setTextColor:[UIColor colorWithRed:128/255.0 green:62/255.0 blue:84/255.0 alpha:1]];
        }
        
        [_tabbarItemArr addObject:itemView];
    }
    
    // 选中视图
    _selectView = [[UIImageView alloc] initWithFrame:CGRectMake([_pos[0] intValue] - 35 / 2, _tabbarBg.height/2.0 - 45.0/2 + 3, 35, 40)];
    _selectView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@_active", _imgs[0]]];
    [_tabbarBg addSubview:_selectView];
}

- (void)touchItemView:(BBItemView *)itemView atIndex:(NSInteger)index
{
//    [UIView beginAnimations:Nil context:NULL];
    NSString *selectItemImgName = [[NSString alloc] initWithFormat:@"%@_active", _imgs[index]];
    _selectView.image = [UIImage imageNamed:selectItemImgName];
    
    int x = [_pos[index] intValue];
    if (index == 0) {
        _selectView.frame = CGRectMake(x - 35 / 2, _tabbarBg.height/2.0 - 45.0/2 + 3, 35, 40);
    }
    else
    {
        _selectView.frame = CGRectMake(x - 29 / 2, _tabbarBg.height/2.0 - 45.0/2 + 3, 29, 33);
    }
    self.selectedIndex = index;
    
    for (int i = 0; i < [_tabbarItemArr count]; i++)
    {
        BBItemView *itemView = [_tabbarItemArr objectAtIndex:i];
        if (i == index)
        {
            [itemView.title setTextColor:kPink];
        }
        else
        {
            [itemView.title setTextColor:[UIColor colorWithRed:128/255.0 green:62/255.0 blue:84/255.0 alpha:1]];
        }
    }
}

- (void)showTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarBg.frame = CGRectMake(0, kDeviceHeight - 59, kDeviceWidth, 59);
                     }];
    
}

//隐藏TabBar通用方法
- (void)hideTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarBg.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 59);
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (void)dealloc
//{
////    [_tabbarBg rele
//    [super dealloc];
//}


@end
