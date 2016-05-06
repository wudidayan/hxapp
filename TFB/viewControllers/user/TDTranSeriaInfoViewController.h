//
//  TDTranSeriaInfoViewController.h
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDTranSerial.h"
@interface TDTranSeriaInfoViewController : TDBaseViewController
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *orderNo;
@property (strong, nonatomic) IBOutlet UILabel *userNo;
@property (strong, nonatomic) IBOutlet UILabel *cardNo;
@property (strong, nonatomic) IBOutlet UILabel *orderTime;

@property (strong, nonatomic) IBOutlet UILabel *AmtNum;
@property (strong, nonatomic) IBOutlet UIImageView *userNameImageV;

@property (strong, nonatomic) IBOutlet UIScrollView *BGScrollView;
@property (nonatomic,strong) TDTranSerial * tranSerial;

@end
