//
//  TDTermMessageViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDTermMessageViewController.h"
#import "TDPayInfo.h"
@interface TDTermMessageViewController ()

@end

@implementation TDTermMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设备押金信息";
    [self backButton];
//    @property (nonatomic,strong) NSString * termPayAmt;
//    @property (nonatomic,strong) NSString * termTypeName;
//    @property (nonatomic,strong) NSString * termRecipient;
//    @property (nonatomic,strong) NSString * termPayFlag;
    self.payAmtLabel.text = self.term.termPayAmt;
    self.payNameLabel.text = self.term.termRecipient;
    self.payTypeLabel.text = self.term.termTypeName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickButton:(UIButton *)sender {
    
    TDPayInfo * payInfo = [[TDPayInfo alloc]init];
    payInfo.payAmt = self.term.termPayAmt;
//    TDSwipeCardViewController * swipe = [[TDSwipeCardViewController alloc]init];
//    swipe.payTYPE  = kPayTerm;
//    swipe.payInfo = payInfo;
//    [self.navigationController pushViewController:swipe animated:YES];
}
@end
