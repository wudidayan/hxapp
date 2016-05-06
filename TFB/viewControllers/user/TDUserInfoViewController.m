//
//  TDUserInfoViewController.m
//  TFB
//
//  Created by Nothing on 15/4/11.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDUserInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TDBankCardInfo.h"
#import "TDBalanceInfo.h"

@interface TDUserInfoViewController ()

@end

@implementation TDUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商户信息";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
     [self backButton];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5.0;

//    self.tatolLabel.text = [NSString stringWithFormat:@"%.2f",[TDBalanceInfo balanceDefault].acBal.floatValue/100];
    self.checkDone.text = [NSString stringWithFormat:@"已审核金额:%.2f",[TDBalanceInfo balanceDefault].acT1AP.floatValue/100];
    self.notCheck.text = [NSString stringWithFormat:@"未审核金额:%.2f",[TDBalanceInfo balanceDefault].acT1UNA.floatValue/100];
    self.checkFail.text = [NSString stringWithFormat:@"审核不通过金额:%.2f",[TDBalanceInfo balanceDefault].acT1AUNP.floatValue/100];
//    self.AlreadyLabel.text = [NSString stringWithFormat:@"已结算金额:%.2f",[TDBalanceInfo balanceDefault].acT1Y.floatValue/100];
//    self.notSetabel.text = [NSString stringWithFormat:@"未结算金额:%.2f",[TDBalanceInfo balanceDefault].acT0.floatValue/100];
//    self.trialLabel.text = [NSString stringWithFormat:@"待审金额:%.2f",[TDBalanceInfo balanceDefault].acT0.floatValue/100];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TDHttpEngine requestForGetBankCardInfoWithMobile:[TDUser defaultUser].custLogin WithCustId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"shuju:   %@", temArray);
        if (succeed) {
            [self creatUIWithBankArray:temArray];
        }
        else
        {
            [self.view makeToast:msg duration:2.0f position:@"center"];
            [self.navigationController performSelector:@selector(popToViewController:animated:) withObject:@YES afterDelay:2.0f];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUIWithBankArray:(NSArray *)array
{

    TDBankCardInfo * info;
    if (array.count) {
        info = array[0];
    }
    
    self.userMoblie.text = [TDUser defaultUser].custLoginStar;
    self.userName.text = [TDUser defaultUser].custName?[TDUser defaultUser].custName:@"- -";
    self.BankCardNum.text = info.cardNoStar?info.cardNoStar:@"尚未绑定银行卡";
    self.BankName.text = info.issnam?info.issnam:@"尚未绑定银行卡";
    if (!self.userMoblie.text) {
        self.userMoblie.text = @"";
    }
    if (!self.userName.text) {
        self.userName.text = @"";
    }
    if (!self.BankCardNum.text) {
        self.BankCardNum.text = @"";
    }
    if (!self.BankName.text) {
        self.BankName.text = @"";
    }
}


- (IBAction)clickButton:(UIButton *)sender {
    
    [self clickbackButton];
    
}
@end
