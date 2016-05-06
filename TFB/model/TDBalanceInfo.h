//
//  TDBalanceInfo.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/20.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDBalanceInfo : TDBaseModel


//rspmsg	响应信息	N		单位全部为分
//acT0	未结算金额	N		即时到账余额
//acT1	待审金额	N		未到账余额
//acT1Y	已结算金额	N		隔天到账余额
//acBal	账户总余额	N		总余额

@property (nonatomic,copy) NSString * acBal;  //总余额
@property (nonatomic,copy) NSString * acT1Y;  //隔天到账余额
@property (nonatomic,copy) NSString * acT1;   //未到账余额
@property (nonatomic,copy) NSString * acT0;   //即时到账余额 (弃用)
@property (nonatomic,copy) NSString *acT1UNA;	//未审核金额
@property (nonatomic,copy) NSString *acT1AP;   //已审核金额
@property (nonatomic,copy) NSString *acT1AUNP;   //审核未通过金额

+ (instancetype)balanceDefault;
-(void)dataWithDictionary:(NSDictionary *)dictionary;


@end
