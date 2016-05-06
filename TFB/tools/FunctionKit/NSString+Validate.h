//
//  NSString+Validate.h
//  BlackTea
//
//  Created by ChenQi on 12-9-26.
//
//  描述: 字符串合法性验证
//

#import <Foundation/Foundation.h>


typedef struct _BTLengthRange
{
    NSUInteger min;
    NSUInteger max;
} BTLengthRange;

NS_INLINE BTLengthRange BTMakeLengthRange(NSUInteger min, NSUInteger max)
{
    BTLengthRange r;
    r.min = min;
    r.max = max;
    return r;
}

NS_INLINE BOOL BTEqualLengthRanges(BTLengthRange range1, BTLengthRange range2)
{
    return (range1.min == range2.min && range1.max == range2.max);
}


@interface NSString (Validate)

- (BOOL)validateLengthRange:(BTLengthRange)range;
- (NSUInteger)validateCaseInsensitive:(NSString *)regex;
- (BOOL)checkSimplePasswordString;

- (NSString*)replaceCharactersInRange:(NSRange)range withCharacter:(char)ch;

+ (BOOL)checkMobilePhoneNumber:(NSString*)phoneNumber;
+(BOOL) chk18PaperId:(NSString *) sPaperId;
+ (BOOL)checkPasswordLength:(NSString*)pwd;
@end