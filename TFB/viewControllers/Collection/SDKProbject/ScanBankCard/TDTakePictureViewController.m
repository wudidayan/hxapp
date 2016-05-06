//
//  TDTakePictureViewController.m
//  TFB
//
//  Created by YangTao on 16/3/25.
//  Copyright © 2016年 TD. All rights reserved.
//

#import "TDTakePictureViewController.h"
#import "TDScanBankCardViewController.h"
@interface TDTakePictureViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *scanImage;
}
@end

@implementation TDTakePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title = @"拍照";
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
        //        [self presentViewController:imagePicker animated:YES completion:nil];
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else{
        [self.view makeToast:@"该设备没有摄像头" duration:2.0f position:@"center"];
        return;
    }
    
}
-(void)clickbackButton{
    
    [[TDControllerManager sharedInstance]createTabbarController];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissModalViewControllerAnimated:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    NSLog(@"照片信息--%@", info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    [self saveImage:[self imageWithImage:image scaledToSize:CGSizeMake(1296, 968)] WithName:@"scanImage.jpg"];
    //    scanImage = [UIImage imageWithData:[NSData dataFromBase64String:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/scanImage.jpg"]]];
    
//        scanImage = [self imageWithImage:image scaledToSize:CGSizeMake(304, 150)];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
    scanImage = [[UIImage alloc] initWithData:imageData];
    
    TDScanBankCardViewController *scan = [[TDScanBankCardViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:scan];
    scan.proNum = self.prdordno;
    scan.payInfo = _payInfo;
    scan.no = @"";
    scan.image = scanImage;
    scan.only = self.only;
    [scan.cardNum becomeFirstResponder];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

//重新绘制图片的尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
    UIImage *needImage = [[UIImage alloc] initWithData:imageData];
    
    return needImage;
}
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
//删除保存的银行卡照片
- (void)deleteBankCardImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL frontImageIsHave = [fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/scanImage.jpg"]];
    if (!frontImageIsHave) {
        return;
    }
    else {
        [fileManager removeItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp/scanImage.jpg"] error:nil];
    }
    
    
}
@end
