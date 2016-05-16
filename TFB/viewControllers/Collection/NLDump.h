//
//  NLDump.h
//  MTypeSDK
//
//  Created by su on 13-6-27.
//  Copyright (c) 2013年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 系统二进制日志打印工具类
 */
@interface NLDump : NSObject
/**
 * 将字节流data转换成一个可阅读的16进制表述的字符串<p>
 *
 * @param data 输入字节的data数据
 * @return
 *		16进制表述的字符串
 */
+ (NSString*)hexDumpWithData:(NSData*)data;
/**
 * 将字节流转换成一个可阅读的16进制表述的字符串<p>
 *
 * @param bytes 输入字节
 * @return
 *		16进制表述的字符串
 */
+ (NSString*)hexDumpWithBytes:(Byte*)bytes length:(int)length;
/**
 * 将字节流转换成一个可阅读的16进制表述的字符串<p>
 *
 * @param bytes 输入字节
 * @param offset 偏移量
 * @param length 长度
 * @return
 * 		16进制表述的字符串
 */
+ (NSString*)hexDumpWithBytes:(Byte *)bytes offset:(int)offset length:(int)length
;
@end
