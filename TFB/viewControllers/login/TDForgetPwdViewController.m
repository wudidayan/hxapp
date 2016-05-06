//
//  TDForgetPwdViewController.m
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDForgetPwdViewController.h"
#import "TDLoginViewController.h"
#import "NSString+MD5.h"

@interface TDForgetPwdViewController ()

@end

@implementation TDForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self backButton];
    [self creatLayerWithView:_nPwdBgView.superview];
    if (kForGetLogInPwd == _pwdType) {
        _oldPwdBgView.hidden = YES;
        self.title = @"忘记登录密码";
    }else if (kForGetPayPwd == _pwdType){
        _oldPwdBgView.hidden = YES;
        self.title = @"忘记支付密码";
    }else if (kModifyLoginPwd == _pwdType){
        self.title = @"修改登录密码";
    }else if (kModifyPayPwd == _pwdType){
        self.title = @"修改支付密码";
    }
    if (_oldPwdBgView.hidden) {
        _nPwdBgView.center = CGPointMake(_nPwdBgView.center.x, _nPwdBgView.center.y-_oldPwdBgView.bounds.size.height);
        _nPwdBgView.superview.frame = CGRectMake(_nPwdBgView.superview.frame.origin.x,
                                                 _nPwdBgView.superview.frame.origin.y,
                                                 _nPwdBgView.superview.frame.size.width,
                                                 _nPwdBgView.superview.frame.size.height - _oldPwdBgView.bounds.size.height);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton:(UIButton *)sender {
    
    NSString *oldPwd = [self.oldLoginPwdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *nPwd = [self.nLginPwdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *aGainPwd = [self.conNLoginPwdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (NO == _oldPwdBgView.hidden && Empty_Str(oldPwd)) {
        
        [self.view makeToast:@"请输入原密码" duration:2.0f position:@"center"];
        return;
    }
    
    
    if ( NO ==  _oldPwdBgView.hidden && NO == [NSString checkPasswordLength:oldPwd]) {
        [self.view makeToast:@"密码长度为6-20位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }
//    if (![oldPwd validateCaseInsensitive:PASSWORD_KEY]) {
//        [self.view makeToast:@"密码过于简单" duration:2.0f position:@"center"];
//        return;
//    }
    
    if (Empty_Str(_nLginPwdText.text)) {
        [self.view makeToast:@"请输入新密码" duration:2.0f position:@"center"];
        return;
    }
    if ( NO ==  _oldPwdBgView.hidden && NO == [NSString checkPasswordLength:nPwd]) {
        [self.view makeToast:@"密码长度为6-20位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }

    
    if(Empty_Str(_conNLoginPwdText.text)){
        [self.view makeToast:@"请确认新密码" duration:2.0f position:@"center"];
        return;
    }
    
    if(_oldPwdBgView.hidden && [oldPwd isEqualToString:nPwd]){
        
        [self.view makeToast:@"原密码与新密码一致" duration:2.0f position:@"center"];
        return;
    }
    
    if (![nPwd isEqualToString:aGainPwd]) {
        
        [self.view makeToast:@"两次输入不一致" duration:2.0f position:@"center"];
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    *  @param pwdType    修改的密码类型	N		密码类型：1-登录密码；2-支付密码
    //    *  @param updateType 修改方式	N		1：根据原密码修改；2：根据短信验证码找回
    
    NSString *pwdType = @"";
    if (kForGetPayPwd == _pwdType || kModifyPayPwd == _pwdType) {
        pwdType = @"2";
    }else{
        pwdType = @"1";
    }
    
    
    NSString *veroroldpwd = @"";
    NSString *updataType = @"";
    if (kForGetPayPwd == _pwdType || kForGetPayPwd == _pwdType) {
        updataType = @"2";
        veroroldpwd = self.value;
    }else{
        veroroldpwd = [_oldLoginPwdText.text MD5];
        updataType = @"01";
    }
    
    
    if (!self.custMobile) {
        self.custMobile = [TDUser defaultUser].custLogin;
    }
    
    [TDHttpEngine requestForUpdatePwdWithPwdType:pwdType updateType:updataType value:veroroldpwd newPwd:_nLginPwdText.text custMobile:self.custMobile complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (succeed) {
            [self.view makeToast:msg duration:2.0f position:@"center"];
            if (kModifyLoginPwd == _pwdType){
            
                [[TDControllerManager sharedInstance] popToLogin];
            }else{
            
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@YES afterDelay:2.0f];
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
    _oldPwdImageV.highlighted = NO;
    _nPwdImageV.highlighted = NO;
    _conNPwdImageV.highlighted = NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _oldLoginPwdText) {
        _oldPwdImageV.highlighted = YES;
        _nPwdImageV.highlighted = NO;
        _conNPwdImageV.highlighted = NO;
    }else if (textField == _nLginPwdText){
        _oldPwdImageV.highlighted = NO;
        _nPwdImageV.highlighted = YES;
        _conNPwdImageV.highlighted = NO;
    }else if (textField == _conNLoginPwdText){
        _oldPwdImageV.highlighted = NO;
        _nPwdImageV.highlighted = NO;
        _conNPwdImageV.highlighted = YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _oldLoginPwdText) {
        [_nLginPwdText becomeFirstResponder];
    }else if (textField == _nLginPwdText){
        [_conNLoginPwdText becomeFirstResponder];
    }else if (textField == _conNLoginPwdText){
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
