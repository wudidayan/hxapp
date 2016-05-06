//
//  TDSignViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/11.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "MyView.h" 
#import "TDPayInfo.h"
@interface TDSignViewController : TDBaseViewController

@property (nonatomic,strong) MyView * drawView;
@property (nonatomic,strong) TDPayInfo * payInfo;
@property (strong,nonatomic) NSString * only;
@end
