//
//  TDFastPayStep2ViewController.m
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import "TDFastPayStep2ViewController.h"
#import "TDFastPayStep3ViewController.h"

@interface TDFastPayStep2ViewController ()

@end

@implementation TDFastPayStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"填写支付要素";
    self.cardNo.text = self.fastPayContext.cardNo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitBtnClick:(id)sender {
    [self.view endEditing:YES];

    if (self.cardExpireDate.text.length != 4) {
        [self.view makeToast:@"请输入卡有效期(YYMM)" duration:2.0f position:@"center"];
        return;
    }

    NSInteger mm = [[self.cardExpireDate.text substringWithRange:(NSRange){2,2}] integerValue];
    if (mm > 12) {
        [self.view makeToast:@"请输入正确的卡有效期(YYMM)" duration:2.0f position:@"center"];
        return;
    }

    if (self.cardCvv.text.length != 3) {
        [self.view makeToast:@"请输入CVV（卡背面3位数字）" duration:2.0f position:@"center"];
        return;
    }

    if (![NSString validateIdentityCard: self.idNo.text]) {
        [self.view makeToast:@"请输入正确的身份证号码" duration:2.0f position:@"center"];
        return;
    }
    
    if (![NSString validateMobile: self.mobileNo.text]) {
        [self.view makeToast:@"请输入手机号码(11位数字)" duration:2.0f position:@"center"];
        return;
    }
    
    
    self.fastPayContext.cardExpireDate = _cardExpireDate.text;
    self.fastPayContext.cardCvv = _cardCvv.text;
    self.fastPayContext.mobileNo = _mobileNo.text;
    self.fastPayContext.idNo = _idNo.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view makeToast:CString(@"%@ ／ %@ / %@ ／ %@ / %@ / %@", self.fastPayContext.cardNo, self.fastPayContext.bankName, self.fastPayContext.cardExpireDate, self.fastPayContext.cardCvv, self.fastPayContext.mobileNo, self.fastPayContext.idNo) duration:2.0f position:@"center"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    TDFastPayStep3ViewController *fastPayController = [[TDFastPayStep3ViewController alloc]init];
    fastPayController.fastPayContext = self.fastPayContext;
    fastPayController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fastPayController animated:YES];
}

- (void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickbackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

@end
