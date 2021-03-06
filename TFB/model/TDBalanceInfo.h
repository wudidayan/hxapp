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

//onCredit      挂帐金额	N       挂帐金额
//freeze	    冻结金额	N       冻结金额
//reserveField	保留使用	N		保留使用

//acT1AP_ACT03  帐户类型03已审核金额（快捷）
//acT1Y_ACT03   帐户类型03隔天到账金额

//acT1AP_ACT04  帐户类型03已审核金额（扫码）
//acT1Y_ACT04   帐户类型03隔天到账金额

//balanceDisp   显示余额
//balance       实际可用余额

@property (nonatomic,copy) NSString * acBal;  //总余额
@property (nonatomic,copy) NSString * acT1Y;  //隔天到账余额
@property (nonatomic,copy) NSString * acT1;   //未到账余额
@property (nonatomic,copy) NSString * acT0;   //即时到账余额 (弃用)
@property (nonatomic,copy) NSString *acT1UNA;	//未审核金额
@property (nonatomic,copy) NSString *acT1AP;   //已审核金额
@property (nonatomic,copy) NSString *acT1AUNP;   //审核未通过金额

@property (nonatomic,copy) NSString *onCredit;  // 挂帐金额
@property (nonatomic,copy) NSString *freeze;  // 冻结金额
@property (nonatomic,copy) NSString *reserveField;  // 保留使用

@property (nonatomic,copy) NSString *acT1AP_ACT03;  // 帐户类型03已审核金额（快捷）
@property (nonatomic,copy) NSString *acT1Y_ACT03;  // 帐户类型03隔天到账金额

@property (nonatomic,copy) NSString *acT1AP_ACT04;  // 帐户类型03已审核金额（扫码）
@property (nonatomic,copy) NSString *acT1Y_ACT04;  // 帐户类型03隔天到账金额

@property (nonatomic,copy) NSString *balanceDisp;  // 显示余额
@property (nonatomic,copy) NSString *balance;  // 实际可用余额

+ (instancetype)balanceDefault;
-(void)dataWithDictionary:(NSDictionary *)dictionary;


@end
