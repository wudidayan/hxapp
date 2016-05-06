//
//  TDBankInquiryViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBankInquiryViewController.h"
#import "TDBankInquiryMoneyViewController.h"
#import "CJCommon.h"
#import "TDPinKeyInfo.h"
@interface TDBankInquiryViewController ()

@end

@implementation TDBankInquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     _bankCardNumLabel.text =  _payInfo.bankCardNumber;
    [self backButton];
    self.title = @"余额查询";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickbackButton{

    [self.navigationController popToRootViewControllerAnimated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickButton:(UIButton *)sender {
    
    if (6 != _passTextField.text.length) {
        
        [self.view makeToast:@"请输入正确的银行卡密码" duration:2.0f position:@"center"];
        return;
    }
    
    if (_payInfo.mac == nil) {
        _payInfo.mac = @"";
    }
    if (!_payInfo.period || [_payInfo.period isEqualToString:@""]) {
        _payInfo.period = @"1111";
    }
    _payInfo.pinblk = [CJCommon pinResultMak:[TDPinKeyInfo pinKeyDefault].zpinkey account:_payInfo.bankCardNumber passwd:_passTextField.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",[TDUser defaultUser].custId,[TDUser defaultUser].custLogin,_payInfo.termInfo.termNo,_payInfo.termType,_payInfo.track,_payInfo.pinblk,@"9000",_payInfo.mediaType,_payInfo.period,_payInfo.icdata,_payInfo.crdnum,_payInfo.mac);
    [TDHttpEngine requestForBankCardBalanceWithCustId:[TDUser defaultUser].custId
                                           custMobile:[TDUser defaultUser].custLogin
                                               termNo:_payInfo.termInfo.termNo
                                             termType:_payInfo.termType
                                                track:_payInfo.track
                                               pinblk:_payInfo.pinblk
                                               random:@"CDB9C9D14724091B"
                                            mediaType:_payInfo.mediaType
                                               period:_payInfo.period
                                               icdata:_payInfo.icdata
                                               crdnum:_payInfo.crdnum
                                                  mac:_payInfo.mac complete:^(BOOL succeed, NSString *msg, NSString *cod, NSString *balance) {

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            TDBankInquiryMoneyViewController * moneyController = [[TDBankInquiryMoneyViewController alloc]init];
            moneyController.money = [NSString stringWithFormat:@"%.2f", [balance doubleValue] / 100];;
            moneyController.bankCardNum = _payInfo.bankCardNumber;
            [weakSelf.navigationController pushViewController:moneyController animated:YES];
        }
    }];
}
@end
