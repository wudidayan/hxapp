//
//  TDTranSeriaInfoViewController.m
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDTranSeriaInfoViewController.h"
#import "TDUser.h"

@interface TDTranSeriaInfoViewController ()

@end

@implementation TDTranSeriaInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backButton];
    self.title = @"交易详情";
     self.automaticallyAdjustsScrollViewInsets = NO;

    _BGScrollView.contentSize = CGSizeMake(0, 590);
    _BGScrollView.bounces = NO;
    self.userName.text = [TDUser defaultUser].custName;
    self.orderNo.text =  @"- -";
//    self.userNo.text = _tranSerial.custId;
    self.orderTime.text = _tranSerial.ordtime;
//    self.cardNo.text = _tranSerial.PAY_CARDNO;
    self.AmtNum.text = _tranSerial.ordamt;
    [self requestGetTranDetail];
    
}

-(void)requestGetTranDetail{
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
   [TDHttpEngine requestGetTranDetailWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin busType:_tranSerial.ordtype bizType:@"" ordno:_tranSerial.ordno complete:^(BOOL succeed, NSString *msg, NSString *cod, id serialInfo) {
       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
       if (succeed) {
           TDTranDetailedSerial * deSer = (TDTranDetailedSerial *)serialInfo;
           self.userName.text = deSer.custName;
           self.orderNo.text =  _tranSerial.ordno;
            self.userNo.text = deSer.custId;
           self.orderTime.text = deSer.ordtime;
           self.cardNo.text = deSer.cardNoStar;
           self.AmtNum.text = deSer.ordamt;
           
       }else{
       
           [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
           [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
       }
   }];


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

@end
