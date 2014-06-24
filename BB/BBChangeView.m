//
//  BBChangeView.m
//  BB
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBChangeView.h"
#import "BBNetworkService.h"
#import "MobClick.h"

@implementation BBChangeView

- (id)initWithFrame:(CGRect)frame Week:(NSString*)week
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _baseView.delegate = self;
        _baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_baseView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 215 / 2, 0, 215, 150)];
        [_baseView addSubview:_imgView];
        
        _babyTitleLabel = [self titleLabelStr:@"宝宝变化"];
        [_baseView addSubview:_babyTitleLabel];
        
        _babyLabel = [[UILabel alloc] init];
        [_baseView addSubview:_babyLabel];
        
        _mamaTitleLabel = [self titleLabelStr:@"妈妈变化"];
        [_baseView addSubview:_mamaTitleLabel];
        
        _mamaLabel = [[UILabel alloc] init];
        [_baseView addSubview:_mamaLabel];
        
        _babiTitleLabel = [self titleLabelStr:@"爸比课堂"];
        [_baseView addSubview:_babiTitleLabel];
        
        _babiLabel = [[UILabel alloc] init];
        [_baseView addSubview:_babiLabel];
        
        _tipsTitleLabel = [self titleLabelStr:@"小秘提示"];
        [_baseView addSubview:_tipsTitleLabel];
        
        _tipsLabel = [[UILabel alloc] init];
        [_baseView addSubview:_tipsLabel];
        
        [self reloadData:week];
    }
    return self;
}

- (void)reloadData:(NSString*)week
{
    NSArray *dataList = [BBNetworkService changeList:@"all"];
    NSDictionary *data = [dataList objectAtIndex:[week intValue] - 1];
    NSString *babyStr = [data objectForKey:@"baby"];
    NSString *mamaStr = [data objectForKey:@"mama"];
    NSString *babiStr = [data objectForKey:@"babi"];
    NSString *tipsStr = [data objectForKey:@"tips"];
    NSInteger height = 0;
    
    _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", week]];
    
    height += _imgView.height;
    
    _babyTitleLabel.frame = CGRectMake(10, height + 10, 300, 30);
    
    height += _babyTitleLabel.height;
    
    [self contentLabel:_babyLabel Str:babyStr Height:height];
    
    height += _babyLabel.height;
    
    _mamaTitleLabel.frame = CGRectMake(10, height + 10, 300, 30);
    
    height += _mamaTitleLabel.height;
    
    [self contentLabel:_mamaLabel Str:mamaStr Height:height];
    
    height += _mamaLabel.height;
    
    _babiTitleLabel.frame = CGRectMake(10, height + 10, 300, 30);
    
    height += _babiTitleLabel.height;
    
    [self contentLabel:_babiLabel Str:babiStr Height:height];
    
    height += _babiLabel.height;
    
    if (tipsStr.length > 0)
    {
        _tipsTitleLabel.hidden = NO;
        _tipsTitleLabel.frame = CGRectMake(10, height + 10, 300, 30);
        
        height += _tipsTitleLabel.height;
        
        [self contentLabel:_tipsLabel Str:tipsStr Height:height];

        height += _tipsLabel.height;
    }
    else
    {
        _tipsTitleLabel.hidden = YES;
        _tipsLabel.text = @"";
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        height += 60;
    }
    
    _baseView.contentSize = CGSizeMake(self.bounds.size.width, height);
}

- (UILabel*)titleLabelStr:(NSString*)str
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kPink;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = str;
    titleLabel.font = [UIFont systemFontOfSize:18];
    return titleLabel;
}

- (void)contentLabel:(UILabel*)label Str:(NSString*)str Height:(NSInteger)height
{
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = str;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.adjustsFontSizeToFitWidth = YES;
    //设置一个行高上限
    CGSize size = CGSizeMake(kDeviceWidth, 2000);
    // 计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [label setFrame:CGRectMake(20, height, kDeviceWidth - 40, labelSize.height)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)goTop
{
    [_baseView setContentOffset:CGPointMake(0, 0) animated:YES];
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
