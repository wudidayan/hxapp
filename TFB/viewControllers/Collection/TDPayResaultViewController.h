//
//  TDPayResaultViewController.h
//  TFB
//
//  Created by Nothing on 15/8/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDPayResaultViewController : TDBaseViewController

@property (nonatomic, strong) NSString *resultState;
@property (nonatomic, assign) BOOL isSuccess;

@property (weak, nonatomic) IBOutlet UIImageView *statesImageView;
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;
- (IBAction)commitBtnClick:(UIButton *)sender;

@end
