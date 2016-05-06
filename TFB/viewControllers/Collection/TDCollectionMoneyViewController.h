//
//  TDCollectionMoneyViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/28.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

typedef NS_ENUM(NSInteger, TDPayment)
{

    kPaymentT1,           //支付
    kPaymentT0            //在线支付
};


@interface TDCollectionMoneyViewController : TDBaseViewController<UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

- (IBAction)clickButton:(UIButton *)sender;
- (IBAction)clickNumberButton:(UIButton *)sender;

@property (nonatomic,assign) TDPayment payment; 
@end
