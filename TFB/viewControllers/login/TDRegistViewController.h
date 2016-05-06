//
//  TDRegistViewController.h
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDRegistViewController : TDBaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *pwdImageV;
@property (strong, nonatomic) IBOutlet UIImageView *nPwdImageV;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *againLonginPwdTF;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkBtnClick:(id)sender;
- (IBAction)agreementBtnClick:(id)sender;
- (IBAction)commitBtnClick:(id)sender;

@property (nonatomic, strong) NSString *mobileNum;

@end
