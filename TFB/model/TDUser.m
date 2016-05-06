//
//  TDUser.m
//  TFB
//
//  Created by Nothing on 15/3/21.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDUser.h"

@implementation TDUser


+ (instancetype)defaultUser
{
    static TDUser *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    return user;
}
+(NSString *)messageTextWithStatus:(NSString *)status andTYPE:(BOOL)type{

    /*  认证状态（0未认证，1审核中，2审核通过，3审核不通过）*/
    NSString * statusString = @"";
    switch (status.intValue) {
        case 0: statusString = type? @"未认证":@"未绑定";     break;
        case 1: statusString = @"审核中";     break;
        case 2: statusString = @"审核已通过";  break;
        case 3: statusString = @"审核不通过";  break;
        default:statusString = @"异常";       break;
    }
    return statusString;
}
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
@end
