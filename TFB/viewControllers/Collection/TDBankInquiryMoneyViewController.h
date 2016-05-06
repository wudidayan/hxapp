//
//  TDBankInquiryMoneyViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/6.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"

@interface TDBankInquiryMoneyViewController : TDBaseViewController
@property (strong, nonatomic) IBOutlet UILabel *bankCardMumLabel;

@property (strong, nonatomic) IBOutlet UILabel *BankCardMoneyLabel;

@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * bankCardNum;
@property (nonatomic, strong) TDPayInfo *payInfo;

- (IBAction)clickButton:(UIButton *)sender;
@end
