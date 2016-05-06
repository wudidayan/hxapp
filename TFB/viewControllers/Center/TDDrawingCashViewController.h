//
//  TDDrawingCashViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDBalanceInfo.h"
@interface TDDrawingCashViewController : TDBaseViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *moneyText;
@property (strong, nonatomic) IBOutlet UILabel *RateLabel;
@property (strong, nonatomic) IBOutlet UITextField *bankCardNumText;
//@property (strong, nonatomic) IBOutlet UILabel *AlreadyAmtLabel;
//@property (strong, nonatomic) IBOutlet UILabel *DoesNotAmtLabel;
@property (strong, nonatomic) IBOutlet UILabel *TatolAmtLabel;
//@property (strong, nonatomic) IBOutlet UILabel *daishenAmt;

@property (strong, nonatomic) IBOutlet UITextField *payPasswordText;

@property (nonatomic,strong) TDBalanceInfo * balanceInfo;
- (IBAction)clickFeeButton:(UIButton *)sender;

- (IBAction)clickButton:(UIButton *)sender;

@end
