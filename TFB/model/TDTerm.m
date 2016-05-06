//
//  TDTerm.m
//  TFB
//
//  Created by Nothing on 15/4/1.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDTerm.h"

@implementation TDTerm

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
    
    self = [super init];
    if (self) {
        _ratesArray = [[NSMutableArray alloc] init];
        self.agentId = [dictionary objectForKey:@"agentId"];
        self.termNo = [dictionary objectForKey:@"termNo"];
        self.termPayAmt = [NSString stringWithFormat:@"%.2f",[[dictionary objectForKey:@"termPayAmt"] floatValue]/100];
        self.termTypeName = [dictionary objectForKey:@"termTypeName"];
        self.termRecipient = [dictionary objectForKey:@"termRecipient"];
        self.termPayFlag =  [dictionary objectForKey:@"termPayFlag"];
        if ([[dictionary objectForKey:@"rate"] isKindOfClass:[NSArray class]]) {
            NSArray *tempArray = [dictionary objectForKey:@"rate"];
            for (int i = 0; i < tempArray.count; i ++) {
                TDRate *rate = [[TDRate alloc] initWithDictionary:tempArray[i]];
                [_ratesArray addObject:rate];
            }
        }
    }
    
    return self;
}

@end


@implementation TDRate

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.rateDesc = [dictionary objectForKey:@"rateDesc"];
        self.rateNo = [dictionary objectForKey:@"rateNo"];
        self.rateMaximun = [dictionary objectForKey:@"rateMaximun"];
    }
    return self;
}

@end