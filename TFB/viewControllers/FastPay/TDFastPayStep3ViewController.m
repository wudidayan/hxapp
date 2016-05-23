//
//  TDFastPayStep2ViewController.m
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import "TDFastPayStep3ViewController.h"
#import "TDFastPayResultViewController.h"

@interface TDFastPayStep3ViewController ()

@end

@implementation TDFastPayStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"确认付款";
    self.cardNo.text = self.fastPayContext.cardNo;
    [self.getMobileCode.layer setCornerRadius:5.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitBtnClick:(id)sender {
    [self.view endEditing:YES];

    if (self.txnAmt.text.length <= 0) {
        [self.view makeToast:@"请输入交易金额" duration:2.0f position:@"center"];
        return;
    }

    if (self.mobileCode.text.length < 4) {
        [self.view makeToast:@"请输入手机校验码" duration:2.0f position:@"center"];
        return;
    }
    
    self.fastPayContext.txnAmt = _txnAmt.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view makeToast:CString(@"%@", self.fastPayContext.txnAmt) duration:2.0f position:@"center"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    TDFastPayResultViewController *fastPayController = [[TDFastPayResultViewController alloc]init];
    fastPayController.isSuccess = TRUE;
    fastPayController.resultState = @"交易成功";
    fastPayController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fastPayController animated:YES];
}

- (IBAction)getMobileCodeClick:(id)sender {
    [self.view endEditing:YES];
    [self.view makeToast:CString(@"验证码已发送(%@)", self.fastPayContext.mobileNo) duration:2.0f position:@"center"];
}

- (void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickbackButton {
    //[self.navigationController popViewControllerAnimated:YES];
    [self popToRoot];
}

@end
