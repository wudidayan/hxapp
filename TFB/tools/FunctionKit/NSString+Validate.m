//
//  NSString+Validate.m
//  BlackTea
//
//  Created by ChenQi on 12-9-26.
//
//

#import "NSString+Validate.h"

@implementation NSString (Validate)


- (BOOL)validateLengthRange:(BTLengthRange)range
{
    NSUInteger len = self.length;
    
    return (len >=range.min && len <= range.max);
}

/**
 *	@brief	忽略大小写的正则匹配
 *
 *	@param 	regex [IN]	正则表达式
 *
 *	@return	number of matches of the regular expression
 */
- (NSUInteger)validateCaseInsensitive:(NSString *)regex
{
    NSError *error = nil;
    NSUInteger res = 0;
    
    if (nil == regex || 0 == regex.length)
    {
        return res;
    }
    
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
    
    if (nil != error)
    {
        NSLog(@"NSError from Regular Expression: %@", error);
    }
    else
    {
        res = [regExpression numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    }
    
    return res;
}

- (BOOL)checkSimplePasswordString
{
    if (Empty_Str(self)) {
        return YES;
    }
    else if (self.length < 4) {
        return YES;
    }
    
    char cStr[self.length];
    NSInteger compare = 0;
    strcpy(cStr, [self UTF8String]);
    
    
//    compare = cStr[0] > cStr[1] ? -1 :(cStr[0] == cStr[1] ? 0 : 1);
    compare = cStr[1] - cStr[0];

    NSInteger i = 1;
    for (; i < self.length; i++) {
        if (0 == compare) {
            if (cStr[i] == cStr[i-1]) {
                continue;
            }
            else {
                break;
            }
        }
        else if (compare < 0) {
            if (1 == cStr[i-1]-cStr[i]) {
                continue;
            }
            else {
                break;
            }
        }
        else {
            if (1 == cStr[i]-cStr[i-1]) {
                continue;
            }
            else {
                break;
            }
        }
    }
    
    if (i == self.length) {
        if (0 == compare) {
            return YES;
        }
        else if (compare < 0) {
            if ((cStr[0]<'z'&&cStr[self.length-1]>'a') || (cStr[0]<'Z'&&cStr[self.length-1]>'A') || (cStr[0]<'9'&&cStr[self.length-1]>'0')) {
                return YES;
            }
        }
        else {
            if ((cStr[0]>'a'&&cStr[self.length-1]<'z') || (cStr[0]>'A'&&cStr[self.length-1]<'Z') || (cStr[0]>'0'&&cStr[self.length-1]<'9')) {
                return YES;
            }
        }
        return NO;
    }
    else {
        return NO;
    }
}

+ (BOOL)checkMobilePhoneNumber:(NSString*)phoneNumber
{
    if (nil == phoneNumber) {
        return  NO;
    }
    
    NSString *mobilePhoneRegex = kPHONE_REGEX;
    NSUInteger phoneType = 0;
    phoneType = [phoneNumber validateCaseInsensitive:mobilePhoneRegex];
    if (0 == phoneType) {
        return NO;
    }
    return YES;
}


- (NSString*)replaceCharactersInRange:(NSRange)range withCharacter:(char)ch
{
    if (self.length < range.location+range.length) {
        return self;
    }

    NSMutableString *tarString = [[NSMutableString alloc] initWithString:self];
    for (NSInteger i = 0; i < range.length; i++) {
        [tarString replaceCharactersInRange:NSMakeRange(range.location+i, 1) withString:[NSString stringWithFormat:@"%c", ch]];
    }
    return tarString;
}

+(BOOL) chk18PaperId:(NSString *) sPaperId

{
    sPaperId=[sPaperId lowercaseString];
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    long lSumQT =0;
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    unsigned char sChecker[11]={'1','0','x', '9', '8', '7', '6', '5', '4', '3', '2'};
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        
        return NO;
        
    }
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    if( 18 != strlen(PaperId)) return -1;
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    return YES;
}
+(BOOL)areaCode:(NSString *)code

{
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}


+(NSString *)getStringWithRange:(NSString *)str Value1:(int)value1 Value2:(NSInteger )value2;

{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}
+ (BOOL)checkPasswordLength:(NSString*)pwd
{
    if (!Empty_Str(pwd)) {
        if (pwd.length >= 6 || pwd.length <= 20) {
            return YES;
        }
    }
    return NO;
}

@end
