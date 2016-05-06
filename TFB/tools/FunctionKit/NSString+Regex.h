//
//  NSString+Regex.h
//  EetopPay
//
//  Created by emc on 1/16/14.
//  Copyright (c) 2014 TCGROUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validateMobile:(NSString *)mobile;
+ (BOOL)validateCarNo:(NSString *)carNo;
+ (BOOL)validateCarType:(NSString *)CarType;
+ (BOOL)validateUserName:(NSString *)name;
+ (BOOL)validatePassword:(NSString *)passWord;
+ (BOOL)validateNickname:(NSString *)nickname;
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
@end
