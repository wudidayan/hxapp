//
//  TDPinKeyInfo.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/7.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDPinKeyInfo.h"

@implementation TDPinKeyInfo
+ (instancetype)pinKeyDefault
{
    static TDPinKeyInfo * defaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaults = [[TDPinKeyInfo alloc] init];
    });
    
    return defaults;
}

@end
