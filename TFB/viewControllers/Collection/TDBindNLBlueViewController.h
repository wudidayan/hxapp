//
//  TDBindNLBlueViewController.h
//  TFB
//
//  Created by Nothing on 15/11/17.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import <MESDK/MESDK.h>
#import <MESDK/NLAudioPortV100ConnParams.h>
#import <MESDK/NLDeviceLaunchEvent.h>
#import <MESDK/NLAudioPortHelper.h>
#import <MESDK/NLTLVPackageUtils.h>


@interface TDBindNLBlueViewController : TDBaseViewController <NLDeviceEventListener>


@property (nonatomic, strong)NSString *termName;

@property (weak, nonatomic) IBOutlet UILabel *termNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *termTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *termCsnLabel;
- (IBAction)bindBtnClick:(id)sender;
@end
