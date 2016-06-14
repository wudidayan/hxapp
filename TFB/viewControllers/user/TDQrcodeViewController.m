#import "TDQrcodeViewController.h"

@interface TDQrcodeViewController ()

@end

@implementation TDQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要推荐";
    [self backButton];
    NSLog(@"custId: %@", [TDUser defaultUser].custId);
    NSString *qrcodeData = [NSString stringWithFormat:@"%@%@",HOST_APPLOGIN, [TDUser defaultUser].custId];
    NSLog(@"qrcodeData: %@", qrcodeData);
    [self GenQrcode: qrcodeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)clickbackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    self.statesImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:180];
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

@end
