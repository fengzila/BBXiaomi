//
//  BBAboutUsViewController.m
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBAboutUsViewController.h"
#import "BBMainViewController.h"

@interface BBAboutUsViewController ()

@end

@implementation BBAboutUsViewController

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
    UIScrollView *baseView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    baseView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    baseView.delegate = self;
    self.view = baseView;
    
    NSString *contentStr = @"    \n\n\n\n意见反馈\n\n微信:2263144619\n\n邮箱:2263144619@qq.com\n\n微博:http://weibo.com/3969065992";
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    content.textColor = [UIColor blackColor];
    content.backgroundColor = [UIColor clearColor];
    content.text = contentStr;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:15];
    content.adjustsFontSizeToFitWidth = YES;
    //设置一个行高上限
    CGSize size = CGSizeMake(kDeviceWidth, 2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [content setFrame:CGRectMake(20, 20, kDeviceWidth - 40, labelSize.height)];
//    [content setFrame:CGRectMake(20, 0, kDeviceWidth - 40, 600)];
    [self.view addSubview:content];
    
    baseView.contentSize = CGSizeMake(kDeviceWidth, content.height + 30);
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
