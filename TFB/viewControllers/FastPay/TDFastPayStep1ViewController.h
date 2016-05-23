//
//  TDFastPayStep1ViewController.h
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"
#import "TDFastPay.h"

@interface TDFastPayStep1ViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) IBOutlet UIButton *bankNameButtom;

- (IBAction)commitBtnClick:(id)sender;
- (IBAction)clickBankButton:(UIButton *)sender;

@property (nonatomic,strong) TDFastPay *fastPayContext;

@end
