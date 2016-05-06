//
//  TDNLBlueSwipeViewController.h
//  TFB
//
//  Created by Nothing on 15/11/17.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"
#import "HFBSwipeViewController.h"

@interface TDNLBlueSwipeViewController : TDBaseViewController <NLDeviceEventListener,NLAudioPortListener,NLEmvControllerListener>

@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) TDPayInfo * payInfo;
@property (nonatomic, assign) HFBNewLanPayType hfbNewLandPayType;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
