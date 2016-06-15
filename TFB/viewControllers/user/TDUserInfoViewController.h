//
//  TDUserInfoViewController.h
//  TFB
//
//  Created by Nothing on 15/4/11.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDUserInfoViewController : TDBaseViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgViewBalance;
@property (strong, nonatomic) IBOutlet UILabel *userMoblie;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *BankName;
@property (strong, nonatomic) IBOutlet UILabel *BankCardNum;
@property (weak, nonatomic) IBOutlet UILabel *custId;
@property (weak, nonatomic) IBOutlet UILabel *scanCodeBalance;
@property (weak, nonatomic) IBOutlet UILabel *fastPayBalance;
@property (weak, nonatomic) IBOutlet UILabel *totalBalance;
- (IBAction)clickButton:(UIButton *)sender;

//@property (strong, nonatomic) IBOutlet UILabel *trialLabel;
//@property (strong, nonatomic) IBOutlet UILabel *tatolLabel;
//@property (strong, nonatomic) IBOutlet UILabel *AlreadyLabel;
//@property (strong, nonatomic) IBOutlet UILabel *notSetabel;
@property (strong, nonatomic) IBOutlet UILabel *checkDone;
@property (strong, nonatomic) IBOutlet UILabel *notCheck;
@property (strong, nonatomic) IBOutlet UILabel *checkFail;


@end
