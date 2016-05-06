//
//  CJCommon.h
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0]
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define iOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0


static NSString * const	KFontName = @"Helvetica";
static NSString * const	KBoldFontName = @"Helvetica-Bold";
static NSString * const KLogin_Cust_Id = @"login_cust_id";
static NSString *const KLogin_Cust_Pwd=@"login_cust_pwd";
static NSString * const KPayMainKey = @"pay_main_key";

@interface CJCommon : NSObject

+ (NSString *)udid;
+ (NSString *)PinEncryptForAccount:(NSString *)account passwd:(NSString *)passwd;
+ (NSString *)bytesToHexString:(char *)src len:(int)len;


+(NSString *)Double:(NSString *)key data:(NSString *)data;
+(const void *)byteFromString:(NSString *)aText;
+(NSString *)stringFromByte:(const void *)bytes withLength:(int)value;
+(NSString *)pinResultMak:(NSString *)pinKey account:(NSString *)account passwd:(NSString *)passwd;
+ (Byte *)string2Bcd:(NSString *)asc;
//16进制转Byte数组
+(NSData *)JXX:(NSString *)hexString;
//字符串转字节数组
+ (NSData*)stringToByte:(NSString*)string;

+ (char *)str2Bcd:(NSString *)asc;
+(NSString *)dataToString:(NSData *)data;
@end
