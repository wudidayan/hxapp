//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
@implementation NSString(MD5Addition)

- (NSString *) stringFromMD5{    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    

    return [GTMBase64 stringByEncodingBytes:outputBuffer length:CC_MD5_DIGEST_LENGTH];
    
    //return [NSString stringWithFormat:@"%s", outputBuffer];
}

- (NSString *) stringFromMD5For16{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    int count = 0;
    int len = CC_MD5_DIGEST_LENGTH;
    if (CC_MD5_DIGEST_LENGTH <= sizeof(outputBuffer)) {
        count = 4;
        len = count + CC_MD5_DIGEST_LENGTH/2;
    }
    for(; count < len; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}
@end
