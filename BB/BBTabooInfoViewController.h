//
//  BBTabooInfoViewController.h
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTabooInfoViewController : UIViewController<UIScrollViewDelegate>
{
@private
    NSString*           _str;
}
- (id)initWithData:(NSString*)data;
@end
