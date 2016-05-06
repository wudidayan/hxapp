//
//  HFBSwipeViewController.h
//  TFB
//
//  Created by Nothing on 15/8/5.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDAppDelegate.h"
#import <MESDK/MESDK.h>
#import <MESDK/NLAudioPortV100ConnParams.h>
#import <MESDK/NLDeviceLaunchEvent.h>
#import <MESDK/NLAudioPortHelper.h>
#import <MESDK/NLTLVPackageUtils.h>
#import "TDPayInfo.h"
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSInteger, HFBNewLanPayType)
{
    HFBkNewLandBankInquiry  = 0,   //余额查询
    HFBkNewLandPayment,            //支付
    HFBkNewLandPayTerm,            //购买刷卡器
    HFBkNewLandPaymentT            //在线支付
};

@interface HFBSwipeViewController : TDBaseViewController

@property (strong, nonatomic) id<NLDeviceDriver> driver;
@property (strong, nonatomic) id<NLDevice> device;

@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) TDPayInfo * payInfo;
@property (nonatomic, assign) HFBNewLanPayType hfbNewLandPayType;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@end
