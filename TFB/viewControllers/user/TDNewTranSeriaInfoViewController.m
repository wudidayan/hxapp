//
//  TDNewTranSeriaInfoViewController.m
//  TFB
//
//  Created by Nothing on 15/10/31.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDNewTranSeriaInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "BankCardCameraViewController.h"

@interface TDNewTranSeriaInfoViewController ()
{
    UIWebView* wwebView;
    
}


@end

@implementation TDNewTranSeriaInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收款详情";
    NSLog(@"%f",self.view.bounds.size.height);
    [self backButton];
    if (_isPhoto == YES) {
        UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"拍照" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    self.infoWebview = [[UIWebView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-50,[[UIScreen mainScreen] bounds].size.height)];
    self.infoWebview.scrollView.scrollEnabled = YES;
    self.infoWebview.scalesPageToFit = YES;
    self.infoWebview.userInteractionEnabled = YES;
    self.infoWebview.scrollView.showsVerticalScrollIndicator = NO;
    self.infoWebview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infoWebview];
    
    
    NSLog(@"width = %f",self.view.frame.size.width);
    NSLog(@"height = %f",self.view.frame.size.height);
    NSLog(@"%f",self.view.bounds.size.height);
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
    

    [self requestGetTranDetail];
    self.only = @"交易";
    self.infoWebview.superview.backgroundColor = [UIColor colorWithRed:243/255.0 green:238/255.0 blue:253/255.0 alpha:1.0];
    
    
    
}


-(void)requestGetTranDetail{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestGetTranDetailWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin busType:_tranSerial.ordtype bizType:@"" ordno:_tranSerial.ordno complete:^(BOOL succeed, NSString *msg, NSString *cod, id serialInfo) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (succeed) {
            TDTranDetailedSerial * deSer = (TDTranDetailedSerial *)serialInfo;
            NSString *imagePath = [NSString stringWithFormat:@"%@%@", HOST, deSer.fjpath];
            self.proNum = deSer.prdordno;
            NSURL *imageUrl = [NSURL URLWithString:imagePath];
            NSLog(@"%@",imageUrl);
            NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
            [self.infoWebview loadRequest:request];
            
        }else{
            
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
        }
    }];
    
    
}

-(void)clickRightButton
{
    BankCardCameraViewController *cameraView = [[BankCardCameraViewController alloc]init];
    cameraView.only = self.only;
    cameraView.prdordno = self.proNum;
    cameraView.nsUserID = SCAN_CARD_LIC; //授权码
    [self presentViewController:cameraView animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
