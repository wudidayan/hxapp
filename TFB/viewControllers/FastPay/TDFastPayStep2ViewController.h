//
//  TDFastPayStep2ViewController.h
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"
#import "TDFastPay.h"

@interface TDFastPayStep2ViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNo;
@property (weak, nonatomic) IBOutlet UITextField *cardExpireDate;
@property (weak, nonatomic) IBOutlet UITextField *cardCvv;
@property (weak, nonatomic) IBOutlet UITextField *mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *idNo;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

- (IBAction)commitBtnClick:(id)sender;

@property (nonatomic,strong) TDFastPay *fastPayContext;

@end
