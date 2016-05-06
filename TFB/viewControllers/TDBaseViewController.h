//
//  TDBaseViewController.h
//  TFB
//
//  Created by Nothing on 15/4/10.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SSWIDTH  [[UIScreen mainScreen] bounds].size.width
#define SSHeight [[UIScreen mainScreen] bounds].size.height


@interface TDBaseViewController : UIViewController

-(void)backButton;

-(void)clickbackButton; // 方便重载

-(void)creatLayerWithView:(UIView *)view;

@end
