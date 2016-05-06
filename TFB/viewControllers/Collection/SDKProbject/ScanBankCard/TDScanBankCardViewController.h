//
//  TDScanBankCardViewController.h
//  test
//
//  Created by YangTao on 16/2/29.
//  Copyright © 2016年 YangTao. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"

@interface TDScanBankCardViewController :TDBaseViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *scanCardImage;
@property (strong, nonatomic) IBOutlet UITextField *cardNum;
- (IBAction)ScanAgain:(UIButton *)sender;
- (IBAction)CanEdit:(UIButton *)sender;
- (IBAction)ConfirmPush:(id)sender;

@property (nonatomic,strong) TDPayInfo * payInfo;
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *only;
@property (nonatomic, strong) NSString *proNum;
@end
