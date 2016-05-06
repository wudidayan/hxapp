//
//  BankCardCameraViewController.m
//
//  Created by etop on 15/10/22.
//  Copyright (c) 2015年 etop. All rights reserved.
//

#import "BankCardCameraViewController.h"
#import "TopView.h"
#import "SBankCard.h"
#import "TDTakePictureViewController.h"
#import "TDScanBankCardViewController.h"


//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAutoSizeScale ([UIScreen mainScreen].bounds.size.height/568.0)

@interface BankCardCameraViewController ()<UIAlertViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    UIView* m_highlitView[100];
    CGAffineTransform m_transform[100];
    
    TopView *_topView;
    BOOL _on;
    BOOL _isRecoged;
    BOOL _isAlertShow;
    SBankCard *_bankCard;
    BOOL _capture;
    NSTimer *_timer;
    

}
@property (assign, nonatomic) BOOL adjustingFocus;
@property (nonatomic, retain) CALayer *customLayer;
@property (nonatomic,assign) BOOL isProcessingImage;
@end

@implementation BankCardCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    //初始化识别核心
    [self performSelectorInBackground:@selector(initRecog) withObject:nil];
    
    //初始化相机
    [self initialize];
    
    //创建相机界面控件
    [self createCameraView];
    
    [self performSelector:@selector(scanTimer) withObject:nil afterDelay:30.0f];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.adjustingFocus = YES;
    _capture = NO;
    [self performSelector:@selector(changeCapture) withObject:nil afterDelay:0.5];
    
    
    //定时器 开启连续对焦
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(fouceMode) userInfo:nil repeats:YES];
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    [_session startRunning];
    

    //初始化识别核心 代理对象返回初始化参数
    int init = [_bankCard initSBankCard:self.nsUserID nsReserve:@""];
    if ([self.delegate respondsToSelector:@selector(initBankCardWithResult:)]) {
        [self.delegate initBankCardWithResult:init];
    }
    if (init != 0) {
        if (_isAlertShow == NO) {
            [_session stopRunning];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [allLanguages objectAtIndex:0];
            if (![preferredLang isEqualToString:@"zh-Hans"]) {
                NSString *initStr = [NSString stringWithFormat:@"Error code:%d",init];
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Tips" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertV show];
            }else{
                NSString *initStr = [NSString stringWithFormat:@"初始化失败错误编码:%d",init];
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertV show];
            }
        }
    }
    
    UIButton *upBtn = (UIButton *)[self.view viewWithTag:1001];
    upBtn.hidden = NO;
    
    
    
}
-(void)scanTimer
{
    TDTakePictureViewController *takePicture = [[TDTakePictureViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:takePicture];
    takePicture.prdordno = self.prdordno;
    takePicture.payInfo = _payInfo;
    takePicture.only = self.only;
    [self presentViewController:nav animated:YES completion:nil];
}




- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //关闭定时器
    [_timer invalidate];
    _timer = nil;
    
    _capture = NO;
   [_bankCard freeSBankCard];
    
    
   
    
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    [_session stopRunning];
    
    UIButton *photoBtn = (UIButton *)[self.view viewWithTag:1000];
    photoBtn.hidden = YES;
//    [self deleteBankCardImage];

}

- (void) changeCapture
{
    _capture = YES;
}

//初始化识别核心
- (void) initRecog
{
    _bankCard = [[SBankCard alloc] init];
    
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        self.adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
//        NSLog(@"Is adjusting focus? %@", self.adjustingFocus ?@"YES":@"NO");
    }
}

//初始化
- (void) initialize
{
    //判断摄像头授权
    _isAlertShow = NO;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [allLanguages objectAtIndex:0];
        if (![preferredLang isEqualToString:@"zh-Hans"]) {
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"Please allow to access your device’s camera in “Settings”-“Privacy”-“Camera”" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
        }else{
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在iOS '设置中-隐私-相机' 中打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alt show];
        }
        _isAlertShow = YES;
        return;
    }
    
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    
    //2.创建、配置输入设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == AVCaptureDevicePositionBack){
            _device = device;
            _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    [_session addInput:_captureInput];
    
    ///out put
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    //    dispatch_release(queue);
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [_session addOutput:captureOutput];
    
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    [_session addOutput:_captureOutput];
    //
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_preview];
    [_session startRunning];
    
    //设置覆盖层
    CAShapeLayer *maskWithHole = [CAShapeLayer layer];
    
    // Both frames are defined in the same coordinate system
    CGRect biggerRect = self.view.bounds;
    CGFloat offset = 1.0f;
    if ([[UIScreen mainScreen] scale] >= 2) {
        offset = 0.5;
    }
    
    //设置检测视图层
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:self.view.bounds];
    }
    CGRect smallFrame = _topView.smallrect;
    CGRect smallerRect = CGRectInset(smallFrame, -offset, -offset) ;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
    [maskPath moveToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMaxY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(smallerRect), CGRectGetMinY(smallerRect))];
    [maskWithHole setPath:[maskPath CGPath]];
    [maskWithHole setFillRule:kCAFillRuleEvenOdd];
    [maskWithHole setFillColor:[[UIColor colorWithWhite:0 alpha:0.35] CGColor]];
    [self.view.layer addSublayer:maskWithHole];
    [self.view.layer setMasksToBounds:YES];
    
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    //设置检测范围
    [_bankCard setRegionWithLeft:225 Top:100 Right:1025 Bottom:618];//图像分辨率1280*720
    
}

//从摄像头缓冲区获取图像
#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    unsigned char *pWarpLine = new unsigned char[400*70*4];
    
    self.nsNo = @"";
    self.resultImg = image;
    NSLog(@"%@",image);
    if (_capture == YES) {
        if (!self.adjustingFocus) {
            int bSuccess = [_bankCard recognizeSBankCard:baseAddress Width:(int)width Height:(int)height];
           if(bSuccess == 0)
            {
                //设置识别状态为YES
                _isRecoged = YES;
                //设置震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    
                [self performSelectorOnMainThread:@selector(readyToGetImage:) withObject:self.resultImg waitUntilDone:YES];
                
                _capture = NO;
                TDScanBankCardViewController *scan = [[TDScanBankCardViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:scan];
                scan.proNum = self.prdordno;
                scan.payInfo = _payInfo;
                scan.no = _bankCard.nsNo;
                scan.image = image;
                scan.only = self.only;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:nav animated:YES completion:nil];
                });
                
            }
        }
    }
    delete[] pWarpLine;
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}
//识别成功
-(void)readyToGetImage:(UIImage *)image
{
    [_topView.resultImg setImage:image];
    _topView.promptLabel.text = @"";
    _topView.promptLabel1.text = @"点击屏幕继续识别";
    _topView.label.text = _bankCard.nsNo;
    if (self.resultImg) {
        self.resultImg = nil;
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

- (void)createCameraView{
    
    //设置检边视图层
    if (!_topView) {
        _topView = [[TopView alloc] initWithFrame:self.view.bounds];
        //_topView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_topView];
    }

    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                               action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [self.view addGestureRecognizer:singleFingerOne];
//    [singleFingerOne release];
    
    _topView.promptLabel = [[UILabel alloc] initWithFrame:CGRectMakeImage(-17, 247, 355, 60)];
    _topView.promptLabel.text = @"请将银行卡置于框内";
    _topView.promptLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _topView.promptLabel.textColor = [UIColor greenColor];
    _topView.promptLabel.textAlignment = NSTextAlignmentCenter;
    _topView.promptLabel.transform = CGAffineTransformMakeRotation(3.14/2);
    [self.view addSubview:_topView.promptLabel];
    
    _topView.promptLabel1 = [[UILabel alloc] initWithFrame:CGRectMakeImage(83, 247, 355, 60)];
    _topView.promptLabel1.text = @"";
    _topView.promptLabel1.font = [UIFont fontWithName:@"Helvetica" size:15];
    _topView.promptLabel1.textColor = [UIColor greenColor];
    _topView.promptLabel1.textAlignment = NSTextAlignmentCenter;
    _topView.promptLabel1.transform = CGAffineTransformMakeRotation(3.14/2);
    [self.view addSubview:_topView.promptLabel1];
    
    _topView.label = [[UILabel alloc] initWithFrame:CGRectMakeImage(-42, 247, 355, 60)];
    _topView.label.text = @"";
    _topView.label.font = [UIFont fontWithName:@"Helvetica" size:32];
    _topView.label.textColor = [UIColor greenColor];
    _topView.label.textAlignment = NSTextAlignmentCenter;
    _topView.label.transform = CGAffineTransformMakeRotation(3.14/2);
    [self.view addSubview:_topView.label];
    
    _topView.resultImg = [[UIImageView alloc] initWithFrame:CGRectMakeImage(-102, 247, 355, 360)];
    [_topView.resultImg setImage:nil];
    _topView.resultImg.transform = CGAffineTransformMakeRotation(3.14/2);
    [self.view addSubview:_topView.resultImg];
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTapsRequired == 1) {
        //单指单击
        _capture = YES;
        self.nsNo = @"";
        _topView.label.text = @"";
        _topView.promptLabel1.text = @"";
        _topView.promptLabel.text = @"请将银行卡置于框内";
        [_topView.resultImg setImage:nil];
        }
}

//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

//对焦
- (void)fouceMode{

    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    //    NSLog(@"%d",_count);
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [_preview captureDevicePointOfInterestForPoint:self.view.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            //NSLog(@"Error: %@", error);
        }
    }
}

#pragma mark - 内联函数适配屏幕

CG_INLINE CGRect
CGRectMakeImage(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    
    if (kScreenHeight==480) {
        rect.origin.y = y-20;
        rect.origin.x = x;
        rect.size.width = width;
        rect.size.height = height;
    }else{
        rect.origin.x = x * kAutoSizeScale;
        rect.origin.y = y * kAutoSizeScale;
        rect.size.width = width * kAutoSizeScale;
        rect.size.height = height * kAutoSizeScale;
        
    }
    return rect;
}





@end
