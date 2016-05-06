//
//  TDAppDelegate.h
//  TFB
//
//  Created by Nothing on 15/3/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MESDK/MESDK.h>
#define TERMCSN @"termCSN"

@interface TDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//新大陆刷卡器
@property (strong, nonatomic) id<NLDeviceDriver> driver;
@property (strong, nonatomic) id<NLDevice> device;

+ (TDAppDelegate*)sharedAppDelegate;
- (void)exitApplication;
@end
