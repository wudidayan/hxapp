//
//  TDFenRunInfo.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/12.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDFenRunInfo.h"

@implementation TDFenRunInfo


//custId	商户编号
//custClass	商户等级
//ProfitDate	分润日期
//txnAmt	交易分润金额
//mngAmt	管理分润金额

- (instancetype)initWithDictionary:(NSDictionary *)dic{

    self = [super init];
    if ( self) {
        self.custId =  [dic objectForKey:@"custId"];
        self.custClass = [[dic objectForKey:@"custClass"] integerValue];
        self.profitDate = [[dic objectForKey:@"profitDate"] integerValue];
        self.mngAmt = [dic objectForKey:@"mngAmt"];
        self.txnAmt = [dic objectForKey:@"txnAmt"];
        
    }
    return self;
}

@end
