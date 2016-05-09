//
//  TDScanBankCardViewController.m
//  test
//
//  Created by YangTao on 16/2/29.
//  Copyright © 2016年 YangTao. All rights reserved.
//

#import "TDScanBankCardViewController.h"
#import "BankCardCameraViewController.h"
#import "TDPayViewController.h"
@interface TDScanBankCardViewController ()
{
    NSString *scanImage;
    NSString *imageStr;
    BOOL isWrite;
    NSString *_productNum;
}
@end

@implementation TDScanBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isWrite = NO;
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    self.cardNum.text = self.no;
    NSLog(@"%@",self.image);
    CGImageRef cgimage=self.image.CGImage;
    UIImage *image = [UIImage imageWithCGImage:cgimage scale:1 orientation:UIImageOrientationUp];
    self.scanCardImage.contentMode = UIViewContentModeScaleAspectFit;
    self.scanCardImage.image = image;
    
    self.cardNum.delegate = self;
    [self.cardNum setUserInteractionEnabled:NO];
    self.title = @"扫描银行卡";
    NSData *picData = UIImageJPEGRepresentation(self.image, 0.5);
    UIImage *smallImage = [UIImage imageWithData:picData];
    [self saveImage:smallImage WithName:@"scanImage.jpg"];
}

-(void)clickbackButton{
    
    
        [[TDControllerManager sharedInstance]createTabbarController];
    
    
    
}
- (IBAction)ScanAgain:(UIButton *)sender {
    BankCardCameraViewController *cameraView = [[BankCardCameraViewController alloc]init];
    cameraView.only = self.only;
    cameraView.prdordno = self.proNum;
    cameraView.payInfo = _payInfo;
    cameraView.nsUserID = SCAN_CARD_LIC; //授权码
    [self presentViewController:cameraView animated:YES completion:nil];
    
}

- (IBAction)CanEdit:(UIButton *)sender {
    isWrite = YES;
    [self.cardNum setUserInteractionEnabled:YES];
    self.cardNum.keyboardType = UIKeyboardAppearanceLight;
    [self.cardNum becomeFirstResponder];
}

- (IBAction)ConfirmPush:(id)sender {
    
    if (self.cardNum.text.length <= 0) {
        [self.view makeToast:@"请点击手工输入 输入卡号" duration:2.f position:@"center"];
        return ;
    }
    if (isWrite == YES) {
        
        NSUInteger phoneType = 0;
        phoneType = [self.cardNum.text validateCaseInsensitive:@"^([0-9]{16}|[0-9]{19})$"];
        if (0 == phoneType) {
            [self.view makeToast:@"卡号为16或19位数字" duration:2.f position:@"center"];
            return ;
        }

    }
    
    [self.view makeToast:@"确认上传前请核对银行卡信息" duration:2.f position:@"center"];
    NSLog(@"1%@",[TDUser defaultUser].custId);
    NSLog(@"2%@",[TDUser defaultUser].custLogin);
    NSLog(@"3%@",_payInfo.prdordNo);
    NSLog(@"4%@",_image);
    NSLog(@"5%@",self.cardNum.text);
    
    scanImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/scanImage.jpg"];
    
//    imageStr = [UIImageJPEGRepresentation(scanImage, 1.0) base64EncodedString];
    NSLog(@"%@",scanImage);
    NSLog(@"%@",_only);
    if ([_only isEqualToString:@"交易"]) {
        _productNum = _proNum;
    }else
    {
        _productNum = _payInfo.prdordNo;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForUpScanBankCardWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordNo:_productNum bankcard:scanImage cardnum:self.cardNum.text complete:^(BOOL succeed, NSString *msg, NSString *cod) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeed) {
            [self deleteBankCardImage];
            NSLog(@"1111111111111111%@",cod);
            [self.view makeToast:@"照片上传成功" duration:2.f position:@"center"];
            if ([self.only isEqualToString:@"交易"]) {
                
                [[TDControllerManager sharedInstance]createTabbarController];
            }else
            {
                TDPayViewController * payController = [[TDPayViewController alloc]init];
                payController.payInfo = _payInfo;
//                payController.scanCardNum = self.no;
                payController.finalCardNum = self.cardNum.text;
                payController.isWrite = isWrite;
                [self.navigationController pushViewController:payController animated:YES];
            }
           
        }else
        {
            [self.view makeToast:msg duration:2.f position:@"center"];
            
        }
}];
}
//保存图片到本地
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"路径---%@", paths);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *temPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
    NSString *fullPathToFile = [temPath stringByAppendingPathComponent:imageName];
    NSLog(@"picPath--%@", fullPathToFile);
    [imageData writeToFile:fullPathToFile atomically:NO];
}
//删除本地保存的图片
- (void)deleteBankCardImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL handheldImageIsHave = [fileManager fileExistsAtPath:scanImage];
    if (!handheldImageIsHave) {
        return;
    }
    else {
        [fileManager removeItemAtPath:scanImage error:nil];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.cardNum resignFirstResponder];
    
    return YES;
    
}
@end
