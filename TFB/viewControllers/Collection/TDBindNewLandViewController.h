//
//  TDBindNewLandViewController.h
//  TFB
//
//  Created by Nothing on 15/7/6.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDAppDelegate.h"
#import <MESDK/MESDK.h>
#import <MESDK/NLAudioPortV100ConnParams.h>
#import <MESDK/NLDeviceLaunchEvent.h>
#import <MESDK/NLAudioPortHelper.h>
#import <MESDK/NLTLVPackageUtils.h>

@interface TDBindNewLandViewController : TDBaseViewController

@property (strong, nonatomic) id<NLDeviceDriver> driver;
@property (strong, nonatomic) id<NLDevice> device;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviNum;

@end
