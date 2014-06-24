//
//  BBCycleScrollCell.m
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBCycleScrollCell.h"
#import "BBMaterialView.h"
#import "BBStepView.h"

@implementation BBCycleScrollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 加载图片
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width - 20, (self.width - 20)*3/5 - 3)];
        [self addSubview:_imageView];
        
        // 页签
        UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 20, 40, 40)];
        pageImageView.image = [UIImage imageNamed:@"direction_index"];
        [_imageView addSubview:pageImageView];
        
        _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _pageIndexLabel.textColor = kPink;
        _pageIndexLabel.font = [UIFont boldSystemFontOfSize:16];
        _pageIndexLabel.backgroundColor = [UIColor clearColor];
        _pageIndexLabel.textAlignment = NSTextAlignmentCenter;
        [pageImageView addSubview:_pageIndexLabel];
        
//        // 遮罩的小三角
//        UIImageView *shadeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 167, 10, 10)];
//        shadeView.image = [UIImage imageNamed:@"zhezhao"];
//        [_imageView addSubview:shadeView];
//        
//        // 遮罩的小三角
//        UIView *shadeWhiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 167, _imageView.width - 20, 10)];
//        shadeWhiteView.backgroundColor = [UIColor whiteColor];
//        [_imageView addSubview:shadeWhiteView];
        
        _baseView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_baseView];
        _baseView.delegate = self;
        
        // 左右边距10px
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, _imageView.height, self.width - 20, self.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 7.0;
        [_baseView addSubview:_bgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [_bgView addSubview:_contentLabel];
        
        _materialTitleLabel = [self titleLabelWithStr:@"用料"];
        [_bgView addSubview:_materialTitleLabel];
        
        _materialView = [[BBMaterialView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width - 30, 0)];
        _materialView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_materialView];
        
        _stepTitleLabel = [self titleLabelWithStr:@"制作步骤"];
        [_bgView addSubview:_stepTitleLabel];
        
        _stepView = [[BBStepView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width - 30, 0)];
        _stepView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_stepView];
    }
    return self;
}

- (UILabel*)titleLabelWithStr:(NSString*)str
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = str;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    return titleLabel;
}

- (void)loadData:(NSDictionary*)data
{
    NSString *titleStr = [data objectForKey:@"title"];
    NSString *contentStr = [data objectForKey:@"effect"];
    NSString *cookId = [data objectForKey:@"id"];
    
    NSString *imgUrlStr = [[NSString alloc] initWithFormat:@"food_big_%@.jpg", cookId];
    _imageView.image = [UIImage imageNamed:imgUrlStr];
    
    _pageIndexLabel.text = [data objectForKey:@"pageIndex"];
    
    NSInteger height = 10;
    
    _titleLabel.text = titleStr;
    _titleLabel.frame = CGRectMake(15, height, _imageView.width, 20);
    
    height += _titleLabel.height;
    
    NSString *contentStrFormat = [NSString stringWithFormat:@"    %@", contentStr];
    //设置一个行高上限
    CGSize size = CGSizeMake(_bgView.width, 2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [contentStrFormat sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.text = contentStrFormat;
    [_contentLabel setFrame:CGRectMake(15, height + 5, _imageView.width - 28, labelSize.height)];
    
    height += _contentLabel.height + 5;

    _materialTitleLabel.frame = CGRectMake(15, height + 15, _bgView.width - 30, 25);
    
    height += _materialTitleLabel.height + 15;

    [_materialView loadData:[data objectForKey:@"material"]];
    _materialView.frame = CGRectMake(15, height + 5, _bgView.width - 30, [_materialView adaptFrameHeight]);
    
    height += _materialView.height + 5;
    
    _stepTitleLabel.frame = CGRectMake(15, height + 15, _bgView.width - 30, 25);
    
    height += _stepTitleLabel.height + 15;
    
    [_stepView loadData:[data objectForKey:@"step"]];
    _stepView.frame = CGRectMake(15, height + 5, _bgView.width - 30, [_stepView adaptFrameHeight]);
    
    height += _stepView.height + 5;
    
    height += 130 + (self.width - 20)*3/5 - 3;
    
    height += 50;
    
    _baseView.contentSize = CGSizeMake(self.bounds.size.width, height);
    _bgView.frame = CGRectMake(10, _imageView.height, self.width - 10 * 2, height);
}

- (void)goTop
{
    [_baseView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = _baseView.contentOffset.y;
    
    CGFloat ImageWidth  = self.width - 20;
    CGFloat ImageHeight  = (self.width - 20)*3/5 - 3;
    if (yOffset < 0)
    {
        CGFloat factor = ((ABS(yOffset)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2 + 10, 10, factor, ImageHeight+ABS(yOffset));
        _imageView.frame = f;
    }
    else
    {
        CGRect f = _imageView.frame;
        f.origin.y = -yOffset + 10;
        _imageView.frame = f;
    }
    
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [self.delegate scrollViewDidEndDecelerating:scrollView];
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
