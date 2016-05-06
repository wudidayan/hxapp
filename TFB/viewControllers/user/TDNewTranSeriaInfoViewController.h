//
//  TDNewTranSeriaInfoViewController.h
//  TFB
//
//  Created by Nothing on 15/10/31.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDTranSerial.h"

@interface TDNewTranSeriaInfoViewController : TDBaseViewController

@property (nonatomic,strong) TDTranSerial * tranSerial;
//@property (weak, nonatomic) IBOutlet UIWebView *infoWebview;
@property (strong, nonatomic) UIWebView *infoWebview;

@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (strong,nonatomic) NSString * only;
@property (strong,nonatomic) NSString * proNum;
@property (assign,nonatomic) BOOL isPhoto;
@end
