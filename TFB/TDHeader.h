//
//  TDHeader.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#ifndef TFB_TDHeader_h
#define TFB_TDHeader_h
  
// 方法

#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)sharedInstance;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)sharedInstance { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#define RGB_A(r, g, b, a) ([UIColor colorWithRed:(r)/255.0f \
green:(g)/255.0f \
blue:(b)/255.0f \
alpha:(a)/255.0f])

#define RGB(r, g, b) RGB_A(r, g, b, 255)


#ifdef DEBUG

//调试状态
#define Log(...) NSLog(__VA_ARGS__)

//发布状态
#else

#define Log(...)


#endif


#define IS_OBJ_AVAILABLE(obj)       (nil != (obj) && [NSNull null] != (NSNull *)(obj))
#define Empty_Collection(param)     (nil == param || param.count < 1)
#define Empty_Str(param)            (nil == param || param.length < 1)

#define kPHONE_REGEX     @"1[0-9]{10}$"//手机号码格式检测
#endif
