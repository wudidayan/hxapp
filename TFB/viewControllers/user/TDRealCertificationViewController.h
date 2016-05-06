//
//  TDRealCertificationViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDRealCertificationViewController : TDBaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *cardHandheldImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardFrontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardBackImageView;
- (IBAction)commit:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *commitButton;

@property (strong, nonatomic) IBOutlet UIButton *CerButton;
- (IBAction)ClickCerButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *custNameText;

//@property (strong, nonatomic) IBOutlet UIButton *AreaButton;
//- (IBAction)clickAreaButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *CerTextField;
//@property (strong, nonatomic) IBOutlet UITextField *EmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *PassTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *BGScrollView;
- (IBAction)ClickTap:(UITapGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *CerTypeImageV;
@property (strong, nonatomic) IBOutlet UIImageView *CerNameImageV;
//@property (strong, nonatomic) IBOutlet UIImageView *emailImageV;
//@property (strong, nonatomic) IBOutlet UIImageView *AreaImageV;
@property (strong, nonatomic) IBOutlet UIImageView *payImageV;

@end
