//
//  TDLoginViewController.m
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDLoginViewController.h"
#import "TDRegistViewController.h"
#import "TDForgetPwdViewController.h"
#import "TDSignViewController.h"

#import "TDVerificationCodeViewController.h"
#import "TDHttpEngine.h"
#import "TDAnimation.h"
#import "NSString+Regex.h"
#import "UIImage+Reflection.h"

#define LOGIN_BTN_TAG 100
#define REGIET_BTN_TAG 101
#define FORGETPWD_BTN_TAG 102

#define USERNAMETF_TAG 200
#define USERPWD_TAG 201

@interface TDLoginViewController ()
{
//    BOOL _isRememberAccount;
}
@end

@implementation TDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = APP_NAME;
        
    [self remenberCustLogin];
//    _isRememberAccount = YES;
    
//    [self creatLayerWithView:_useMobileText.superview];
//   [_tittleImageV.layer addAnimation:[TDAnimation opacityTimes_Animation:2 durTimes:0.5] forKey:nil];
   
//    UIImage *im = [UIImage imageNamed:@"td_app_logo"];
//    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(_tittleImageV.frame.origin.x,
//                                                                       CGRectGetMaxY(_tittleImageV.frame)+2,
//                                                                       _tittleImageV.frame.size.width,
//                                                                       _tittleImageV.frame.size.height * 0.2)];
//    [self.view addSubview:image];
//    [image setImage:[[_tittleImageV image] reflectionWithAlpha:0.3]];
//    [image setImage:[[_tittleImageV image] reflectionRotatedWithAlpha:1]];
//    [image setImage:[[_tittleImageV image] reflectionWithHeight:_tittleImageV.frame.size.height]];
//    [self.view bringSubviewToFront:_mobileImageV.superview];
    [self registerForKeyboardNotifications];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)remenberCustLogin
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CUST_MOBILE]) {
        NSString *custMobile = [[NSUserDefaults standardUserDefaults] objectForKey:CUST_MOBILE];
        _useMobileText.text = custMobile;
    }else{
       _useMobileText.text = @"";
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _mobileImageV.highlighted = NO;
    _passwordImageV.highlighted = NO;

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField == _useMobileText) {
        _mobileImageV.highlighted = YES;
        _passwordImageV.highlighted = NO;
    }else if (textField == _userPasswordText){
        _passwordImageV.highlighted = YES;
        _mobileImageV.highlighted = NO;
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == _useMobileText) {
        [_userPasswordText becomeFirstResponder];
    }else if (textField == _userPasswordText){
        [textField resignFirstResponder];
    }

    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)clickRegistButton:(UIButton *)sender {
    
    TDVerificationCodeViewController *verVC = [[TDVerificationCodeViewController alloc] init];
    verVC.verCodeType = VerRegist;
    [self.navigationController pushViewController:verVC animated:YES];
}

- (IBAction)clickForgetButton:(UIButton *)sender {
    
    TDVerificationCodeViewController *verVC = [[TDVerificationCodeViewController alloc] init];
    verVC.verCodeType = VerEditLoginPwd;
    [self.navigationController pushViewController:verVC animated:YES];
}

- (IBAction)clickLoginButton:(UIButton *)sender {
    
    if (NO == [NSString checkMobilePhoneNumber:_useMobileText.text]) {
        [self.view makeToast:@"无效的手机号码" duration:2.0f position:@"center"];
        return;
    }
    if (NO == [NSString checkPasswordLength:_userPasswordText.text]) {
        [self.view makeToast:@"密码长度为6-20位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }
    
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakself = self;
    [TDHttpEngine requestForLoginWithCustMobile:_useMobileText.text custPwd:_userPasswordText.text complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        
        if (succeed) {
            [[NSUserDefaults standardUserDefaults] setObject:_useMobileText.text forKey:CUST_MOBILE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            if (_isRememberAccount) {
//                [[NSUserDefaults standardUserDefaults] setObject:_useMobileText.text forKey:CUST_MOBILE];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }else{
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:CUST_MOBILE];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
            
            [TDHttpEngine requestForGetCustInfWithCustMobile:[TDUser defaultUser].custLogin custId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, TDUser *user) {
                [MBProgressHUD hideHUDForView:weakself.view animated:YES];
                if (succeed) {
                    
                    [[TDControllerManager sharedInstance]createTabbarController];
                }
                else
                {
                    [weakself.view makeToast:msg duration:2.0f position:@"center"];
                }
            }];
            
        }
        else{
            [MBProgressHUD hideHUDForView:weakself.view animated:YES];
            [weakself.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];

}


- (void) registerForKeyboardNotifications
{
    if ([NSNotificationCenter defaultCenter]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        [UIView animateWithDuration:0.3 animations:^{
            _mobileImageV.superview.center = CGPointMake(_mobileImageV.superview.center.x, _mobileImageV.superview.center.y - 50);
        }];
    }
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        [UIView animateWithDuration:0.3 animations:^{
            _mobileImageV.superview.center = CGPointMake(_mobileImageV.superview.center.x, _mobileImageV.superview.center.y + 50);
        }];
    }

    
    // keyboardWasShown = NO;
    
}


@end
