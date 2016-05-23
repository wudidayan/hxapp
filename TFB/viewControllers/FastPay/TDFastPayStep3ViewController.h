//
//  TDFastPayStep2ViewController.h
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"
#import "TDFastPay.h"

@interface TDFastPayStep3ViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txnAmt;
@property (weak, nonatomic) IBOutlet UITextField *mobileCode;
@property (weak, nonatomic) IBOutlet UITextField *cardNo;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *getMobileCode;

- (IBAction)commitBtnClick:(id)sender;
- (IBAction)getMobileCodeClick:(id)sender;

@property (nonatomic,strong) TDFastPay *fastPayContext;

@end
