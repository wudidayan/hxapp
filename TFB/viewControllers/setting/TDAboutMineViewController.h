//
//  TDAboutMineViewController.h
//  TFB
//
//  Created by Nothing on 15/3/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDAboutMineViewController : TDBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *verLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVerDesc;
@property (weak, nonatomic) IBOutlet UILabel *servicePhone;
- (IBAction)agreementBtnClick:(id)sender;

@end
