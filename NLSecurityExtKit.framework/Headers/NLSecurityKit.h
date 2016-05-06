//
//  NLSecurityKit.h
//  NLSecurityExt4Lefu
//
//  Created by su on 15/3/6.
//  Copyright (c) 2015年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLSecurityKit : NSObject
/*!
 @method
 @abstract 解析服务器下发的主密钥 用11的标准加密主密钥
 @discussion
 @param TMK TMKAndKCV前面8个字节密钥数据
 @param SN 从[deviceInfo CSN]取得
 @return
 */
+ (NSString*)convertTMK:(NSData*)TMK SN:(NSString*)SN;
/*!
 @method
 @abstract 计算pinBlock
 @discussion
 @param pin 待加密pin
 @param account 刷卡主账号
 @return 用于加密的pinBlock
 */
+ (NSData*)calculatePinBlock:(NSString*)pin account:(NSString*)account;
@end
