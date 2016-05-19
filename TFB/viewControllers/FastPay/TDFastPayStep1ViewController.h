//
//  TDFastPayStep1ViewController.h
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"

@interface TDFastPayStep1ViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) IBOutlet UIButton *bankNameButtom;

- (IBAction)commitBtnClick:(id)sender;
- (IBAction)clickBankButton:(UIButton *)sender;

@end
