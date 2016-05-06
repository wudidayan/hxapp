//
//  TDBankListViewController.h
//  TFB
//
//  Created by YangTao on 15/12/29.
//  Copyright © 2015年 TD. All rights reserved.
//选择银行的控制器

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *showText);
@interface TDBankListViewController : UIViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@property (assign, nonatomic) NSString *bankNameButton;
@property (nonatomic,strong) NSMutableArray * bankArr;


@end
