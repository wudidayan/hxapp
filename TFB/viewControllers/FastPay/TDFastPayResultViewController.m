//
//  TDFastPayRsaultViewController.m
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "TDFastPayResultViewController.h"

@interface TDFastPayResultViewController ()

@end

@implementation TDFastPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付结果";
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatUI {
    
    self.navigationItem.hidesBackButton = YES;
    
    if (self.isSuccess) {
        self.statesImageView.image = [UIImage imageNamed:@"succes"];
    }
    else {
        self.statesImageView.image = [UIImage imageNamed:@"fail"];
    }
    
    self.statesLabel.text = self.resultState;
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    
    [[TDControllerManager sharedInstance]createTabbarController];
}
@end
