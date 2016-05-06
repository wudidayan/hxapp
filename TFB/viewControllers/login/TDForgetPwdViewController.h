//
//  TDForgetPwdViewController.h
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
typedef NS_ENUM(NSInteger, PwdCodeType)
{
    kForGetLogInPwd = 0,
    kForGetPayPwd,
    kModifyLoginPwd,
    kModifyPayPwd
};


@interface TDForgetPwdViewController : TDBaseViewController

//根据 isNeedOldPwd  来判断是否需要隐藏
@property (strong, nonatomic) IBOutlet UIView *oldPwdBgView;
@property (strong, nonatomic) IBOutlet UIImageView *oldPwdImageV;
@property (strong, nonatomic) IBOutlet UITextField *oldLoginPwdText;

@property (strong, nonatomic) IBOutlet UIView *nPwdBgView;
@property (strong, nonatomic) IBOutlet UITextField *nLginPwdText;
@property (strong, nonatomic) IBOutlet UITextField *conNLoginPwdText;
@property (strong, nonatomic) IBOutlet UIImageView *nPwdImageV;
@property (strong, nonatomic) IBOutlet UIImageView *conNPwdImageV;

- (IBAction)clickButton:(UIButton *)sender;

@property (nonatomic,assign) PwdCodeType pwdType;

@property (nonatomic, strong) NSString *custMobile;
/**
 *  如果是根据原密码修改，该值为原密码，如果根据验证码，该值为验证码
 */
@property (nonatomic, strong) NSString *value;
@end
