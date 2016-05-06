//
//  TDAgreementViewController.m
//  TFB
//
//  Created by Nothing on 15/3/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDAgreementViewController.h"

@interface TDAgreementViewController ()

@end

@implementation TDAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户服务协议";
//    [self requestAgreement];
    [self backButton];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *path = @"http://103.47.137.53:8899/pay/test/agreement.html";
    NSURL *url = [[NSURL alloc] initWithString:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"messageText" ofType:@"txt"];
//    NSString * pathString = [NSString stringWithContentsOfFile:path encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
//    if (Empty_Str(pathString)) {
//        pathString = [NSString stringWithContentsOfFile:path encoding:4 error:nil];
//    }
//    
//    UIScrollView * SC  = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:SC];
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SC.bounds.size.width, 0)];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    label.backgroundColor = [UIColor clearColor];
//    label.text = pathString;
//    label.textColor = [UIColor grayColor];
//    label.font = [UIFont systemFontOfSize:13.0f];
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.numberOfLines = 0;
//    [label sizeToFit];
//    
//    
//    [SC addSubview:label];
//    SC.contentSize = CGSizeMake(0, label.bounds.size.height+64);
    
}

-(void)requestAgreement
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForgetAgreementWithCustId:@"" custMobile:@"" complete:^(BOOL succeed, NSString *msg, NSString *cod, NSString *urlPath) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"请求%@",urlPath);
        
    }];
   
    
}
@end
