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
    
    
    NSLog(@"acT1AP: %@", self.acT1AP);
    NSLog(@"onCredit: %@", self.onCredit);
    NSLog(@"freeze: %@", self.freeze);
    
    int iAcT1AP = 0;
    int iOnCredit = 0;
    int iFreeze = 0;
    int iBalance = 0;
    int iBalanceDisp = 0;
    
    if(self.acT1AP == nil) {
        iAcT1AP = 0;
    } else {
        iAcT1AP = self.acT1AP.intValue;
    }
    
    if(self.onCredit == nil) {
        iOnCredit = 0;
    } else {
        iOnCredit = abs(self.onCredit.intValue);
    }
    
    if(self.freeze == nil) {
        iFreeze = 0;
    } else {
        iFreeze = self.freeze.intValue;
    }
    
    iBalanceDisp = iBalanceDisp;
    iBalance = iAcT1AP - iOnCredit - iFreeze;
    if(iBalance < 0) {
        iBalance = 0;
    }

    self.balance = [NSString stringWithFormat:@"%d",iBalance];
    self.balanceDisp = [NSString stringWithFormat:@"%d",iBalanceDisp];
}

@end
