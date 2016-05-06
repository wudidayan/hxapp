//
//  Config.h
//  iamkicker
//
//  Created by zhoujun on 15/7/24.
//  Copyright (c) 2015年 SmilodonTech. All rights reserved.
//

#ifndef iamkicker_Config_h
#define iamkicker_Config_h

#define BaseURL @"http://112.74.197.72/"

#define ImageBase @"http://images.urllife.com/"

#define fullPath(url) [NSString stringWithFormat:@"%@%@",BaseURL,url];

#define fullPathForImg(url) [NSString stringWithFormat:@"%@%@",ImageBase,url];


#define iOS ([[[UIDevice currentDevice] systemVersion] floatValue])

#define isRetina ([[UIScreen mainScreen] scale]==2)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE4_SCREEN ([[UIScreen mainScreen] bounds].size.height == 480)

#define JJImageJPEGRepresentation(image) UIImageJPEGRepresentation(image, 0.5)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define kNotNull(input) (input == [NSNull null]?@"":input);

//设备屏幕尺寸
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]



#define	colorA1  555555

#define	colorA6  909090





#endif





