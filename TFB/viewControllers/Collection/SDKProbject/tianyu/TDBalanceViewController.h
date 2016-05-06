//
//  TDBalanceViewController.h
//  TFB
//
//  Created by 宋亚轩 on 16/4/14.
//  Copyright © 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"
#import "ZSYPopoverListView.h"
#import "TYCommonLib.h"
#import "TDLanYaUerInfo.h"
#import "TDPayInfo.h"
#define STATUSONE @"01" //
#define STATUSTWO @"02" //


@interface TDBalanceViewController : TDBaseViewController<ZSYPopoverListDatasource,ZSYPopoverListDelegate,TYSwiperControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnClick:(UIButton *)sender;

@end
