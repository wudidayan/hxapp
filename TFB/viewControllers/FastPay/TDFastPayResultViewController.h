//
//  TDFastPayResultViewController.h
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDFastPayResultViewController : TDBaseViewController

@property (nonatomic, strong) NSString *resultState;
@property (nonatomic, assign) BOOL isSuccess;

@property (weak, nonatomic) IBOutlet UIImageView *statesImageView;
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;
- (IBAction)commitBtnClick:(UIButton *)sender;

@end
