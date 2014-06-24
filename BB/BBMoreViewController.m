//
//  BBMoreViewController.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBMoreViewController.h"
#import "BBUserBaseInfoViewController.h"
#import "BBMainViewController.h"
#import "BBAboutUsViewController.h"
#import "MobClick.h"

@interface BBMoreViewController ()

@end

@implementation BBMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 66)];
        title.text = @"设置";
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.titleView = title;
    }
    return self;
}

- (void)loadView
{
    [self initData];
    
    UIView *baseView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    baseView.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    self.view = baseView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
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
    
}

- (void)loadAdBanner
{
    int rand = (arc4random() % 100) + 0;
    NSLog(@"rand = %d", rand);
    if (rand > [[MobClick getConfigParams:@"openIADRate"] intValue]) {
        return;
    }
    
    _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Specify the ad unit ID.
    _adBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adBannerView.rootViewController = self;
    [self.view addSubview:_adBannerView];
    
    // Initiate a generic request to load it with an ad.
//    [_adBannerView loadRequest:[GADRequest request]];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        [[BBMainViewController mainVCInstance] showTabBarWithAnimationDuration:0.6];
    }
}

- (void)initData
{
    _data = [[NSMutableArray alloc] init];
    [_data addObject:@[@"个人信息"]];
    [_data addObject:@[@"关于我们", @"去给我们一个评价吧^_^"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    NSString *str = [[_data objectAtIndex:section] objectAtIndex:row];
    
    static NSString *CellWithIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0)
    {
        if (row == 0)
        {
            // 个人信息
            BBUserBaseInfoViewController *userBaseInfoVC = [[BBUserBaseInfoViewController alloc] init];
            [self.navigationController pushViewController:userBaseInfoVC animated:YES];
        }
    }
    else if (section == 1)
    {
        if (row == 0)
        {
            // 关于我们
            BBAboutUsViewController *aboutUsVC = [[BBAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
        else if(row == 1)
        {
            // 去评价
            [BBFunction goToAppStoreEvaluate];
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
