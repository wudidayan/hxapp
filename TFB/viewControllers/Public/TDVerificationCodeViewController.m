//
//  TDVerificationCodeViewController.m
//  TFB
//
//  Created by Nothing on 15/3/25.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDVerificationCodeViewController.h"
#import "TDRegistViewController.h"
#import "TDForgetPwdViewController.h"
#import "TDAgreementViewController.h"

@interface TDVerificationCodeViewController ()
{
    NSString *_codeType;
    //
    dispatch_queue_t queue ;
    dispatch_source_t _timer;
    BOOL _isCanRequest;
}
@end

@implementation TDVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"获取验证码";
 
    [self backButton];
    [self creatLayerWithView:_phoneNumTF.superview];
 if (self.verCodeType != VerRegist) {
        _phoneNumTF.text = [TDUser defaultUser].custLogin;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)getVercode
{
         self.mobileNum = _phoneNumTF.text;
    if (NO == [NSString checkMobilePhoneNumber:_phoneNumTF.text]) {
        [self.view makeToast:@"无效的手机号码" duration:2.0f position:@"center"];
        return;
    }
        _isCanRequest = YES;
    
    
    if (self.verCodeType == VerRegist) {
        _codeType = @"01";
    }
    else if (self.verCodeType == VerEditLoginPwd){
        _codeType = @"02";
    }
    else if (self.verCodeType == VerEditPayPwd){
        _codeType = @"03";
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TDHttpEngine requestForGetMsgCodeWithCustMobile:self.mobileNum codeType:_codeType complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
          [self.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            
          [self timerFireMethod];
        }
    }];

}

//验证码跳秒方法
- (void)timerFireMethod
{
    _YZMButton.userInteractionEnabled = NO;
    __block int timeout = YZM_TIME_CODE-1; //倒计时时间
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _YZMButton.userInteractionEnabled = YES;
                [_YZMButton setTitle:@"获取验证码" forState:0];
            });
        }else{
            int seconds = timeout % YZM_TIME_CODE;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
  
                [_YZMButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:0];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)clickBoxButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (IBAction)clickServiceButton:(UIButton *)sender {
    
    TDAgreementViewController * agreementVC = [[TDAgreementViewController alloc]init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (IBAction)clickYZMButton:(UIButton *)sender {
    
    [self getVercode];
    
}

- (IBAction)nextBtnClick:(id)sender {
    
    if (NO == _checkBoxButton.selected) {
        
         [self.view makeToast:@"需要确认服务协议" duration:2.0f position:@"center"];
        return;
    }

    if (!_isCanRequest) {
        [self.view makeToast:@"请先获取验证码" duration:2.0f position:@"center"];
        return;
    }
    
    if (Empty_Str(_vercodeTF.text)) {
        [self.view makeToast:@"请输入验证码" duration:2.0f position:@"center"];
        return;
    }
    if (YZM_NUM_CODE > _vercodeTF.text.length) {
        [self.view makeToast:@"验证码位6位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [TDHttpEngine requestForVerifyMsgCodeWithCustMobile:self.mobileNum codeType:_codeType msgCode:self.vercodeTF.text complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeed) {
            
            if (self.verCodeType == VerRegist) {
                TDRegistViewController *registVC = [[TDRegistViewController alloc] init];
                registVC.mobileNum = self.phoneNumTF.text;
                [self.navigationController pushViewController:registVC animated:YES];
            }
            else{
                TDForgetPwdViewController *forgetPwdVC = [[TDForgetPwdViewController alloc] init];
                if (self.verCodeType == VerEditLoginPwd) {
                    
                    forgetPwdVC.pwdType = kForGetLogInPwd;
                }
                if (self.verCodeType == VerEditPayPwd) {
                      forgetPwdVC.pwdType = kForGetPayPwd;
                }
                forgetPwdVC.value = self.vercodeTF.text;
                forgetPwdVC.custMobile = self.phoneNumTF.text;
                [self.navigationController pushViewController:forgetPwdVC animated:YES];
            }
        }
        else{
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _YZMImageV.highlighted = NO;
    _iphoneImageV.highlighted = NO;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _phoneNumTF) {
        _YZMImageV.highlighted = NO;
        _iphoneImageV.highlighted = YES;
    }else if (textField == _vercodeTF){
        _YZMImageV.highlighted = YES;
        _iphoneImageV.highlighted = NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _phoneNumTF) {
        [_vercodeTF becomeFirstResponder];
    }else if (textField == _vercodeTF){
        [textField resignFirstResponder];
    }
    
    return YES;
}
@end
