//
//  BBTabooViewController.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBTabooViewController.h"
#import "BBSegmentedControl.h"
#import "BBNetworkService.h"
#import "BBTabooInfoViewController.h"
#import "BBMainViewController.h"

@interface BBTabooViewController ()

@end


@implementation BBTabooViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 66)];
        title.text = @"禁忌";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        
        self.navigationItem.titleView = title;
    }
    return self;
}

- (void)loadView
{
    self.navigationController.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    _segTitleArr = @[@"饮食篇", @"生活篇"];
    BBSegmentedControl *segControl = [[BBSegmentedControl alloc] initWithSectionTitles:_segTitleArr];
    [segControl setFrame:CGRectMake(0, 0, kDeviceWidth, 35)];
    segControl.backgroundColor = kGray;
    [segControl addTarget:self action:@selector(segContrllChange:) forControlEvents:UIControlEventValueChanged];
//    [segControl setTag:1];
    [self.view addSubview:segControl];
    
    NSArray *dietData = [BBNetworkService tabooList:@"taboo_diet"];
    NSArray *behaviorData = [BBNetworkService tabooList:@"taboo_behavior"];
    
    _dietView = [[BBTabooTableView alloc] initWithFrame:CGRectMake(0, 35, kDeviceWidth, kDeviceHeight - 35) Data:dietData];
    _dietView.delegate = self;
    [self.view addSubview:_dietView];
    
    _behaviorView = [[BBTabooTableView alloc] initWithFrame:CGRectMake(0, 35, kDeviceWidth, kDeviceHeight - 35) Data:behaviorData];
    _behaviorView.delegate = self;
    [self.view addSubview:_behaviorView];
    [_behaviorView setHidden:YES];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:[_segTitleArr objectAtIndex:0] style:UIBarButtonItemStylePlain target:self action:nil];
    // 设置返回按钮文字颜色
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], UITextAttributeTextColor,
                                    nil];
    [backItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"btn_header_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"btn_header_back_press"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.delegate = self;
    
    _tabbarIsHidden = NO;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        [[BBMainViewController mainVCInstance] showTabBarWithAnimationDuration:0.6];
    }
}

- (void)segContrllChange:(BBSegmentedControl*)seg
{
    NSLog(@"Selected index %i (via UIControlEventValueChanged)", seg.selectedIndex);
    switch (seg.selectedIndex)
    {
        case 0:
            [_dietView setHidden:NO];
            [_behaviorView setHidden:YES];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:0];
            break;
            
        case 1:
            [_dietView setHidden:YES];
            [_behaviorView setHidden:NO];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:1];
            break;
            
        default:
            break;
    }
}

- (void)pushInfoVCWithData:(NSString*)str
{
    BBTabooInfoViewController *infoVC = [[BBTabooInfoViewController alloc] initWithData:str];
    
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        //        NSLog(@"ScrollUp now");
        if (currentPostion > 0 && !_tabbarIsHidden)
        {
            [[BBMainViewController mainVCInstance] hideTabBarWithAnimationDuration:0.6];
            _tabbarIsHidden = YES;
        }
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        //        NSLog(@"ScrollDown now");
        if (_tabbarIsHidden)
        {
            [[BBMainViewController mainVCInstance] showTabBarWithAnimationDuration:0.4];
            _tabbarIsHidden = NO;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
