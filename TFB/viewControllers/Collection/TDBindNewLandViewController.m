//
//  TDBindNewLandViewController.m
//  TFB
//
//  Created by Nothing on 15/7/6.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBindNewLandViewController.h"
#define CString(s, ... ) [NSString stringWithFormat:s, ##__VA_ARGS__]
/**
 * 主密钥索引
 */
#define NL_DEFAULT_MK_INDEX 1
/**
 * 默认PIN加密工作密钥索引
 */
#define NL_DEFAULT_PIN_WK_INDEX 2
/**
 * 默认MAC加密工作密钥索引
 */
#define NL_DEFAULT_MAC_WK_INDEX 3
/**
 * 默认磁道加密工作密钥索引
 */
#define NL_DEFAULT_TRACK_WK_INDEX 4

@interface TDBindNewLandViewController () <NLDeviceEventListener,NLAudioPortListener,NLEmvControllerListener>
{
    NSString *_KSN;
}
@end

@implementation TDBindNewLandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定刷卡器";
    
    [NLAudioPortHelper registerAudioPortListener:self];
    
    [self backButton];
    [self initAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addText:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(),^{
        self.stateLabel.text = string;
    });
}

- (void)initAudio {
    
    // 初始化驱动对象
    
    // 注册音频口监听
    
    if ([NLAudioPortHelper isDevicePresent]) {
        [NSThread detachNewThreadSelector:@selector(toConnect) toTarget:self withObject:nil];
    }
    else {
        self.stateLabel.text = @"未检测到音频设备，请插入";
    }
}

//音频口监听方法
- (void)onDevicePlugged
{
    NSLog(@"onDevicePlugged");
    if ([self respondsToSelector:@selector(addText:)]) {
        [self performSelectorInBackground:@selector(addText:) withObject:@"设备接入。"];
    }
    [NSThread detachNewThreadSelector:@selector(toConnect) toTarget:self withObject:nil];
}

- (void)onDeviceUnplugged
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TERMCSN]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TERMCSN];
    }
    
    NSLog(@"onDeviceUnplugged");
    //[self.device cancelCurrentExecute];
    [[TDAppDelegate sharedAppDelegate].device destroy];
    if ([self respondsToSelector:@selector(addText:)]) {
        [self performSelectorInBackground:@selector(addText:) withObject:@"设备拔出，断开连接。"];
    }
}

//重新连接
- (void)reConnectClick {
    if ([[TDAppDelegate sharedAppDelegate].device isAlive]) {
        
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"设备已经连接，请直接操作" delegate:nil
                         cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
    
    else {
        
        if ([self respondsToSelector:@selector(addText:)]) {
            [self performSelectorInBackground:@selector(addText:) withObject:@"重新连接······"];
        }
        [NSThread detachNewThreadSelector:@selector(toConnect) toTarget:self withObject:nil];
    }
}

//获取连接部分代码
-(void)toConnect
{
    NSLog(@"device--%@  \r driver---%@", self.device, self.driver);
    
    if ([[TDAppDelegate sharedAppDelegate].device isAlive]) {
        //self.stateLabel.text = @"设备已连接";
        //[self performSelectorInBackground:@selector(addText:) withObject:@"设备已连接"];
        [self addText:@"设备已连接"];
        NSString *ksn = [[NSUserDefaults standardUserDefaults] objectForKey:TERMCSN];
        self.deviNum.text = ksn;
        _KSN = ksn;
        //[self performSelector:@selector(loadWorkKeyWithCSN:) withObject:ksn afterDelay:1.f];
        [self performSelectorOnMainThread:@selector(loadWorkKeyWithCSN:) withObject:ksn waitUntilDone:NO];
    }
    else if (![[TDAppDelegate sharedAppDelegate].device isAlive]) {
        [self performSelectorInBackground:@selector(addText:) withObject:@"正在连接..."];
    
        // 音频连接参数
        id<NLDeviceConnParams> params = [[NLAudioPortV100ConnParams alloc] init];
        // 请求连接并获取ME11终端设备
        NSError *err = nil; // 驱动连接设备错误指针
        // 驱动连接ME11获取设备对象信息
        
        [TDAppDelegate sharedAppDelegate].device = [[TDAppDelegate sharedAppDelegate].driver connectWithConnParams:params closedListener:self launchListener:self error:&err];
        if (err || ![TDAppDelegate sharedAppDelegate].device) { // 获取失败
            [self performSelectorOnMainThread:@selector(onDeviceConnectFailed:) withObject:[NSString stringWithFormat:@"%@", err] waitUntilDone:NO];
        }
        else {
            NSLog(@"Audio device instance %@", self.device);
            [self performSelectorOnMainThread:@selector(onDevicecConnectSuccess) withObject:nil waitUntilDone:NO];
        }
    }
    
}


- (void)onDeviceConnectFailed:(NSString*)errMsg {
    
    [self reConnectClick];
}
- (void)onDevicecConnectSuccess {
    
    self.title = @"设备连接成功";
    if ([self respondsToSelector:@selector(addText:)]) {
        [self performSelector:@selector(addText:) withObject:@"设备连接成功!!!"];
    }
    id<NLDeviceInfo> me11Info = [[TDAppDelegate sharedAppDelegate].device me11DeviceInfo];
    //[self showMsgOnMainThread:CString(@"KSN:%@",[me11Info KSN])];
    NSString *csn = [me11Info CSN];
    if (csn.length < 14) {
        [self.view makeToast:@"不支持该型号，请更换设备" duration:2.f position:@"center"];
        return;
    }
    
    NSString *csnStr = [[me11Info CSN] substringToIndex:14];
    _KSN = csnStr;
    self.deviNum.text = csnStr;
    [[NSUserDefaults standardUserDefaults] setObject:csnStr forKey:TERMCSN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self regestDeviceWithKSN:csnStr];
    
}

- (void)loadWorkKeyWithCSN:(NSString *)csn {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForSignTDKWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:csn termType:@"02" complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic) {
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //[self.view makeToast:msg duration:2.f position:@"center"];
        [self addText:msg];
        if (succeed) {
            NSLog(@"info--%@", infoDic);
            NSString *tkey = [infoDic objectForKey:@"tkey"];
            NSString *tcv  = [infoDic objectForKey:@"tcv"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self initializeAudioDriverWithTDK:tkey checkValue:tcv];
            });
            
        }
        else {
            
            [self clickbackButton];
        }
    }];
    
}

//灌装秘钥、
- (void)initializeAudioDriverWithTDK:(NSString *)tdk checkValue:(NSString *)checkValue {
    
    NSLog(@"----------->>>>> initializeAudioDriver  <<<< ---------");
    
    NSError *err = nil;

    id<NLPinInput> pin = (id<NLPinInput>)[[TDAppDelegate sharedAppDelegate].device standardModuleWithModuleType:NLModuleTypeCommonPinInput];
    
    [pin loadWorkingKeyWithWorkingKeyType:NLWorkingKeyTypeMAC mainKeyIndex:NL_DEFAULT_MK_INDEX workingKeyIndex:NL_DEFAULT_TRACK_WK_INDEX data:[NLISOUtils hexStr2Data:@"F8473B3B2B7ACB02A57290BD81F51B38"] checkValue:[NLISOUtils hexStr2Data:@"7F462F64BFA30009"] error:&err];
    
    if (!err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"灌装成功");
            [self regestDeviceWithKSN:_KSN];
        });
    }
    else {
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([self respondsToSelector:@selector(addText:)]) {
            [self addText:[NSString stringWithFormat:@"%@, 请重试", [err description]]];
            //[self close];
            
        }
        return ;
    }
    
    NSLog(@"Audio device instance %@", [TDAppDelegate sharedAppDelegate].device);
}


- (void)regestDeviceWithKSN:(NSString *)ksn {
    NSLog(@"16ksn---%@", ksn);
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForBDZDWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:ksn complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.f position:@"center"];
        [self addText:msg];
        if (succeed) {
            [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
        }
        else{
            
        }
    }];
}

-(void)clickbackButton {
    
//    if ([self.device isAlive]) {
//        [self.device cancelCurrentExecute];
//        [self.device destroy];
//    }
    [NLAudioPortHelper unregisterAudioPortListener];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
