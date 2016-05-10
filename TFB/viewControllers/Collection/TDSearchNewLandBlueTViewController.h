//
//  TDSearchNewLandBlueTViewController.h
//  TFB
//
//  Created by Nothing on 15/11/16.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"
#import <MESDK/MESDK.h>
#import "HFBSwipeViewController.h"

typedef NS_ENUM(NSInteger, DeviceListPushVCType) {
    BindDevice = 0,
    SwipeCard
};

@interface TDSearchNewLandBlueTViewController : TDBaseViewController <UITableViewDataSource, UITableViewDelegate, NLDeviceEventListener>

@property (nonatomic, assign) DeviceListPushVCType pushVCType;
@property (nonatomic, strong) NSString *payMoney; // 收款金额
@property (nonatomic, assign) NSInteger NLDevWithPinKey; // 新大陆蓝牙(带键盘)
@property (nonatomic, assign) HFBNewLanPayType hfbNewLandPayType;
@property (nonatomic, strong) TDPayInfo *payInfo;

@end
