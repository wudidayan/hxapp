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
@property (weak, nonatomic) IBOutlet UILabel *swipeCardAct;
@property (weak, nonatomic) IBOutlet UIButton *swipeCardActBtn;
@property (weak, nonatomic) IBOutlet UILabel *scanCodeAct;
@property (weak, nonatomic) IBOutlet UIButton *scanCodeActBtn;
@property (weak, nonatomic) IBOutlet UILabel *fastPayAct;
@property (weak, nonatomic) IBOutlet UIButton *fastPayActBtn;
@property (weak, nonatomic) IBOutlet UILabel *actTips;
- (IBAction)clickFeeButton:(UIButton *)sender;
- (IBAction)clickSwipeCardActBtn:(UIButton *)sender;
- (IBAction)clickScanCodeActBtn:(UIButton *)sender;
- (IBAction)clickFastPayActBtn:(UIButton *)sender;
- (IBAction)clickButton:(UIButton *)sender;

@end
