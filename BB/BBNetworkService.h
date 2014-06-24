//
//  BBNetworkService.h
//  BB
//
//  Created by FengZi on 13-12-30.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBNetworkService : NSObject

+ (id)cookList:(NSString*) key;
+ (id)changeList:(NSString*) key;
+ (id)tabooList:(NSString*) key;

@end
