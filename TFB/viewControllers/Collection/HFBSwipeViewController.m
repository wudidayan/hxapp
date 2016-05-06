//
//  HFBSwipeViewController.m
//  TFB
//
//  Created by Nothing on 15/8/5.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "HFBSwipeViewController.h"
#import "TDSignViewController.h"
#import "TDBankInquiryMoneyViewController.h"
#import "TDBankInquiryViewController.h"

#define STATUSONE @"01" //
#define STATUSTWO @"02" //

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


@interface HFBSwipeViewController () <NLDeviceEventListener,NLAudioPortListener,NLEmvControllerListener>
{
    UIBarButtonItem *_reConnectBtn;
    NSString *_ksn;
    
//    NSThread *_connectThread;
//    NSThread *_reconnectThread;
    
    BOOL _canConnect;
    
    NSDictionary *_cardInfoDic;
}
@end

@implementation HFBSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    
    if (HFBkNewLandPayment == _hfbNewLandPayType) {
        self.title = @"刷卡";
        _payInfo.subPayType = @"01";
        _payInfo.prdordType = @"01";
        _payInfo.ctype = @"01";
        
    }else if(HFBkNewLandBankInquiry == _hfbNewLandPayType){
        self.title = @"余额查询";
        _payInfo = [[TDPayInfo alloc]init];
        _payInfo.subPayType = @"01";
        _payInfo.prdordType = @"01";
        _payInfo.payAmt = @"00";
        self.payMoney = @"00";
        self.moneyLabel.text = @"余额查询不扣费";
    }else if (HFBkNewLandPayTerm == _hfbNewLandPayType){
        self.title = @"支付押金";
        _payInfo.subPayType = PAY_SUB_TYPE;
        _payInfo.prdordType = @"02";
        _payInfo.ctype = @"01";
    }else if(HFBkNewLandPaymentT == _hfbNewLandPayType){
        self.title = @"即时到帐";
        _payInfo.subPayType = @"01";
        _payInfo.prdordType = @"01";
        _payInfo.ctype = @"00";
        
    }
#ifdef  POSS_PAY_TYPE
    _payInfo.payType  = STATUSTWO;     /*   01  快捷支付  02 刷卡支付  */
    
#elif
    _payInfo.payType  = STATUSONE;
#endif
    
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    // 初始化驱动对象
//    self.driver = [[NLMESeriesDriver alloc] init];
    
    _canConnect = YES;
    // 注册音频口监听器
    [NLAudioPortHelper registerAudioPortListener:self];
    
    if ([NLAudioPortHelper isDevicePresent]) {
        
        if (_canConnect) {
            [NSThread detachNewThreadSelector:@selector(toConnect) toTarget:self withObject:nil];
        }
        
        
    }
    else {
        self.descriptionLabel.text = @"未检测到音频设备，请插入";
    }
}

- (void)unregis {
    [NLAudioPortHelper unregisterAudioPortListener];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatUI {
    [self backButton];
    self.moneyLabel.text = self.payMoney;
    
//    _reConnectBtn = [[UIBarButtonItem alloc] initWithTitle:@"重连设备" style:UIBarButtonItemStylePlain target:self action:@selector(reConnectClick)];
//    _reConnectBtn.enabled = NO;
//    self.navigationItem.rightBarButtonItem = _reConnectBtn;
}

-(void)addText:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(),^{
        self.descriptionLabel.text = string;
    });
}

//音频口监听方法
- (void)onDevicePlugged
{
    NSLog(@"onDevicePlugged");
    if ([self respondsToSelector:@selector(addText:)]) {
        [self performSelectorInBackground:@selector(addText:) withObject:@"设备接入。"];
    }
    
    if (_canConnect) {
        [NSThread detachNewThreadSelector:@selector(toConnect) toTarget:self withObject:nil];
    }
}

- (void)onDeviceUnplugged
{
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
        
        if (_canConnect) {
//            _reconnectThread = [[NSThread alloc] initWithTarget:self selector:@selector(toConnect) object:nil];
//            [_reconnectThread start];
            
            [NSThread detachNewThreadSelector:@selector(toConnect) toTarget:self withObject:nil];
        }
        
    }
}



- (BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}


//获取连接部分代码
-(void)toConnect
{
    NSLog(@"device--%@  \r driver---%@", self.device, self.driver);
    
    if ([[TDAppDelegate sharedAppDelegate].device isAlive]) {
        //self.descriptionLabel.text = @"设备已连接";
        [self addText:@"设备已连接"];
        NSString *ksn = [[NSUserDefaults standardUserDefaults] objectForKey:TERMCSN];
        [self checkTermIsBindWithKsn:ksn];
        //[self performSelector:@selector(checkTermIsBindWithKsn:) withObject:ksn afterDelay:1.f];
    }
    else if (![[TDAppDelegate sharedAppDelegate].device isAlive]) {
        [self performSelectorInBackground:@selector(addText:) withObject:@"正在连接..."];
//        [self performSelectorInBackground:@selector(addText:) withObject:@"设备未连接"];
        
        // 音频连接参数
        id<NLDeviceConnParams> params = [[NLAudioPortV100ConnParams alloc] init];
        // 请求连接并获取ME11终端设备
        NSError *err = nil; // 驱动连接设备错误指针
        // 驱动连接ME11获取设备对象信息
        
        [TDAppDelegate sharedAppDelegate].device = [[TDAppDelegate sharedAppDelegate].driver connectWithConnParams:params closedListener:self launchListener:self error:&err];
        
        //[TDAppDelegate sharedAppDelegate].device = [[TDAppDelegate sharedAppDelegate].driver connectWithConnParams:params closedListener:self error:&err];
        
        if (err || ![TDAppDelegate sharedAppDelegate].device) { // 获取失败
            [self performSelectorOnMainThread:@selector(onDeviceConnectFailed:) withObject:[NSString stringWithFormat:@"%@", err] waitUntilDone:NO];
        }
        else {
            NSLog(@"Audio device instance %@", [TDAppDelegate sharedAppDelegate].device );
            [self performSelectorOnMainThread:@selector(onDevicecConnectSuccess) withObject:nil waitUntilDone:NO];
        }
    }
    
}


- (void)onDeviceConnectFailed:(NSString*)errMsg
{
    
    NSLog(@"连接失败描述   ----%@", errMsg);

    [self reConnectClick];

}


- (void)onDevicecConnectSuccess {
    
    self.title = @"设备连接成功";
    if ([self respondsToSelector:@selector(addText:)]) {
        [self performSelector:@selector(addText:) withObject:@"设备连接成功!!!"];
    }
    id<NLDeviceInfo> me11Info = [[TDAppDelegate sharedAppDelegate].device me11DeviceInfo];
    //[self showMsgOnMainThread:CString(@"KSN:%@",[me11Info KSN])];
    NSLog(@"设备号： %@", [me11Info CSN]);
    NSString *csn = [me11Info CSN];
    if (csn.length < 14) {
        [self.view makeToast:@"不支持该型号，请更换设备" duration:2.f position:@"center"];
        return;
    }
    NSString *csnStr = [[me11Info CSN] substringToIndex:14];
    [self checkTermIsBindWithKsn:csnStr];
    //[self performSelector:@selector(checkTermIsBindWithKsn:) withObject:csnStr afterDelay:1.f];
    
    [[NSUserDefaults standardUserDefaults] setObject:csnStr forKey:TERMCSN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//检测设备是否绑定
- (void)checkTermIsBindWithKsn:(NSString *)ksn {
    //获取终端列表
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForGetTermListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (succeed) {
            if (!termArray.count) {
                [weakSelf.view makeToast:@"未绑定刷卡器,请前往绑定再进行交易" duration:2.0f position:@"center"];
                [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
            }else{
                _payInfo.termInfo = [termArray firstObject];
                _payInfo.termType = STATUSTWO;
                [self getCompateWirhKsn:ksn];
                //[self performSelector:@selector(getCompateWirhKsn:) withObject:ksn afterDelay:1.5f];
            }
        }else{
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
            [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
        }
    }];
}

//终端签到
-(void)getCompateWirhKsn:(NSString *)ksn {
    
    //在这里进行终端签到
    __weak typeof(self)weakSelf = self;
    //NSString *ksnStr = [ksn substringToIndex:14];
    [TDHttpEngine requestForGetMiYaoWithCustMobile:[TDUser defaultUser].custLogin termNo:ksn termType:_payInfo.termType custId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString * cod, TDPinKeyInfo *pinKey) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (succeed) {
            //判断是否是对应刷卡器
            if ([_payInfo.termInfo.termNo isEqualToString:ksn]) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self startReadCard];
                });
                
            }else{
                //[weakSelf performSelectorOnMainThread:@selector(threadSEL:) withObject:@"刷卡器不可用" waitUntilDone:NO];
                self.descriptionLabel.text = @"刷卡器不可用";
                [weakSelf.view makeToast:[NSString stringWithFormat:@"请使用 %@ 进行刷卡/插卡",_payInfo.termInfo.termNo] duration:2.0f position:@"center"];
                
            }
        }else{

            [weakSelf.view makeToast:msg duration:2.6f position:@"center"];
            [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
        }
    }];
}


////开始执行读卡
-(void)startReadCard
{
    if (![[TDAppDelegate sharedAppDelegate].device isAlive]) {
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"设备未连接，请选择并连接！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return ;
    }
    [self addText:@"正在等待刷卡/插卡......"];
    id<NLCardReader> cardReader = (id<NLCardReader>)[[TDAppDelegate sharedAppDelegate].device  standardModuleWithModuleType:NLModuleTypeCommonCardReader];
    // TODO
    int timeout = 20;
    
    NSDateFormatter *ft = [[NSDateFormatter alloc] init];
    [ft setDateFormat:@"yyMMddHHmmss"];
    NSData* time = [NLISOUtils hexStr2Data:[ft stringFromDate:[NSDate date]]];
    NLME11SwipeResult *rslt = [cardReader openCardReader:@[@(NLModuleTypeCommonSwiper), @(NLModuleTypeCommonICCard)] readModel:@[@(NLSwiperReadModelReadSecondTrack), @(NLSwiperReadModelReadThirdTrack)] panType:0xff encryptAlgorithm:[NLTrackEncryptAlgorithm BY_UNIONPAY_MODEL] wk:[[NLWorkingKey alloc] initWithIndex:0x04] time:time random:nil appendData:nil timeout:timeout];
    if (!rslt) {
        [self addText:@"读卡POS响应失败,请返回重试或重新插入刷卡器进行操作"];
        return ;
    }
    if (rslt.rsltType != NLSwipeResultTypeSuccess || rslt.moduleTypes <= 0) {
        if (rslt.rsltType == NLSwipeResultTypeReadTrackTimeout) {
            return ;
        }
        [self addText:@"刷卡或插卡失败,请返回重试或重新插入刷卡器进行操作"];
        return ;
    }
    
    NLModuleType moduleType = [rslt.moduleTypes[0] intValue];
    if (NLModuleTypeCommonICCard == moduleType) {
        // ME11 pboc
        [self addText:@"正在读取IC卡......"];
        id<NLEmvModule> emvModule = (id<NLEmvModule>)[[TDAppDelegate sharedAppDelegate].device  standardModuleWithModuleType:NLModuleTypeCommonEMV];
        id<NLEmvTransController> emvController = [emvModule emvTransControllerWithListener:self];
        [emvController startEmvWithAmount: [NSDecimalNumber decimalNumberWithString:self.payMoney] cashback:[NSDecimalNumber zero] forceOnline:YES];
        
    } else if (NLModuleTypeCommonSwiper == moduleType) {
        [self addText:@"正在读取磁条卡"];
        
        NSString *enc = [[NSString alloc] initWithData:rslt.secondTrackData encoding:NSUTF8StringEncoding];
        
        if (!enc || [enc isEqualToString:@""] || !rslt.acctId || [rslt.acctId isEqualToString:@""]) {
            [self addText:@"卡片信息不完整，请返回重试或重新插入刷卡器进行操作"];
            
            return;
        }
        
        
        [self getCardInfoWithDic:@{@"cardType":@"CT",
                                   @"encTrankSecond":enc,
                                   @"encTrackThrid":[self getMessageString:rslt.thirdTrackData],
                                   @"maskedPAN":rslt.acctId,
                                   @"KSN":rslt.ksn,
                                   @"nDate":rslt.validDate
                                   }];
        
        
    } else {
        [self addText:@"该读卡模式不支持,请返回重试"];
    }
}

-(NSString *)getMessageString:(NSData *)data{
    
    NSString * string = [NSString stringWithFormat:@"%@",data];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string substringWithRange:NSMakeRange(1, string.length -2)];
    
    return string;
}


- (void)onRequestOnline:(id<NLEmvTransController>)controller context:(NLEmvTransInfo*)context error:(NSError*)err
{
    NSLog(@"=======>> onRequestOnline <<=====");
    
    NSLog(@"%@:%@", context, err);
    NSMutableString * show = [NSMutableString string];
    [show appendString:[NSString stringWithFormat:@"pboc读卡%@", err == nil ? @"成功!" : @"失败！"]];
    
    if (!err) {
        
        id<TLVPackage> tlvPackage = [context setExternalInfoPackageWithTags:@[@0x9F26, @0x9F27, @0x9F10, @0x9F37, @0x9F36,
                                                                              @0x95, @0x9A, @0x9C, @0x9F02, @0x5F2a, @0x82,
                                                                              @0x9F1A, @0x9F03, @0x9F33, @0x9F34, @0x9F35,
                                                                              @0x9F1E, @0x84, @0x9F09, @0x9F41, @0x9F63]];
        
        NSData *data = [self readICCardEncryptTrackData:0x04 encryptAlgorithm:[NLTrackEncryptAlgorithm BY_UNIONPAY_MODEL]];
        NSString *erciStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString * track2 = nil;
        
        if(context.track_2_eqv_data == nil){
            track2 = [NLISOUtils hexStringWithData:context.track_2_eqv_data];
        }else{
            NSString * sourceString = [NSString stringWithFormat:@"%@",context.track_2_eqv_data];
            
            track2 = [sourceString substringWithRange:NSMakeRange(1, sourceString.length - 2)];
            
            track2 = [track2 stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        if (![NLISOUtils hexStringWithData:[tlvPackage pack]] || [[NLISOUtils hexStringWithData:[tlvPackage pack]] isEqualToString:@""] || ![context cardNo] || [[context cardNo] isEqualToString:@""] || !erciStr || [erciStr isEqualToString:@""]) {
            
            [self addText:@"卡片信息不完整，请返回重试或重新插入刷卡器进行操作"];
            
            return;
            //[self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
            
        }
        
        
        Byte *terminalVerificationResults = (Byte*)[[context terminalVerificationResults] bytes];
        int bit4 = terminalVerificationResults[2]>>3&0x01;
        if (bit4 == 1) { // 取消
            // TODO
            return ;
        }
        
        
        //go
        [self getCardInfoWithDic:@{@"cardType":@"IC",
                                   @"DcData":[NLISOUtils hexStringWithData:[tlvPackage pack]],
                                   @"maskedPAN":[context cardNo],
                                   @"KSN":[context cardSequenceNumber],
                                   @"ICNumber":[context cardSequenceNumber],
                                   @"encTrankSecond":erciStr,
                                   //@"erciStr":erciStr,
                                   }];
        
        NLSecondIssuanceRequest *request = [NLSecondIssuanceRequest new];
        request.authorisationResponseCode = @"00";
        [controller secondIssuance:request];
    }
    
    else {
                
        [self addText:@"onRequestOnline交易失败,请返回重试或重新插入刷卡器进行操作"];
    }

}

- (void)onEmvFinished:(BOOL)isSuccess context:(NLEmvTransInfo*)context error:(NSError*)err
{
    NSLog(@"=======>>>> onEmvFinished <<=======");
    
}

// 读取IC卡二磁道密文
- (NSData*)readICCardEncryptTrackData:(int)trackIndex encryptAlgorithm:(NSString*)encryptAlgorithm
{
    id<NLCardReader> reader = (id<NLCardReader>)[[TDAppDelegate sharedAppDelegate].device  standardModuleWithModuleType:NLModuleTypeCommonCardReader];
    id<NLSwiper> swiper = (id<NLSwiper>)[[TDAppDelegate sharedAppDelegate].device  standardModuleWithModuleType:NLModuleTypeCommonSwiper];
    // 读取磁道密文
    NLSwipeResult *rslt = [swiper readEncryptResultWithReadModel:@[@(NLSwiperReadModelReadICSecondTrack)] wk:[[NLWorkingKey alloc] initWithIndex:trackIndex] encryptAlgorithm:encryptAlgorithm];
    if (rslt.rsltType != NLSwipeResultTypeSuccess) { // 读取磁道密文失败
        rslt = nil;
    }
    //关闭刷卡器
    [reader closeCardReader];
    
    return [rslt secondTrackData];
}

- (void)close
{
    [[TDAppDelegate sharedAppDelegate].device destroy];
}

- (void)disConnnect {
    [[TDAppDelegate sharedAppDelegate].device  cancelCurrentExecute];
    [self performSelector:@selector(close) withObject:nil afterDelay:1.1f];
    //self.title = @"disConnect";
    if ([self respondsToSelector:@selector(addText:)]) {
        [self performSelectorInBackground:@selector(addText:) withObject:@"设备已经断开连接"];
    }
}

- (void)onFallback:(NLEmvTransInfo*)context error:(NSError*)err
{
    NSLog(@"------>>>>onFallback<<----");
    [self close];
    [self addText:@"刷卡失败,请返回重试"];
}
- (void)onError:(id<NLEmvTransController>)controller error:(NSError*)err
{
    NSLog(@"------>>>>onERROR<<----");
    [self close];
    [self addText:@"onError交易失败,请返回重试或重新插入刷卡器进行操作"];
    NSLog(@"onerror失败  %@", [err description]);
    
    if ([err isKindOfClass:NSClassFromString(@"NLProcessTimeoutError")]) { // 超时
        // TODO
        
        NSLog(@"交易超时");
        return ;
    } else if ([err isKindOfClass:NSClassFromString(@"NLDeviceInvokeCanceledError")]) { // 取消
        // TODO
        NSLog(@"交易取消");
    }
}

- (void)getCardInfoWithDic:(NSDictionary *)aDic {
    NSLog( @"info--- %@", aDic);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.descriptionLabel.text = @"刷卡完成";
        //self.cardNumLabel.text = [aDic objectForKey:@"maskedPAN"];
        self.payInfo.bankCardNumber = [aDic objectForKey:@"maskedPAN"];
        [self.payInfo SwipeWithDictionary:aDic];

        [self goToSignWithCardInfo:aDic];
        
    });
}

- (void)goToSignWithCardInfo:(NSDictionary *)cardInfoDic {
    
    [NLAudioPortHelper unregisterAudioPortListener];
    
    if(_hfbNewLandPayType == HFBkNewLandPayment||_hfbNewLandPayType== HFBkNewLandPayTerm|| _hfbNewLandPayType == HFBkNewLandPaymentT){  //支付
        TDSignViewController * sign = [[TDSignViewController alloc]init];
        sign.payInfo = _payInfo;
        [self.navigationController pushViewController:sign animated:YES];
        
    }else if (_hfbNewLandPayType == HFBkNewLandBankInquiry){ //余额查询
        
        TDBankInquiryViewController * Inquiry = [[TDBankInquiryViewController alloc]init];
        Inquiry.payInfo = _payInfo;
        [self.navigationController pushViewController:Inquiry animated:YES];
    }
    
}

-(void)clickbackButton {
    
//    if ([self.device isAlive]) {
//        [self.device cancelCurrentExecute];
//        [self close];
//    }
    
    
    [NSThread detachNewThreadSelector:@selector(chexiao) toTarget:self withObject:nil];
    [NLAudioPortHelper unregisterAudioPortListener];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    _canConnect = NO;
}

- (void)chexiao {
    [[TDAppDelegate sharedAppDelegate].device cancelCurrentExecute];
}

@end
