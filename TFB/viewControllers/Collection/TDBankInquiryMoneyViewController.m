//
//  TDBankInquiryMoneyViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/6.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBankInquiryMoneyViewController.h"

@interface TDBankInquiryMoneyViewController ()

@end

@implementation TDBankInquiryMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的余额";
    [self backButton];
    
    self.bankCardMumLabel.text = self.bankCardNum;
    self.BankCardMoneyLabel.text = self.money;
    
    //[self inquiryBlance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)inquiryBlance {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    
    [TDHttpEngine requestForBankCardBalanceWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:_payInfo.termInfo.termNo termType:_payInfo.termType track:_payInfo.track pinblk:_payInfo.pinblk random:@"" mediaType:_payInfo.mediaType period:_payInfo.period icdata:_payInfo.icdata crdnum:_payInfo.crdnum mac:_payInfo.mac complete:^(BOOL succeed, NSString *msg, NSString *cod, NSString *balance) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            
            self.BankCardMoneyLabel.text = [NSString stringWithFormat:@"%.2f", [balance floatValue] / 100];
        }
    }];
}

-(void)clickbackButton{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)clickButton:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
