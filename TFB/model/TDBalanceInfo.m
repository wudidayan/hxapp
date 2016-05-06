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
    

}

@end
