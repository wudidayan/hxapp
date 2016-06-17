//
//  TDBindBankCardViewController.h
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDBankCardInfo.h"
#import "ZSYPopoverListView.h"
#import "TDBankListViewController.h"
#import "TDzhihangViewController.h"
typedef enum {
    kBandingBankCard,
    kModificationBankCard
} bankCardState;

@interface TDBindBankCardViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cardFrontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardBackImageView;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
//@property (weak, nonatomic) IBOutlet UITextField *lineNumTF;

- (IBAction)commitBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
//@property (strong, nonatomic) IBOutlet UIButton *zhiHangButton;
@property (strong, nonatomic) IBOutlet UIButton *bankNameButtom;
@property (weak, nonatomic) IBOutlet UIButton *subBankNameBtn;

@property (strong, nonatomic) IBOutlet UIButton *TRButton;
- (IBAction)clickTRButton:(UIButton *)sender;
- (IBAction)clickBankButton:(UIButton *)sender;
- (IBAction)clickZhihangButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *BGScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *bankNumImageV;
@property (strong, nonatomic) IBOutlet UIImageView *lineNumImageV;
@property (strong, nonatomic) IBOutlet UIImageView *AreaImageV;

@property (strong, nonatomic) IBOutlet UILabel *idNum;
@property (strong, nonatomic) IBOutlet UITextField *idNumText;
@property (strong, nonatomic) IBOutlet UIImageView *idNumView;


@property (nonatomic,assign) bankCardState  state;
@property (nonatomic, strong) TDBankCardInfo *bankCardInfo;
@property (nonatomic, strong) TDBankListViewController *bank;
@property (nonatomic, strong) TDzhihangViewController *bankList;

@end
