//
//  TDRegistViewController.m
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDRegistViewController.h"
#import "TDAgreementViewController.h"


@interface TDRegistViewController ()
{
    MKNetworkEngine *_mkNetworkEngine;
    
    dispatch_queue_t queue ;
    dispatch_source_t _timer;
}
@end

@implementation TDRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self backButton];
    [self creatLayerWithView:_loginPwdTF.superview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkBtnClick:(id)sender {
  
    UIButton * button = (UIButton *)sender;
    button.selected  = !button.selected;
}

- (IBAction)agreementBtnClick:(id)sender {
    
    TDAgreementViewController * agreentVC = [[TDAgreementViewController alloc]init];
    [self.navigationController pushViewController:agreentVC animated:YES];
    
}

- (IBAction)commitBtnClick:(id)sender {
    
    if (YES == _checkBtn.selected) {
        [self.view makeToast:@"请先同意支付协议" duration:2.0f position:@"center"];
        return;
    }
    NSString *loginPwd = [self.loginPwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *againLoginPwd = [self.againLonginPwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if (NO == [NSString checkPasswordLength:loginPwd]) {
        [self.view makeToast:@"密码长度为6-20位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }
    if (![loginPwd isEqualToString:againLoginPwd]) {
        [self.view makeToast:@"两次输入密码不一致" duration:2.0f position:@"center"];
        return;
    }

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [TDHttpEngine requestForRegistWithCustMobile:self.mobileNum custPwd:_loginPwdTF.text  referrer:@"" complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@YES afterDelay:2.0f];
        }
        else{
            
        }
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _nPwdImageV.highlighted = NO;
    _pwdImageV.highlighted = NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _loginPwdTF) {
        _nPwdImageV.highlighted = NO;
        _pwdImageV.highlighted = YES;
    }else if (textField == _againLonginPwdTF){
        _nPwdImageV.highlighted = YES;
        _pwdImageV.highlighted = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _loginPwdTF) {
        [_againLonginPwdTF becomeFirstResponder];
    }else if (textField == _againLonginPwdTF){
        [self.view endEditing:YES];
    }
    
    return YES;
}
@end
