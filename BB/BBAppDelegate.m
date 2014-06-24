//
//  BBAppDelegate.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBAppDelegate.h"
#import "BBMainViewController.h"
#import "MobClick.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>  
#import <TencentOpenAPI/TencentOAuth.h>

@implementation BBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:@"52da4f3456240b6e4208fd32"];
//    [MobClick startWithAppkey:@"52da4f3456240b6e4208fd32" reportPolicy:REALTIME channelId:nil];
    [MobClick updateOnlineConfig];
//    [MobClick setLogEnabled:YES];
    
    [UMSocialData setAppKey:@"52da4f3456240b6e4208fd32"];
    
    [UMSocialConfig setWXAppId:@"wxce532415fd5fadbb" url:nil];
    
    //打开Qzone的SSO开关，
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    [UMSocialConfig setShareQzoneWithQQSDK:YES url:@"http://xiaobaba.sinaapp.com" importClasses:@[[QQApiInterface class],[TencentOAuth class],[TCUploadPicDic class],[TCAddShareDic class]]];
    
    //设置手机QQ的AppId，url传nil，将使用友盟的网址
    [UMSocialConfig setQQAppId:@"101022810" url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 将视图控制器添加至UIWindow
    BBMainViewController *mainVC = [[BBMainViewController alloc] init];
    self.window.rootViewController = mainVC;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"url-------%@", url);
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"url++++++++%@", url);
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
