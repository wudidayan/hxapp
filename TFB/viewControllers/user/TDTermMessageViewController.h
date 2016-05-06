//
//  TDTermMessageViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDTerm.h"
@interface TDTermMessageViewController : TDBaseViewController
@property (nonatomic,strong) TDTerm * term;
@property (strong, nonatomic) IBOutlet UILabel *payNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *payAmtLabel;
- (IBAction)clickButton:(UIButton *)sender;

@end
