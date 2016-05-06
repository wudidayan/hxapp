//
//  TDzhihangViewController.h
//  TFB
//
//  Created by YangTao on 15/12/29.
//  Copyright © 2015年 TD. All rights reserved.
//选择支行的控制器

#import <UIKit/UIKit.h>

typedef void (^ReturnZhihangBlock)(NSString *subBranch,NSString *cnapsCode);
@interface TDzhihangViewController : UIViewController

@property (nonatomic, copy) ReturnZhihangBlock returnZhihangBlock;

- (void)returnZhihang:(ReturnZhihangBlock)block;
@property (nonatomic,strong) NSString * subBranch;
@property (nonatomic,strong) NSString * cnapsCode;
@property (assign, nonatomic) NSString *zhiHangName;
@property (nonatomic, strong) NSMutableArray * bankNameListArr;
@end
