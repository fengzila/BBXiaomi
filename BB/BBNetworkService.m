//
//  BBNetworkService.m
//  BB
//
//  Created by FengZi on 13-12-30.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBNetworkService.h"

@implementation BBNetworkService
+ (id)parserData:(NSString *)name
{
    // 获取到包文件的根目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    // 根据传入的名字拼接
    NSString *path = [resourcePath stringByAppendingPathComponent:name];
    
    // 将路径下的数据读出来
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
}// JSON数据解析

+ (id)cookList:(NSString*) key
{
    return [[self parserData:@"cook"] objectForKey:key];
}

+ (id)changeList:(NSString*) key
{
    return [[self parserData:@"change"] objectForKey:key];
}

+ (id)tabooList:(NSString*) key
{
    return [[self parserData:@"taboo"] objectForKey:key];
}
@end
