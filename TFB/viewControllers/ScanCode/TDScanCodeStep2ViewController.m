#import "ZSYPopoverListView.h"
#import "TDScanCodeStep2ViewController.h"
#import "TDScanCodeResultViewController.h"

@interface TDScanCodeStep2ViewController () {
    NSTimer *_myTimer;
    int _timerCount;
}
@end

@implementation TDScanCodeStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"扫码收款";
    self.txnAmtVal.text = [NSString stringWithFormat:@"扫一扫上面的二维码，给我付款 %@ 元", _scanCodeContext.txnAmt];
    [self GenQrcode: self.scanCodeContext.payData];
    self.payStatus.text = @"等待扫码...";
    _myTimer =  [NSTimer scheduledTimerWithTimeInterval: 5.0 target:self selector:@selector(getPayResult) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [_myTimer invalidate];
    _myTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)scanBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self.view makeToast:@"暂不支持" duration:2.0f position:@"center"];
}

- (void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickbackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

-(void)GenQrcode: (NSString *)dataString {
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    // 5.显示二维码
    self.qrcodeImgView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:180];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)getPayResult {
    _timerCount++;
    NSLog(@"getPayResult timer, count %d", _timerCount);
    
    if(_timerCount < 3) {
        return; // 给用户支付预留一定时间，前2次不去查询
    }
        
    // 查询扫码支付结果
    self.payStatus.text = @"...";
    _scanCodeContext.payResult = @"U";
    [TDHttpEngine requestForScanCodeResult:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordNo:_scanCodeContext.prdordNo complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic) {
        
        if (succeed) {
            _scanCodeContext.payResult = [infoDic objectForKey:@"payResult"];
            
            if([_scanCodeContext.payResult isEqualToString:@"U"]) {
                self.payStatus.text = @"-.-";
                return;
            }
            
            TDScanCodeResultViewController *resultController = [[TDScanCodeResultViewController alloc]init];
            resultController.resultState = self.scanCodeContext.payResultMsg;
            
            if([self.scanCodeContext.payResult isEqualToString:@"S"]) {
                resultController.isSuccess = TRUE;
                if(resultController.resultState.length == 0) {
                    resultController.resultState = [NSString stringWithFormat:@"成功收款 %@ 元", self.scanCodeContext.txnAmt];
                }
            } else {
                resultController.isSuccess = FALSE;
                if(resultController.resultState.length == 0) {
                    resultController.resultState = @"交易失败";
                }
            }
            
            resultController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resultController animated:YES];
        } else {
            self.payStatus.text = @"+.+";
        }
        
    }];
}

@end
