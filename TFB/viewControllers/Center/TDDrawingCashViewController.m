//
//  TDDrawingCashViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDDrawingCashViewController.h"
#import "TDBankCardInfo.h"
#import "TDBindBankCardViewController.h"


@interface TDDrawingCashViewController (){

 
    BOOL _isFee;
    NSString * _oldMoney;
    int _actType;
    NSString * _actTypeStr;
    NSString * _amtAcctType02;
    NSString * _amtAcctType03;
    NSString * _amtAcctType04;
}

@property (nonatomic,strong) NSString * casType; //提现类型
@property (nonatomic,strong) NSString * cardNo;
@property (nonatomic,assign) NSInteger balanceAvailable;

@end

@implementation TDDrawingCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    self.casType = @"3";
    [self backButton];
    [self requestBalance];
    _isFee =  NO;
    
    _moneyText.enabled = FALSE;
    _actType = 0;
    _actTypeStr = @"";
    _amtAcctType02 = @"";
    _amtAcctType03 = @"";
    _amtAcctType04 = @"";
   }

-(void)requestBalance{
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForgetBalanceWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, TDBalanceInfo *info) {
        if (succeed) {
            
//          weakSelf.TatolAmtLabel.text = [NSString stringWithFormat:@"%.2f",info.acT1AP.floatValue/100];
            weakSelf.TatolAmtLabel.text = [NSString stringWithFormat:@"%.2f",info.balanceDisp.floatValue/100.0];
            weakSelf.swipeCardAct.text = [NSString stringWithFormat:@"%.2f",info.acT1AP.floatValue/100.0];
            weakSelf.scanCodeAct.text = [NSString stringWithFormat:@"%.2f",info.acT1AP_ACT04.floatValue/100.0];
            weakSelf.fastPayAct.text = [NSString stringWithFormat:@"%.2f",info.acT1AP_ACT03.floatValue/100.0];
            self.balanceAvailable = info.balance.integerValue;
            
//            weakSelf.AlreadyAmtLabel.text = [NSString stringWithFormat:@"已结算金额:%.2f",info.acT1Y.floatValue/100];
//            weakSelf.DoesNotAmtLabel.text = [NSString stringWithFormat:@"未结算金额:%.2f",info.acT0.floatValue/100];
//            weakSelf.daishenAmt.text = [NSString stringWithFormat:@"待审金额:%.2f",info.acT0.floatValue/100];
            
            //查询银行卡
            [TDHttpEngine requestForGetBankCardInfoWithMobile:[TDUser defaultUser].custLogin WithCustId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (succeed) {
                    
                    if (temArray.count) {
                        TDBankCardInfo * BankCardInfo = [temArray firstObject];
                        _bankCardNumText.text  =   BankCardInfo.cardNoStar;
                        weakSelf.cardNo = BankCardInfo.cardNo;
                    }else{
                        //引导用户绑定
                        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未绑定银行卡,无法进行提现操作,是否前往绑定" delegate:self cancelButtonTitle:@"前往绑定" otherButtonTitles:@"下次再说", nil];
                        [al show];
                    }
                }
                else
                {
                    [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
                    [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
                    
                }
            }];
            
        }else{
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
        }
    }];


}
-(void)requestUpdataBalance{

    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForgetBalanceWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, TDBalanceInfo *info) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (succeed) {
            
//          weakSelf.TatolAmtLabel.text = [NSString stringWithFormat:@"%.2f",info.acT1AP.floatValue/100];
            weakSelf.TatolAmtLabel.text = [NSString stringWithFormat:@"%.2f",info.balanceDisp.floatValue/100];
            weakSelf.swipeCardAct.text = [NSString stringWithFormat:@"%.2f",info.acT1AP.floatValue/100.0];
            weakSelf.scanCodeAct.text = [NSString stringWithFormat:@"%.2f",info.acT1AP_ACT04.floatValue/100.0];
            weakSelf.fastPayAct.text = [NSString stringWithFormat:@"%.2f",info.acT1AP_ACT03.floatValue/100.0];
            self.balanceAvailable = info.balance.integerValue;
//            weakSelf.AlreadyAmtLabel.text = [NSString stringWithFormat:@"已结算金额:%.2f",info.acT1Y.floatValue/100];
//            weakSelf.DoesNotAmtLabel.text = [NSString stringWithFormat:@"未结算金额:%.2f",info.acT0.floatValue/100];
            //            weakSelf.daishenAmt.text = [NSString stringWithFormat:@"待审金额:%.2f",info.acT0.floatValue/100];
            
        }else{
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
          
        }
          [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    
    if (textField == _moneyText) {
        
        if (textField.text.length == 0) {
            if([string isEqualToString:@"."]) {
                return NO;
            }
        }
        if ([textField.text rangeOfString:@"."].length == 1) {
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (IBAction)clickFeeButton:(UIButton *)sender {
    
    _oldMoney = _moneyText.text;
    if (Empty_Str(_oldMoney)) {
        [self.view makeToast:@"请输入金额" duration:2.0f position:@"center"];
        return;
    }
    
    if(_oldMoney.floatValue <= 0) {
        [self.view makeToast:@"输入金额无效" duration:2.0f position:@"center"];
        return;
    }
    
    if(_actType == 2) {
        if (_oldMoney.floatValue > [self.swipeCardAct.text floatValue] + FLOAT_PRECISION) {
            [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
            return;
        }
        
        _actTypeStr = @"02";
        _amtAcctType02 = [NSString stringWithFormat:@"%.2f",_oldMoney.floatValue * 100];
    }
    
    if(_actType == 3) {
        if (_oldMoney.floatValue > [self.scanCodeAct.text floatValue] + FLOAT_PRECISION) {
            [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
            return;
        }
        
        _actTypeStr = @"03";
        _amtAcctType03 = [NSString stringWithFormat:@"%.2f",_oldMoney.floatValue * 100];
    }
    
    if(_actType == 4) {
        if (_oldMoney.floatValue > [self.fastPayAct.text floatValue] + FLOAT_PRECISION) {
            [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
            return;
        }
        
        _actTypeStr = @"04";
        _amtAcctType04 = [NSString stringWithFormat:@"%.2f",_oldMoney.floatValue * 100];
    }

    int iBalanceAvailable = (int)self.balanceAvailable;
    if (_oldMoney.floatValue > iBalanceAvailable / 100.0 + FLOAT_PRECISION) {
        [self.view makeToast:@"可提余额不足" duration:2.0f position:@"center"];
        return;
    }
    
    //计算手续费
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestGetFeeWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin andTxamt:[NSString stringWithFormat:@"%.2f",_oldMoney.floatValue *100] andCasType:_casType andAcctType:_actTypeStr andAmtAcctType02:_amtAcctType02 andAmtAcctType03:_amtAcctType03 andAmtAcctType04:_amtAcctType04  complete:^(BOOL succeed, NSString *msg, NSString *cod, NSString *fee) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeed) {
            _isFee = YES;
            _RateLabel.text = fee;
        }else{
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
        
    }];
    
}


- (IBAction)clickButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (![_oldMoney isEqualToString:_moneyText.text]) {
        if (!_isFee) {
            [self.view makeToast:@"请计算手续费" duration:2.0f position:@"center"];
            return;
        }
        
    }
    
    _isFee = NO;

    if (_moneyText.text.length <= 0) {
        [self.view makeToast:@"请输入提现金额" duration:2.0f position:@"center"];
        return;
    }
    
    if (([_moneyText.text floatValue]) > [self.TatolAmtLabel.text floatValue] + FLOAT_PRECISION) {
        [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
        return;
    }

    if(_actType == 2) {
        if (([_moneyText.text floatValue]) > [self.swipeCardAct.text floatValue] + FLOAT_PRECISION) {
            [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
            return;
        }
        
        _actTypeStr = @"02";
        _amtAcctType02 = [NSString stringWithFormat:@"%.2f", [_moneyText.text floatValue] * 100];
    }
    
    if(_actType == 3) {
        if (([_moneyText.text floatValue]) > [self.scanCodeAct.text floatValue] + FLOAT_PRECISION) {
            [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
            return;
        }
        
        _actTypeStr = @"03";
        _amtAcctType03 = [NSString stringWithFormat:@"%.2f", [_moneyText.text floatValue] * 100];
    }
    
    if(_actType == 4) {
        if (([_moneyText.text floatValue]) > [self.fastPayAct.text floatValue] + FLOAT_PRECISION) {
            [self.view makeToast:@"余额不足" duration:2.0f position:@"center"];
            return;
        }
        
        _actTypeStr = @"04";
        _amtAcctType04 = [NSString stringWithFormat:@"%.2f", [_moneyText.text floatValue] * 100];
    }
    
    int iBalanceAvailable = (int)self.balanceAvailable;
    if (([_moneyText.text floatValue]) > iBalanceAvailable / 100.0 + FLOAT_PRECISION) {
        [self.view makeToast:@"可提余额不足" duration:2.0f position:@"center"];
        return;
    }
    
    if (NO == [NSString checkPasswordLength:_payPasswordText.text]) {
        [self.view makeToast:@"密码长度为6-20位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * amt = [NSString stringWithFormat:@"%.2f",_moneyText.text.floatValue* 100];
    [TDHttpEngine requestFortxTranWithCustId:[TDUser defaultUser].custId Mobile:[TDUser defaultUser].custLogin txamt:amt casType:_casType cardNo:_cardNo payPwd:_payPasswordText.text andAcctType:_actTypeStr andAmtAcctType02:_amtAcctType02 andAmtAcctType03:_amtAcctType03 andAmtAcctType04:_amtAcctType04 complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [self.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            
            [self requestUpdataBalance];
            
        }else{
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (0 == buttonIndex) {
        
        TDBindBankCardViewController * bankCard = [[TDBindBankCardViewController alloc]init];
        [self.navigationController pushViewController:bankCard animated:YES];
        
        
    }else if(1 == buttonIndex){
      
        [self.navigationController popViewControllerAnimated:YES];
    
    }


}

- (IBAction)clickSwipeCardActBtn:(UIButton *)sender {
    self.actTips.text = @"提: 刷卡账户";
    _moneyText.text = self.swipeCardAct.text;
    _actType = 2;
    _moneyText.enabled = TRUE;
}

- (IBAction)clickScanCodeActBtn:(UIButton *)sender {
    self.actTips.text = @"提: 扫码账户";
    _moneyText.text = self.scanCodeAct.text;
    _actType = 4;
    _moneyText.enabled = TRUE;
}

- (IBAction)clickFastPayActBtn:(UIButton *)sender {
    self.actTips.text = @"提: 快捷账户";
    _moneyText.text = self.fastPayAct.text;
    _actType = 3;
    _moneyText.enabled = TRUE;
}

@end
