//
//  TDFenRunInfo.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/12.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDFenRunInfo : TDBaseModel

//custId	商户编号
//custClass	商户等级
//ProfitDate	分润日期
//txnAmt	交易分润金额
//mngAmt	管理分润金额

@property (nonatomic, strong) NSString *custId;
@property (nonatomic, assign) NSInteger custClass;
@property (nonatomic, assign) NSInteger profitDate;
@property (nonatomic, strong) NSString *txnAmt;
@property (nonatomic, strong) NSString *mngAmt;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
