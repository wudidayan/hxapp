//
//  TDBankInquiryViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"
@interface TDBankInquiryViewController : TDBaseViewController

@property (strong, nonatomic) IBOutlet UILabel *bankCardNumLabel;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@property (nonatomic, strong) TDPayInfo * payInfo;

- (IBAction)clickButton:(UIButton *)sender;
@end
