//
//  TDLoginViewController.h
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "MKNetworkKit.h"

@interface TDLoginViewController : TDBaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *tittleImageV;
@property (strong, nonatomic) IBOutlet UITextField *useMobileText;
@property (strong, nonatomic) IBOutlet UITextField *userPasswordText;
@property (strong, nonatomic) IBOutlet UIImageView *mobileImageV;
@property (strong, nonatomic) IBOutlet UIImageView *passwordImageV;
- (IBAction)clickBoxButton:(id)sender;

- (IBAction)clickRegistButton:(UIButton *)sender;
- (IBAction)clickForgetButton:(UIButton *)sender;

- (IBAction)clickLoginButton:(UIButton *)sender;


@end
