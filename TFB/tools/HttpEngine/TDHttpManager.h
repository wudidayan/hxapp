//
//  TDHttpManager.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/9.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDHttpManager : NSObject


//提供参数打印
+ (NSDictionary *)jsonWithDic:(id)sender;
/**
 *  网路层
 *
 *  @param params    传参数据
 *  @param tradeCode 交易码
 *  @param complete  block回传
 */
+ (void)requestWithParams:(NSDictionary *)params tradeCode:(NSString *)tradeCode complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSDictionary * dictionary))complete;

//异常捕获
+(BOOL)requestCanContinuationWith:(NSInteger)index andParams:(NSString *)params,... NS_REQUIRES_NIL_TERMINATION;

@end
