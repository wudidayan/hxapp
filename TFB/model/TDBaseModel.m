//
//  TDBaseModel.m
//  TFB
//
//  Created by Nothing on 15/4/10.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@implementation TDBaseModel
+(NSString *)dataChangeWithString:(NSString *)string{

//20150429163812
    
    if (string.length == 0) {
        return @"- -";
    }
    if (string.length != 14) {
        return string;
    }
    
    return [NSString stringWithFormat:@"%@月%@日 %@:%@:%@",
                /*[string substringWithRange:(NSRange){0,4}],*/
                [string substringWithRange:(NSRange){4,2}],
                [string substringWithRange:(NSRange){6,2}],
                [string substringWithRange:(NSRange){8,2}],
                [string substringWithRange:(NSRange){10,2}],
                [string substringWithRange:(NSRange){12,2}]
                ];

}

- (instancetype)initWithDictionary:(NSDictionary *)dic{
  
    self = [super init];
    if (self) {
        
    }
    return self;

}
+ (NSString *)cardNoStarWithCardNo:(NSString *)cardNo{

    NSString * star = @"";
    NSString * string = @"";
    if (cardNo.length > 8) {
        for (int i = 0; i < cardNo.length - 8; i++ ) {
            star = [NSString stringWithFormat:@"*%@",star];
        }
        string = [NSString stringWithFormat:@"%@%@%@",[cardNo substringToIndex:4],
                          star,
                          [cardNo substringFromIndex:cardNo.length-4]];
    }else{
        string = cardNo;
    }

    return string;
}
+(NSString *)moblieStarWithMoblie:(NSString *)moblie{

    NSString * star = @"";
    NSString * string = @"";
    if (moblie.length > 7) {
        for (int i = 0; i < moblie.length - 7; i++ ) {
            star = [NSString stringWithFormat:@"*%@",star];
        }
        string = [NSString stringWithFormat:@"%@%@%@",[moblie substringToIndex:3],
                  star,
                  [moblie substringFromIndex:moblie.length-4]];
    }else{
        string = moblie;
    }
    
    return string;

}

@end
