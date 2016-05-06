//
//  TDBaseModel.h
//  TFB
//
//  Created by Nothing on 15/4/10.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDBaseModel : NSObject
+(NSString *)dataChangeWithString:(NSString *)string;

+ (NSString *)cardNoStarWithCardNo:(NSString *)cardNo;
+(NSString *)moblieStarWithMoblie:(NSString *)moblie;
@end
