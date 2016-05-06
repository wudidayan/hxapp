//
//  TDVerificationCodeViewController.h
//  TFB
//
//  Created by Nothing on 15/3/25.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

typedef NS_ENUM(NSInteger, VerCodeType)
{
    VerRegist = 0,
    VerEditLoginPwd,
    VerEditPayPwd,
};


@interface TDVerificationCodeViewController : TDBaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *vercodeTF;
@property (strong, nonatomic) IBOutlet UIButton *YZMButton;
@property (strong, nonatomic) IBOutlet UIImageView *iphoneImageV;
@property (strong, nonatomic) IBOutlet UIImageView *YZMImageV;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;
- (IBAction)clickBoxButton:(UIButton *)sender;
- (IBAction)clickServiceButton:(UIButton *)sender;


- (IBAction)clickYZMButton:(UIButton *)sender;
- (IBAction)nextBtnClick:(id)sender;

@property (nonatomic, assign) VerCodeType verCodeType;
@property (nonatomic, strong) NSString *mobileNum;

@end
