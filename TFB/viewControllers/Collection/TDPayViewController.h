//
//  TDPayViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/11.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"
#import "TDNLBlueSwipeViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface TDPayViewController : TDBaseViewController<UIActionSheetDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) TDPayInfo * payInfo;
@property (nonatomic,strong) TDNLBlueSwipeViewController *NLBlue;

@property (strong, nonatomic) IBOutlet UILabel *BankCardNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *PayAmtLabel;

@property (strong, nonatomic) IBOutlet UITextField *BankPasswordText;
@property (strong, nonatomic) IBOutlet UIButton *typeButton;
- (IBAction)clickTypeButton:(UIButton *)sender;

- (IBAction)ClickPayButton:(UIButton *)sender;

//@property (strong,nonatomic) NSString * scanCardNum;

@property (strong,nonatomic) NSString * finalCardNum;

@property (strong,nonatomic) NSString * scanOrNot;

@property(nonatomic, assign) BOOL isWrite;
@end
