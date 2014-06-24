//
//  BBUserBaseInfoViewController.m
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBUserBaseInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BBMainViewController.h"

@interface BBUserBaseInfoViewController ()

@end

@implementation BBUserBaseInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[BBMainViewController mainVCInstance] hideTabBarWithAnimationDuration:0.6];
    }
    return self;
}

- (void)loadView
{
    BBUserBaseInfoView *userBaseView = [[BBUserBaseInfoView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    userBaseView.delegate = self;
    self.view = userBaseView;
    
    self.navigationItem.hidesBackButton =YES;
}

- (void)afterCommit
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
