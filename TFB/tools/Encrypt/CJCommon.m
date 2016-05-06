//
//  CJCommon.m
//
//  Created by apple on 13-2-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CJCommon.h"
#import "GTMBase64.h"
//#import "CommonFunc.h"
#import "NSString+ThreeDES.h"

#define ZMK @"11111111111111110123456789ABCDEF"

#define gIv  @"12345678"

static Byte iv[] = {'1','2','3','4','5','6','7','8'};//only Used for Cipher Block Chaining (CBC) mode,This is ignored if ECB mode is used

@implementation CJCommon

+ (NSString *)udid
{
#ifdef __IPHONE_6_0
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
#else
    return [UIDevice currentDevice].uniqueIdentifier;
#endif
}

/************************
 *加密
 *pinKey:服务端获取的主密钥
 *account:银行卡号
 *passwd:密码明文
 ***********************/

+(NSString *)pinResultMak:(NSString *)pinKey account:(NSString *)account passwd:(NSString *)passwd{
    //1、卡号和密码明文计算pinBlack
    NSString *pinBlack=[CJCommon PinEncryptForAccount:account passwd:passwd];
    //2、zmk 3des解密主密钥 pinkey
    NSString  * MwPink =[CJCommon decrypt:pinKey withKey:ZMK];
    NSLog(@"*******%@",pinKey);
    NSLog(@"=======%@",MwPink);
    //3、pinkey明文双倍长密钥加密pinBlack
    NSString *pinResult= [CJCommon Double:MwPink data:pinBlack];
     return pinResult;
}

/************************
 *双倍长密钥加密
 *key:16进制字符串，16字节
 *data:16进制字符串，8字节
 ***********************/
+(NSString *)Double:(NSString *)key data:(NSString *)data{
    
    
    NSString * stringOne = [key substringToIndex:key.length/2];
    NSString * stringTwo = [key substringFromIndex:key.length/2];
    
    Byte * key1 = [CJCommon string2Bcd:stringOne];
    
    Byte * key2 = [CJCommon string2Bcd:stringTwo];
    
    Byte *aa=[CJCommon string2Bcd:data];
    
    //    NSData *bb=  [self dataWithLengthChar:aa]; // [NSData dataWithBytes:aa length:8];
    //
    //    Byte *data_b=(Byte *)[bb bytes];
    
    //key前八个字节 对data进行加密得到encryptBytes
    Byte *encryptBytes  = [CJCommon encryptDES:aa key:key1 useEBCmode:YES];
    //key后八个字节对encryptBytes进行解密得到decryptBytes
    
    Byte *decryptBytes  = [CJCommon decryptDES:encryptBytes key:key2 useEBCmode:YES];
    //key前八个字节对decryptBytes进行加密得到encryptBytes2
    
    Byte *encryptBytes2 = [CJCommon encryptDES:decryptBytes key:key1 useEBCmode:YES];
    //encryptBytes2转成字符串就是加密结果
    NSData *da=[[NSData alloc]initWithBytes:encryptBytes2 length:8];
    
    return [CJCommon dataToString:da];

    
    
    //******
    
//    NSData *keyByte=[CJCommon stringToByte:key];
//    char *keyB=[CJCommon str2Bcd:key];
//    char * key1         = malloc(sizeof(char)*8);
//    char * key2         = malloc(sizeof(char)*8);
//    for(int i = 0;i<keyByte.length;i++){
//        if(i<8){
//    key1[i] = keyB[i];
//        }else{
//            key2[i-8]=keyB[i];
//        }
//    }
//    
//    NSData *adata = [NSData dataWithBytes:key1 length:8];
//   
//    Byte *testByte = (Byte *)[adata bytes];
//    
//    
//    NSData *adata1 = [NSData dataWithBytes:key2 length:8];
//
//    
//    if (adata1.length != 8) {
//        
//    }
//    
//    Byte *testByte1 = (Byte *)[adata1 bytes];
//    
//    char *aa=[CJCommon str2Bcd:data];
//    
//    NSData *bb=  [self dataWithLengthChar:aa]; // [NSData dataWithBytes:aa length:8];
//    
//    Byte *data_b=(Byte *)[bb bytes];
//    
//  //key前八个字节 对data进行加密得到encryptBytes
//    Byte *encryptBytes  = [CJCommon encryptDES:data_b key:testByte useEBCmode:YES];
//    
//    Byte * encryptBytes2;
// 
//        //key后八个字节对encryptBytes进行解密得到decryptBytes
//          Byte *decryptBytes  = [CJCommon decryptDES:encryptBytes key:testByte1 useEBCmode:YES];
//
//              //key前八个字节对decryptBytes进行加密得到encryptBytes2
//            encryptBytes2 = [CJCommon encryptDES:decryptBytes key:testByte useEBCmode:YES];
//          
//
//  //encryptBytes2转成字符串就是加密结果
//       NSData *da=[[NSData alloc]initWithBytes:encryptBytes2 length:8];
//    
//    return [CJCommon dataToString:da];
}
//+(NSData *)dataWithLengthChar:(char *)charA{
//    
//      NSData *bb= [NSData dataWithBytes:charA length:8];
//    if (strlen([bb bytes]) == 8) {
//        return bb;
//    }else{
//        return [self dataWithLengthChar:charA];
//    }
//}
+(NSString *)dataToString:(NSData *)data{
    
    Byte *byte=(Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",byte[i]&0xff];///16进制数
        if([newHexStr length]==1){
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr=[hexStr uppercaseString];
    
    // hexStr=[Utils stringFromHexString:hexStr];
    
    return hexStr;
}

+(const void *)byteFromString:(NSString *)aText
{
    NSData *data = [aText dataUsingEncoding:NSUTF8StringEncoding];
    return [data bytes];
}

+(NSString *)stringFromByte:(const void *)bytes withLength:(int)value
{
    return [[[NSString alloc] initWithBytes:bytes length:value encoding:NSUTF8StringEncoding] autorelease];
}


//算pin block
+ (NSString *)PinEncryptForAccount:(NSString *)account passwd:(NSString *)passwd
{
    NSString *result=@"";
    NSString *accountTemp1 = @"";
    
    int passwdLen = passwd.length;
    if(passwdLen==0){
        passwd = @"FFFFFF";
    }else if(passwdLen<6){
        for(int i=0;i<6-passwdLen;i++){
            passwd = [passwd stringByAppendingString:@"F"];
        }
    }
    NSString *passwdTemp1 = [NSString stringWithFormat:@"0%d%@FFFFFFFF", passwdLen, passwd];
    
    if(0 < account.length){
        int len = account.length;
        NSRange range = {len-13, 12};
        NSString *accountTemp = [account substringWithRange:range];
        accountTemp1 = [NSString stringWithFormat:@"0000%@", accountTemp];
    }
    
    //
    if(0 >= accountTemp1.length){
        result = passwdTemp1;
    } else {//pinblock
        char * accountByte = [CJCommon str2Bcd:accountTemp1];
        char * passwdByte = [CJCommon str2Bcd:passwdTemp1];
        
        char * resultByte = malloc(sizeof(char)*8);
        
        for(int i=0;i<8;i++){
            resultByte[i] = (char) (accountByte[i] ^ passwdByte[i]);
        }
        result = [CJCommon bytesToHexString:resultByte len:8];
        free(resultByte);
    }
    
    return [result uppercaseString];
}


+ (NSString *)bytesToHexString:(char *)src len:(int)len
{
    if (src == NULL) {
        return nil;
    }
    
    NSMutableString *str = [NSMutableString string];
    int i = 0;
    while (i < len) {
        int v = src[i] & 0xFF;
        NSString *hv = [NSString stringWithFormat:@"%x", v];
        if (hv.length < 2) {
            [str appendString:@"0"];
        }
        [str appendString:hv];
        i++;
    }
    return str;
}
+ (Byte *)string2Bcd:(NSString *)asc
{
    NSLog(@"input--%@", asc);
    int len = asc.length;
    int mod = len % 2;
    
    if (mod != 0) {
        asc = [NSString stringWithFormat:@"0%@", asc];
        len = asc.length;
    }
    
    Byte * abt = malloc(sizeof(Byte)*len);
    if (len >= 2) {
        len = len / 2;
    }
    Byte * bbt = malloc(sizeof(Byte)*len);
    
    abt = (Byte *)[asc cStringUsingEncoding:NSUTF8StringEncoding];
    int j, k;
    
    for (int p = 0; p < asc.length / 2; p++) {
        if ((abt[2 * p] >= '0') && (abt[2 * p] <= '9')) {
            j = abt[2 * p] - '0';
        } else if ((abt[2 * p] >= 'a') && (abt[2 * p] <= 'z')) {
            j = abt[2 * p] - 'a' + 0x0a;
        } else {
            j = abt[2 * p] - 'A' + 0x0a;
        }
        
        if ((abt[2 * p + 1] >= '0') && (abt[2 * p + 1] <= '9')) {
            k = abt[2 * p + 1] - '0';
        } else if ((abt[2 * p + 1] >= 'a') && (abt[2 * p + 1] <= 'z')) {
            k = abt[2 * p + 1] - 'a' + 0x0a;
        } else {
            k = abt[2 * p + 1] - 'A' + 0x0a;
        }
        
        int a = (j << 4) + k;
        Byte b = (Byte) a;
        bbt[p] = b;
        NSLog(@"---%hhu", bbt[p]);
    }
    NSLog(@"output----%s", bbt);
    return bbt;
}

+ (char *)str2Bcd:(NSString *)asc
{
    int len = asc.length;
    int mod = len % 2;
    
    if (mod != 0) {
        asc = [NSString stringWithFormat:@"0%@", asc];
        len = asc.length;
    }
    
    char * abt = malloc(sizeof(char)*len);
    if (len >= 2) {
        len = len / 2;
    }
    char * bbt = malloc(sizeof(char)*len);
    
    abt = (char *)[asc cStringUsingEncoding:NSUTF8StringEncoding];
    int j, k;
    
    for (int p = 0; p < asc.length / 2; p++) {
        if ((abt[2 * p] >= '0') && (abt[2 * p] <= '9')) {
            j = abt[2 * p] - '0';
        } else if ((abt[2 * p] >= 'a') && (abt[2 * p] <= 'z')) {
            j = abt[2 * p] - 'a' + 0x0a;
        } else {
            j = abt[2 * p] - 'A' + 0x0a;
        }
        
        if ((abt[2 * p + 1] >= '0') && (abt[2 * p + 1] <= '9')) {
            k = abt[2 * p + 1] - '0';
        } else if ((abt[2 * p + 1] >= 'a') && (abt[2 * p + 1] <= 'z')) {
            k = abt[2 * p + 1] - 'a' + 0x0a;
        } else {
            k = abt[2 * p + 1] - 'A' + 0x0a;
        }
        
        int a = (j << 4) + k;
        char b = (char) a;
        bbt[p] = b;
    }
    return bbt;
}


+(Byte *) encryptDES:(Byte *)srcBytes key:(Byte *)key useEBCmode:(BOOL)useEBCmode
{
    NSUInteger dataLength = 8; //strlen((const char*)srcBytes);
    Byte *encryptBytes = malloc(1024);
    memset(encryptBytes, 0, 1024);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          key, kCCKeySizeDES,
                                          iv,
                                          srcBytes	, dataLength,
                                          encryptBytes, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return encryptBytes;
    }
    else
    {
        return nil;
    }
}

/*DES decrypt*/
+(Byte *) decryptDES:(Byte *)srcBytes key:(Byte *)key useEBCmode:(BOOL)useEBCmode
{
    NSUInteger dataLength = 8; //strlen((const char*)srcBytes);
    Byte *decryptBytes = malloc(1024);
    memset(decryptBytes, 0, 1024);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          key , kCCKeySizeDES,
                                          iv,
                                          srcBytes	, dataLength,
                                          decryptBytes, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return decryptBytes;
    }
    else
    {
        return nil;
    }
}
//16进制转Byte数组
+(NSData *)JXX:(NSString *)hexString{
    int j=0;
    Byte bytes[128];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:128];
    return newData;
}

//字符串转字节数组
+ (NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i];         int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key{
    NSString *keyValue = key;
    int len = key.length;
    if (32 == len) {
        keyValue = [key stringByAppendingString:[key substringToIndex:16]];
    }
    NSData *keyData = [CJCommon stringToByte:keyValue];
    
    NSData *data = [CJCommon stringToByte:encryptText];
    
    size_t plainTextBufferSize = [data length];
    const void *vplainText = [data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)keyData.bytes;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    const char * r = [myData bytes];
    NSString *result = [CJCommon bytesToHexString:(char *)r len:myData.length];
    return [result uppercaseString];
}

@end
