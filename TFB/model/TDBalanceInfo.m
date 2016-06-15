//
//  TDBalanceInfo.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/20.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBalanceInfo.h"

@implementation TDBalanceInfo
+ (instancetype)balanceDefault
{
    static TDBalanceInfo * defaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaults = [[TDBalanceInfo alloc] init];
    });
    
    return defaults;
}




-(void)dataWithDictionary:(NSDictionary *)dictionary{

    self.acBal = [dictionary objectForKey:@"acBal"];
    self.acT1Y = [dictionary objectForKey:@"acT1Y"];
    self.acT1  = [dictionary objectForKey:@"acT1"];
    self.acT0  = [dictionary objectForKey:@"acT0"];
    self.acT1UNA = [dictionary objectForKey:@"acT1UNA"];
    self.acT1AP  = [dictionary objectForKey:@"acT1AP"];
    self.acT1AUNP  = [dictionary objectForKey:@"acT1AUNP"];
    self.onCredit  = [dictionary objectForKey:@"onCredit"];
    self.freeze  = [dictionary objectForKey:@"freeze"];
    self.reserveField  = [dictionary objectForKey:@"reserveField"];
    
    self.acT1AP_ACT03  = [dictionary objectForKey:@"acT1AP_ACT03"];
    self.acT1Y_ACT03  = [dictionary objectForKey:@"acT1Y_ACT03"];
    self.acT1AP_ACT04  = [dictionary objectForKey:@"acT1AP_ACT04"];
    self.acT1Y_ACT04  = [dictionary objectForKey:@"acT1Y_ACT04"];
    
    NSLog(@"acT1AP: %@", self.acT1AP);
    NSLog(@"onCredit: %@", self.onCredit);
    NSLog(@"freeze: %@", self.freeze);
    NSLog(@"acT1AP_ACT03: %@", self.acT1AP_ACT03);
    NSLog(@"acT1Y_ACT03: %@", self.acT1Y_ACT03);
    NSLog(@"acT1AP_ACT04: %@", self.acT1AP_ACT04);
    NSLog(@"acT1Y_ACT04: %@", self.acT1Y_ACT04);
    
    long long llAcT1AP = 0;
    long long llOnCredit = 0;
    long long llFreeze = 0;
    
    long long llAcT1AP_ACT03 = 0;
    long long llAcT1AP_ACT04 = 0;
    
    long long llBalance = 0;
    long long llBalanceDisp = 0;
    
    if(self.acT1AP == nil) {
        llAcT1AP = 0;
    } else {
        llAcT1AP = self.acT1AP.longLongValue;
    }
    
    if(self.onCredit == nil) {
        llOnCredit = 0;
    } else {
        llOnCredit = llabs(self.onCredit.longLongValue);
    }
    
    if(self.freeze == nil) {
        llFreeze = 0;
    } else {
        llFreeze = self.freeze.longLongValue;
    }

    if(self.acT1AP_ACT03 == nil) {
        llFreeze = 0;
    } else {
        llFreeze = self.acT1AP_ACT03.longLongValue;
    }
    
    if(self.acT1AP_ACT04 == nil) {
        llFreeze = 0;
    } else {
        llFreeze = self.acT1AP_ACT04.longLongValue;
    }
    
    llBalanceDisp = llAcT1AP + llAcT1AP_ACT03 + llAcT1AP_ACT04;
    llBalance = llBalanceDisp - llOnCredit - llFreeze;
    if(llBalance < 0) {
        llBalance = 0;
    }

    self.balance = [NSString stringWithFormat:@"%lld",llBalance];
    self.balanceDisp = [NSString stringWithFormat:@"%lld",llBalanceDisp];
}

@end
