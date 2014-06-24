//
//  BBChangeView.h
//  BB
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBChangeViewDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface BBChangeView : UIView<UIScrollViewDelegate>
{
@private
    UIScrollView        *_baseView;
    UIImageView         *_imgView;
    UILabel             *_babyTitleLabel;
    UILabel             *_babyLabel;
    UILabel             *_mamaTitleLabel;
    UILabel             *_mamaLabel;
    UILabel             *_babiTitleLabel;
    UILabel             *_babiLabel;
    UILabel             *_tipsTitleLabel;
    UILabel             *_tipsLabel;
}

@property (nonatomic) id <BBChangeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Week:(NSString*)week;
- (void)reloadData:(NSString*)week;
- (void)goTop;
@end
