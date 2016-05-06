//
//  BankCardCameraViewController.h
//
//  Created by etop on 15/10/22.
//  Copyright (c) 2015年 etop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import "TDPayInfo.h"

@class BankCardCameraViewController;
@protocol CameraDelegate <NSObject>

@required
//vin码初始化结果，判断核心是否初始化成功
- (void)initBankCardWithResult:(int)nInit;

@optional

@end

@interface BankCardCameraViewController : UIViewController
@property (assign, nonatomic) id<CameraDelegate>delegate;
@property(strong, nonatomic) UIImage *resultImg;
@property (copy, nonatomic) NSString *nsUserID; //授权码
@property (copy, nonatomic) NSString *nsNo; //识别结果
@property (nonatomic,strong) TDPayInfo * payInfo;

@property (copy, nonatomic) NSString *only;
@property (copy, nonatomic) NSString *prdordno;

@end
