//
//  BBCookViewController.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBCookViewController.h"
#import "BBMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BBNetworkService.h"
#import "BBMaterialView.h"
#import "BBStepView.h"
#import "MobClick.h"

#define kListItemTag    101
#define kHelpItemTag    102

@interface BBCookViewController ()

// 初始化数据
- (void)initData;

// 加载表视图
- (void)loadListView;

// 加载帮助视图
- (void)loadHelpView;

// 加载导航条
- (void)loadNavigationItem;

// 过渡动画效果
- (void)animationBaseView:(UIView *)baseView flag:(BOOL)flag;

@end

@implementation BBCookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    // 初始化数据
    [self initData];
    
    // 加载帮助视图
    [self loadHelpView];
    
    // 加载表视图
    [self loadListView];
    
    [self loadNavigationItem];
    
    [self loadMoreBtns];
    
    [self checkNewUser];
    
//    [self loadAdBanner];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kHasEvaluated];
        
        [BBFunction goToAppStoreEvaluate];
    }
}

- (void)initData
{
    _curWeek = [self getCurWeek];
    _data = [BBNetworkService cookList:_curWeek];
    
    _tabbarIsHidden = NO;
}

- (NSString*)getCurWeek
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *dueDate = [ud objectForKey:kUserBaseInfoDueDate];
    
    NSString *curWeek;
    if (dueDate.length != 0)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[formatter dateFromString:dueDate]];
        interval = 40*7*24*60*60+interval;
        curWeek = [NSString stringWithFormat:@"%d", (int)(fabs(ceilf(interval / (7*24*60*60))))];
    }
    else
    {
        curWeek = @"5";
    }
    
    return curWeek;
}

// 加载表视图
#pragma mark - Private Method
- (void)loadListView
{
    // 设置滚动图片的显示区域
    // -44:减去顶部导航高度
    // -54:减去底部tabbar高度
    // -15:偏移量
    _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20-44)];
    _listView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_listView];
    
    _csView = [[BBCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 54 - 12)];
    _csView.delegate = self;
    _csView.datasource = self;
//    [_csView roll];
    [_listView addSubview:_csView];
}

- (void)loadHelpView
{
    _helpView = [[BBChangeView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-20-44) Week:_curWeek];
    _helpView.delegate = self;
    [self.view addSubview:_helpView];
}

- (void)loadNavigationItem
{
    // 初始化基视图
    _itemBaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    _itemBaseView.userInteractionEnabled = YES;
    _itemBaseView.image = [UIImage imageNamed:@"btn_header"];
    // 给基视图添加单击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBrowserMode)];
    [_itemBaseView addGestureRecognizer:tap];
    
    // 添加子视图，问号icon
    UIImageView *helpItem = [[UIImageView alloc] initWithFrame:CGRectMake(_itemBaseView.width/2-15/2, _itemBaseView.height/2-15/2.0, 15, 15)];
    helpItem.tag = kHelpItemTag;
    helpItem.hidden = YES;
    helpItem.image = [UIImage imageNamed:@"icon_cook"];
    // 添加子视图，列表icon
    UIImageView *listItem = [[UIImageView alloc] initWithFrame:CGRectMake(_itemBaseView.width/2-15/2, _itemBaseView.height/2-15/2, 15, 15)];
    listItem.image = [UIImage imageNamed:@"icon_change"];
    listItem.tag = kListItemTag;
    // 添加子视图
    [_itemBaseView addSubview:helpItem];
    [_itemBaseView addSubview:listItem];
    
    // 添加rightItem
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_itemBaseView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _pickerView = [[BBDatePickerView alloc] initWithFrame:CGRectMake(50, 100, kDeviceWidth - 100, 30) WithDate:_curWeek];
    _pickerView.delegate = self;
    
    self.navigationItem.titleView = _pickerView;
    self.navigationController.delegate = self;
}

- (void)loadMoreBtns
{
    _moreBtnsView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - 100 - 40, kDeviceHeight - 145 - 100, 100, 100)];
    [self.view addSubview:_moreBtnsView];
    
    _dcPathButton = [[DCPathButton alloc]
                                  initDCPathButtonWithSubButtons:2
                                  totalRadius:80
                                  centerRadius:20
                                  subRadius:18
                                  centerImage:@"btn_chooser"
                                  centerBackground:nil
                                  subImages:^(DCPathButton *dc){
                                      [dc subButtonImage:@"btn_chooser_moment0" withTag:0];
                                      [dc subButtonImage:@"btn_chooser_moment1" withTag:1];
                                  }
                                  subImageBackground:nil
                                  inLocationX:100 - 20/2 locationY:100 - 20/2 toParentView:_moreBtnsView];
    _dcPathButton.delegate = self;
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
    [_adBannerView loadRequest:[GADRequest request]];
}


#pragma mark - DCPathButton delegate

- (void)button_0_action{
    NSLog(@"Button Press Tag 0!!");
    
    UIView *helpItem = [[self.navigationItem.rightBarButtonItem customView] viewWithTag:kHelpItemTag];
    if (helpItem.hidden) {
        [_csView goTop];
    } else {
        [_helpView goTop];
    }
}

- (void)button_1_action{
    NSLog(@"Button Press Tag 1!!");
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"52da4f3456240b6e4208fd32"
                                      shareText:@"爸比的贴身小秘"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToQQ, UMShareToDouban, UMShareToSina,UMShareToTencent, UMShareToSms, nil]
                                       delegate:self];
    
}

- (NSDictionary*)getShareData
{
    UIView *helpItem = [[self.navigationItem.rightBarButtonItem customView] viewWithTag:kHelpItemTag];
    if (helpItem.hidden) {
        NSLog(@"list-------%d", _csView.curPage);
        
        NSDictionary *data = [_data objectAtIndex:_csView.curPage];
        NSString *titleStr = [data objectForKey:@"title"];
        
        NSString *contentStr = [data objectForKey:@"effect"];
        NSString *cookId = [data objectForKey:@"id"];
        
        NSString *imgUrlStr = [[NSString alloc] initWithFormat:@"food_big_%@.jpg", cookId];
        
        NSMutableArray *material = [data objectForKey:@"material"];
        NSMutableArray *steps = [data objectForKey:@"step"];
        
        NSString *materialStr = @"";
        int i = 0;
        for (NSDictionary *value in material) {
            if (i == 0) {
                materialStr = [[NSString alloc] initWithFormat:@"%@", [value objectForKey:@"name"]];
            }else{
                materialStr = [[NSString alloc] initWithFormat:@"%@、%@", materialStr, [value objectForKey:@"name"]];
            }
            i++;
        }
        
        NSString *stepsStr = @"";
        i = 0;
        for (NSDictionary *value in steps) {
            if (i == 0) {
                stepsStr = [[NSString alloc] initWithFormat:@"%@、%@", [value objectForKey:@"stepId"], [value objectForKey:@"method"]];
            }else{
                stepsStr = [[NSString alloc] initWithFormat:@"%@\n%@、%@", stepsStr, [value objectForKey:@"stepId"], [value objectForKey:@"method"]];
            }
            i++;
        }
        
        NSString *shareText = [[NSString alloc] initWithFormat:@"孕%@周美食推荐\n%@\n%@\n用料:\n%@\n制作步骤:\n%@", _curWeek, titleStr, contentStr, materialStr, stepsStr];
        
        NSString *coreText = [[NSString alloc] initWithFormat:@"孕%@周美食推荐\n%@\n%@\n", _curWeek, titleStr, contentStr];
        
        return [NSDictionary dictionaryWithObjectsAndKeys:
                             shareText, @"content",
                             coreText, @"coreText",
                             imgUrlStr, @"imgUrl", nil];
    }
    else {
        NSLog(@"help-------");
        
        NSArray *dataList = [BBNetworkService changeList:@"all"];
        NSDictionary *data = [dataList objectAtIndex:[_curWeek intValue] - 1];
        NSString *babyStr = [data objectForKey:@"baby"];
        NSString *mamaStr = [data objectForKey:@"mama"];
        NSString *babiStr = [data objectForKey:@"babi"];
        NSString *tipsStr = [data objectForKey:@"tips"];
        
        if (tipsStr.length == 0)
        {
            tipsStr = @"木有啦";
        }
        
        NSString *imgUrlStr = [NSString stringWithFormat:@"%@.jpg", _curWeek];
        
        NSString *shareText = [[NSString alloc] initWithFormat:@"孕%@周奇妙的变化正在发生\n让爸比小秘给你娓娓道来\n宝宝变化\n%@\n妈咪变化%@\n爸比课堂\n%@\n小秘提示\n%@", _curWeek, babyStr, mamaStr, babiStr, tipsStr];
        
        NSString *coreText = [[NSString alloc] initWithFormat:@"孕%@周奇妙的变化正在发生\n让爸比小秘给你娓娓道来\n宝宝变化\n%@", _curWeek, babyStr];
        
        return [NSDictionary dictionaryWithObjectsAndKeys:
                shareText, @"content",
                coreText, @"coreText",
                imgUrlStr, @"imgUrl", nil];
    }
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSLog(@"platformName = %@", platformName);
    NSDictionary *data = [self getShareData];
    if ([platformName isEqualToString:UMShareToWechatSession]) {
        NSLog(@"weixin-----image is %@", [data objectForKey:@"imgUrl"]);
        // 分享到微信
        socialData.shareText = [data objectForKey:@"coreText"];
        socialData.shareImage = [UIImage imageNamed:[data objectForKey:@"imgUrl"]];
        
        socialData.extConfig.title = @"爸比的贴身小秘";
        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    }
    else if ([platformName isEqualToString:UMShareToWechatTimeline]){
        NSLog(@"pengyouquan");
        // 分享到朋友圈
        socialData.shareText = [data objectForKey:@"content"];
        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeText;
    }
    else if ([platformName isEqualToString:UMShareToQzone]){
        NSLog(@"QZone");
        // 分享到QZone
        socialData.shareText = [data objectForKey:@"content"];
        socialData.extConfig.title = @"爸比的贴身小秘";
        socialData.shareImage = [UIImage imageNamed:[data objectForKey:@"imgUrl"]];
    }
    else if ([platformName isEqualToString:UMShareToQQ]){
        NSLog(@"QQ");
        // 分享到QQ
        socialData.shareText = [data objectForKey:@"content"];
        socialData.extConfig.title = @"爸比的贴身小秘";
//        socialData.shareImage = [UIImage imageNamed:[data objectForKey:@"imgUrl"]];
    }
    else {
        socialData.shareText = [data objectForKey:@"content"];
        socialData.shareImage = [UIImage imageNamed:[data objectForKey:@"imgUrl"]];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        NSString *curWeek = [self getCurWeek];
        if ([curWeek isEqualToString:_curWeek])
        {
            return;
        }
        // 若数据修改则更新视图
        _curWeek = [self getCurWeek];
        _data = [BBNetworkService cookList:_curWeek];
        
        [_csView reloadData];
        [_csView roll];
        [_helpView reloadData:_curWeek];
        
        [_pickerView setDate:_curWeek];
    }
}

- (void)checkNewUser
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger newUser = [ud integerForKey:kNewUser];
    if (newUser != 0) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger hasEvaluated = [ud integerForKey:kHasEvaluated];
        if (!hasEvaluated)
        {
            int rate = [[MobClick getConfigParams:@"evaluateAlertRate"] intValue];
            int value = (arc4random() % 100) + 0;
            if (value <= rate)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[MobClick getConfigParams:@"evaluateNotifyContent"] delegate:self cancelButtonTitle:[MobClick getConfigParams:@"evaluateAlertCancelTitle"] otherButtonTitles:[MobClick getConfigParams:@"evaluateAlertConfirmTitle"], nil];
                [alert show];
            }
        }
        return;
    }
    
    // 新用户 进引导
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[BBMainViewController mainVCInstance] hideTabBarWithAnimationDuration:0.6];
    _tabbarIsHidden = YES;
    
    _newUserView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _newUserView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_newUserView];
    UIImageView *topBanner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    topBanner.image = [UIImage imageNamed:@"bg_header"];
    [_newUserView addSubview:topBanner];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    titleLabel.text = @"快填写老婆大人的信息吧";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_newUserView addSubview:titleLabel];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        titleLabel.frame = CGRectMake(0, 15, kDeviceWidth, 44);
    }
    
    _userBaseView = [[BBUserBaseInfoView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight)];
    _userBaseView.delegate = self;
    [_newUserView addSubview:_userBaseView];
}

- (void)afterCommit
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[BBMainViewController mainVCInstance] showTabBarWithAnimationDuration:0.4];
    _tabbarIsHidden = NO;
    
    [_newUserView removeFromSuperview];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:1 forKey:kNewUser];
    [ud synchronize];
    
    _curWeek = [self getCurWeek];
    _data = [BBNetworkService cookList:_curWeek];
    
    [_csView reloadDataWithoutAnimation];
    [_helpView reloadData:_curWeek];
    [_pickerView setDate:_curWeek];
}

#pragma mark - Actions Method
// 改变浏览方式
- (void)changeBrowserMode
{
    NSLog(@"changeBrowserMode====");
    // 获得itembaseView
    UIView *baseItemView = [self.navigationItem.rightBarButtonItem customView];
    UIView *helpItem = [baseItemView viewWithTag:kHelpItemTag];
    UIView *listItem = [baseItemView viewWithTag:kListItemTag];
    
    [self animationBaseView:self.view flag:helpItem.hidden];
    [self animationBaseView:baseItemView flag:helpItem.hidden];
    
    if (helpItem.hidden) {
        helpItem.hidden = NO;
        listItem.hidden   = YES;
    }
    else {
        helpItem.hidden = YES;
        listItem.hidden   = NO;
    }
}

// 翻转过渡动画效果
- (void)animationBaseView:(UIView *)baseView flag:(BOOL)flag
{
    NSLog(@"animationBaseView");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [baseView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView setAnimationTransition:flag ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:baseView cache:YES];
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfPages
{
    return [_data count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    BBCycleScrollCell *cell = [[BBCycleScrollCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    NSDictionary *data = [_data objectAtIndex:index];
    [data setValue:[NSString stringWithFormat:@"%d/%d", index+1, [_data count]] forKey:@"pageIndex"];
    [cell loadData:data];
    cell.delegate = self;
    return cell;
}

- (void)didClickPage:(BBCycleScrollView *)csView atIndex:(NSInteger)index
{
}

- (void)selectedRow:(int)row withString:(NSString *)text
{
    NSLog(@"%d----%@", row, text);
    
    if ([_curWeek isEqualToString:text])
    {
        return;
    }
    
//    if ([text isEqualToString:@"40"]){
//        // 第40周不显示孕妇变化
//        _itemBaseView.hidden = YES;
//    }else{
//        _itemBaseView.hidden = NO;
//    }
    _curWeek = text;
    _data = [BBNetworkService cookList:_curWeek];
    
    [_csView reloadDataWithoutAnimation];
    [_helpView reloadData:_curWeek];
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
    
    if (abs(currentPostion - _lastPosition) > 20 && _dcPathButton.expanded) {
        [_dcPathButton takeBack];
    }
//    [_moreBtnsView setHidden:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [_moreBtnsView setHidden:NO];
//    NSLog(@"222222");
}

#pragma mark -
#pragma mark yaoyiyao
- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}
//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    [_csView roll];
//    NSLog(@"开始摇动手机");
//}
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"stop");
//    [_csView stopRoll];
//}
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"取消");
//    [_csView stopRoll];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"%s", __FUNCTION__);
}

@end
