//
//  TDAboutMineViewController.m
//  TFB
//
//  Created by Nothing on 15/3/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDAboutMineViewController.h"
#import "TDAgreementViewController.h"

@interface TDAboutMineViewController ()

@end

@implementation TDAboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)agreementBtnClick:(id)sender {
    TDAgreementViewController *agreementVC = [[TDAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}
@end
