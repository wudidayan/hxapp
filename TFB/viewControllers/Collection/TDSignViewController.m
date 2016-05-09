//
//  TDSignViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/11.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDSignViewController.h"
#import "TDPayViewController.h"
#import "TDControllerManager.h"
#import "BankCardCameraViewController.h"

@interface TDSignViewController ()
{
    NSString *_signImage;
}
@end

@implementation TDSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     [self backButton];
    // Do any additional setup after loading the view from its nib.

    self.title = @"电子签名";

    [self.drawView setBackgroundColor:[UIColor whiteColor]];
    _drawView = [[MyView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _drawView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_drawView];
    [self.drawView setLineColor:3];
    [self.drawView setlineWidth:0];
    self.navigationController.navigationBar.hidden = YES;
    
//    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton)];
//     UIBarButtonItem * CancelButton = [[UIBarButtonItem alloc]initWithTitle:@"撤销" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelButton)];
//    self.navigationItem.rightBarButtonItems = @[rightButton,CancelButton];
 
    self.only = @"支付";
    [self creatUI];
}
-(void)creatUI{
 
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, self.view.bounds.size.height)];
    bgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bgView];
    
    UILabel * tittle  = [[UILabel alloc]init];
    [bgView addSubview:tittle];
    tittle.text = @"电子签名";
    tittle.font = [UIFont systemFontOfSize:17.0f];
    tittle.textColor = [UIColor whiteColor];
    [tittle sizeToFit];
    tittle.center =  CGPointMake(bgView.bounds.size.width/2, bgView.bounds.size.height/2);
    tittle.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.tag = i + 100;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:1 << 6];
        [bgView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        button.transform = CGAffineTransformMakeRotation(M_PI*1.5);
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"back"] forState:0];
            button.frame = CGRectMake(0, self.view.bounds.size.height - 50, 40, 40);
        }else if (i == 1){
            [button setTitle:@"撤销" forState:0];
            button.frame = CGRectMake(0, 55, 50, 40);
        }else if (i == 2){
            [button setTitle:@"上传" forState:0];
            button.frame = CGRectMake(0, 5, 50, 40);
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBar.hidden = YES;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden: YES];
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
     self.navigationController.navigationBar.hidden = NO;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden: NO];
    }
}
-(void)clickButton:(UIButton *)sender{

    if (sender.tag == 100) {
        [self viewDidDisappear:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if (sender.tag == 101){
      
        [self clickCancelButton];
    }else if (sender.tag == 102){
        [self clickRightButton];
    }
      

}

-(void)clickCancelButton{

  
    [_drawView clear];

}
-(void)clickRightButton{
    
    [self saveScreen];
    _signImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/signImage.jpg"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_signImage]) {
        [self.view makeToast:@"请上传签名" duration:2.0f position:@"center"];
        return;
    }
    NSLog(@"%@",_signImage);
    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * payAmt = [NSString stringWithFormat:@"%.2f",_payInfo.payAmt.floatValue*100];
    [TDHttpEngine requestForPrdOrderWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordType:_payInfo.prdordType bizType:_payInfo.subPayType prdordAmt:payAmt prdName:@"刷卡头" price:payAmt complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic) {
        
        if (succeed) {
            _payInfo.prdordNo = [infoDic objectForKey:@"prdordNo"];
            
            /*
             if (![weakSelf saveScreen]) {
             [self.view makeToast:@"请先签名" duration:2.f position:@"center"];
             return ;
             }
             */
            [TDHttpEngine requestForupOrderSignWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin andPrdordNo:_payInfo.prdordNo andImageString:_signImage complete:^(BOOL succeed, NSString *msg, NSString *cod) {
                
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (succeed) {
                    [self deleteBankCardImage];
                    BankCardCameraViewController *cameraView = [[BankCardCameraViewController alloc]init];
                    cameraView.only = self.only;
                    cameraView.payInfo = _payInfo;
                    cameraView.nsUserID = SCAN_CARD_LIC; //授权码
                    [self presentViewController:cameraView animated:YES completion:nil];
                    
                }else{
                    [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
                }
                
            }];
            
        }else{
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
        }
        
    }];
}

- (NSString *)saveScreen {
    UIGraphicsBeginImageContext(self.drawView.bounds.size);
    [self.drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    CGSize imagesize = image.size;
    NSLog(@"%f %f",imagesize.height,imagesize.width);
    imagesize.height =50;
    imagesize.width =50;
    [self saveImage:image WithName:@"signImage.jpg"];
    NSLog(@"%@",[UIImageJPEGRepresentation(image, 1.0) base64EncodedString]);
    return [UIImageJPEGRepresentation(image, 1.0) base64EncodedString];
}

//保存签名图片到本地
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

//删除本地保存的签名图片
- (void)deleteBankCardImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL handheldImageIsHave = [fileManager fileExistsAtPath:_signImage];
    if (!handheldImageIsHave) {
        return;
    }
    else {
        [fileManager removeItemAtPath:_signImage error:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickbackButton{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

@end
