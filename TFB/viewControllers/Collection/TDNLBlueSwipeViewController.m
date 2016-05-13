//
//  TDNLBlueSwipeViewController.m
//  TFB
//
//  Created by Nothing on 15/11/17.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDNLBlueSwipeViewController.h"
#import <MESDK/MTypeExCode.h>
#import "TDSignViewController.h"
#import "TDBankInquiryViewController.h"
#import "TDPayInfo.h"

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

@interface TDNLBlueSwipeViewController ()
{
    TDAppDelegate *_app;
}
@end

@implementation TDNLBlueSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.moneyLabel.text = self.payMoney;
    
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
    
    
    NSLog(@"NLDevWithPinKey: %ld", self.NLDevWithPinKey);
    if (self.NLDevWithPinKey == 1) {
        _payInfo.OutPinDevType = @"1";
        NSLog(@"OutPinDevType: %@", _payInfo.OutPinDevType);
    }
    
    _app = [TDAppDelegate sharedAppDelegate];
    [self getDeviceInfo];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(![_payInfo.OutPinDevType isEqualToString:@"1"]) {
        if ([_app.device isAlive]) {
            NSLog(@"destroy ME15");
            [_app.device destroy];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addText:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(),^{
        self.descriptionLabel.text = string;
    });
}

- (void)getDeviceInfo {
    
    if ([NLBluetoothHelper isConnected]) {
        
        id<NLDeviceInfo> info = [_app.device deviceInfo];
        
        NSString *inf = [NSString stringWithFormat:@"device info - sn:%@ , ksn:%@, csn:%@", [info SN], [info KSN], [info CSN]];
        NSLog(@"device info:%@", inf);
        if ([info CSN]) {
            
            [self checkTermIsBindWithKsn:[info CSN]];
        }
        else {
            
            NSLog(@"get csn failed");
        }
    }
}

//检测设备是否绑定
- (void)checkTermIsBindWithKsn:(NSString *)ksn {
    //获取终端列表
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForGetTermListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray) {
        
        if (succeed) {
            if (!termArray.count) {
                // [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [weakSelf.view makeToast:@"未绑定刷卡器,请前往绑定再进行交易" duration:2.0f position:@"center"];
                [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
            }else{
                _payInfo.termInfo = [termArray firstObject];
                _payInfo.termType = STATUSTWO;
                [self getCompateWirhKsn:ksn];
                //[self performSelector:@selector(getCompateWirhKsn:) withObject:ksn afterDelay:1.5f];
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
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
                    [self startTransfer];
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

- (id<NLEmvModule>)emvModule
{
    return (id<NLEmvModule>)[_app.device standardModuleWithModuleType:NLModuleTypeCommonEMV];
}

////开始执行读卡
-(void)startTransfer
{
    if (![[TDAppDelegate sharedAppDelegate].device isAlive]) {
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"设备未连接，请选择并连接！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return ;
    }
    [self addText:@"正在等待刷卡/插卡......"];

    id<NLSwiper> swiper = (id<NLSwiper>)[_app.device standardModuleWithModuleType:NLModuleTypeCommonSwiper];
    id<NLCardReader> reader = (id<NLCardReader>)[_app.device standardModuleWithModuleType:NLModuleTypeCommonCardReader];
    NSError *err;
    //输入金额
//    NSDecimalNumber *cash = @(1.00);
    NSString *showStr = CString(@"消费金额：%@元\n请刷卡/插卡",self.payMoney);
    NLEventHolder *listener = [NLEventHolder new];
    [reader openCardReaderWithCardReaderModuleTypes:@[@(NLModuleTypeCommonSwiper), @( NLModuleTypeCommonICCard), @(NLModuleTypeCommonNCCard)] screenShow:showStr timeout:60 listener:listener];
    [listener startWait:&err];
    if (err) {
        [reader cancelCardRead];
        if ([err isKindOfClass:NSClassFromString(@"NLProcessTimeoutError")]) {
            [self addText:@"读卡超时，请返回重试"];
        } else if ([err isKindOfClass:NSClassFromString(@"NLProcessCancelError")]) {
            [self addText:@"取消"];
        } else {
            [self addText:CString(@"读卡失败:%@，请返回重试",err)];
        }
        return;
    }
    NLOpenCardReaderEvent *event = [self eventFilter:listener.event exCode:ExCode_GET_TRACKTEXT_FAILED];
    //读取刷卡数据
    if (!event)
    {
        [self addText:@"失败"];
        return;
    }
    if ([event isUserCanceled])
    {
        [self addText:@"已取消"];
        return;
    }
    NSArray *openedModuleTypes = [event openedCardReaders];
    if (openedModuleTypes.count <= 0) {
        [self addText:@"失败"];
        return;
    }
    if (openedModuleTypes.count > 1) {
        NSString * errMsg = [NSString stringWithFormat:@"%d should return only one type of cardread action!but is :%d",
                             ExCode_GET_TRACKTEXT_FAILED, openedModuleTypes.count];
        [self addText:errMsg];
        return;
    }
    
    NLModuleType openType = [[openedModuleTypes objectAtIndex:0] integerValue];
    NLSwipeResult *rslt;
    NSDateFormatter *ft = [[NSDateFormatter alloc] init];
    [ft setDateFormat:@"yyMMddHHmmss"];
    NSData* time = [NLISOUtils hexStr2Data:[ft stringFromDate:[NSDate date]]];
    if (openType == NLModuleTypeCommonICCard) {
        
        NLOnlinePinConfig *config = [NLOnlinePinConfig new];
        config.workingKey = [[NLWorkingKey alloc] initWithIndex:NL_DEFAULT_PIN_WK_INDEX];
        config.pinManageType = NLPinManageTypeMKSK;
        config.pinPadding = [NSData fillWithByte:'F' len:10];
        config.displayContent = @"请输入密码:";
        config.timeout = 30;
        config.inputMaxLen = 6;
        config.isEnterEnabled = YES;
        //[self.emvModule setOnlinePinConfig:config];
        
        id<NLEmvTransController> emvController = [self.emvModule emvTransControllerWithListener:self];
        [emvController startEmvWithAmount:[NSDecimalNumber decimalNumberWithString:self.payMoney] cashback:[NSDecimalNumber zero] forceOnline:NO];
        
    }
    else if (NLModuleTypeCommonNCCard == openType) {
        // qpboc
        int processedCode = 0x0B; //0x25为查询余额代码 0x0B为非接交易消费
        if(_hfbNewLandPayType == HFBkNewLandBankInquiry)
        {
            processedCode = 0x25;
        }
        
        id<NLQPBOCModule> qpbocModule = (id<NLQPBOCModule> )[_app.device standardModuleWithModuleType:NLModuleTypeCommonQPBOC];
        NSError * err = nil;
        NLEmvTransInfo * emvTransInfo=[qpbocModule startQPBOCWithAmount:[NSDecimalNumber decimalNumberWithString:self.payMoney] processCode:processedCode timeout:60 error:&err];
        if (!emvTransInfo || err) {
            if (err) {
                if ([err isKindOfClass:NSClassFromString(@"NLProcessTimeoutError")]) {
                    [self addText:@"挥卡超时"];
                    return;
                } else if ([err isKindOfClass:NSClassFromString(@"NLProcessCancelError")]) {
                    [self addText:@"挥卡取消"];
                    return;
                } else {
                    [self addText:@"挥卡错误"];
                    return;
                }
            } else {
                [self addText:@"挥卡错误"];
                return;
            }
        } else {
            int exeRslt = emvTransInfo.executeRslt;
            /*
            if (rslt==0x00 || rslt==0x01 || rslt == 0x11 || rslt == 0x0d) {
                [self addText:emvTransInfo.cardNo];
            } else {
                [self addText:@"失败"];
                return;
            }
            */
            if(exeRslt == 0x0F) {
                id<NLSwiper> swiper = (id<NLSwiper>)[_app.device standardModuleWithModuleType:NLModuleTypeCommonSwiper];
                rslt = [swiper readEncryptResultWithReadModel:@[@(NLSwiperReadModelReadICSecondTrack)] wk:[[NLWorkingKey alloc] initWithIndex:NL_DEFAULT_TRACK_WK_INDEX] encryptAlgorithm:[NLTrackEncryptAlgorithm BY_UNIONPAY_MODEL]];
                
                if (rslt) {
                    NSString *enc = [[NSString alloc] initWithData:rslt.secondTrackData encoding:NSUTF8StringEncoding];
                    NSLog(@"encTrankSecond: %@", enc);
                    NSLog(@"encTrackThrid: %@", [self getMessageString:rslt.thirdTrackData]);
                    NSLog(@"acctId: %@", [rslt account].acctId);
                    NSLog(@"cardExpirationDate: %@", emvTransInfo.cardExpirationDate);
                    NSLog(@"validDate: %@", rslt.validDate);
                    
                    id<TLVPackage> tlvPackage = [emvTransInfo setExternalInfoPackageWithTags:
                        @[@0x9F26, @0x9F27, @0x9F10, @0x9F37, @0x9F36,
                          @0x95, @0x9A, @0x9C, @0x9F02, @0x5F2a, @0x82,
                          @0x9F1A, @0x9F03, @0x9F33, @0x9F34, @0x9F35,
                          @0x9F1E, @0x84, @0x9F09, @0x9F41, @0x9F63]];
                    if (![NLISOUtils hexStringWithData:[tlvPackage pack]] || [[NLISOUtils hexStringWithData:[tlvPackage pack]] isEqualToString:@""] || ![emvTransInfo cardNo] || [[emvTransInfo cardNo] isEqualToString:@""] ||  [[emvTransInfo cardNo] length] < 10) {
                        [self addText:@"卡片信息不完整，请返回重试"];
                        return;
                    }
                    
                    NSLog(@"DcData: %@", [NLISOUtils hexStringWithData:[tlvPackage pack]]);
                    NSLog(@"ICNumber: %@", [emvTransInfo cardSequenceNumber]);
                    
                    [self getCardInfoWithDic:@{@"cardType":@"IC",
                                               @"encTrankSecond":enc,
                                               @"encTrackThrid":[self getMessageString:rslt.thirdTrackData],
                                               @"maskedPAN":[rslt account].acctId,
                                               @"DcData":[NLISOUtils hexStringWithData:[tlvPackage pack]],
                                               @"KSN":[emvTransInfo cardSequenceNumber],
                                               @"ICNumber":[emvTransInfo cardSequenceNumber],
                                               @"nDate":rslt.validDate,
                                               @"expiryDate":rslt.validDate
                                               }];
                }
                else {
                    [self addText:@"刷卡失败"];
                    return;
                }
            }
            else if (exeRslt==0x00 || exeRslt==0x01 || exeRslt == 0x11 || exeRslt == 0x0d) {
                [self addText:@"此交易不支持非接方式，请返回重刷"];
            }
            else {
                [self addText:@"失败"];
                return;
            }
        }

    }
    else if (NLModuleTypeCommonSwiper == openType) {
        
        
        NLWorkingKey *wk = [[NLWorkingKey alloc] initWithIndex:NL_DEFAULT_TRACK_WK_INDEX];

        rslt = [swiper readEncryptResultWithReadModel:@[@(NLSwiperReadModelReadSecondTrack), @(NLSwiperReadModelReadThirdTrack)] wk:wk encryptAlgorithm:[NLTrackEncryptAlgorithm BY_UNIONPAY_MODEL]];
        if (rslt.rsltType != NLSwipeResultTypeSuccess) {
            rslt=nil;
        }
        
        //关闭刷卡器
        [reader closeCardReader];
        if (rslt) {

            NSString *enc = [[NSString alloc] initWithData:rslt.secondTrackData encoding:NSUTF8StringEncoding];
  
            NSLog(@"卡号：%@\n二磁道：%@\n三磁道：%@\n KSN：%@",[rslt account].acctId, [rslt secondTrackData], [rslt thirdTrackData], [rslt ksn]);
            
            [self getCardInfoWithDic:@{@"cardType":@"CT",
                                       @"encTrankSecond":enc,
                                       @"encTrackThrid":[self getMessageString:rslt.thirdTrackData],
                                       @"maskedPAN":[rslt account].acctId,
                                       @"KSN":rslt.ksn,
                                       @"nDate":rslt.validDate
                                       }];
            
        }
        else{
            [self addText:@"刷卡失败"];
            return;
        }
        
    }
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
            
        }
        
        
        Byte *terminalVerificationResults = (Byte*)[[context terminalVerificationResults] bytes];
        int bit4 = terminalVerificationResults[2]>>3&0x01;
        if (bit4 == 1) { // 取消
            // TODO
            return ;
        }
        //卡的有效期
        NSLog(@"date%@",context.cardExpirationDate);

        
        //go
        [self getCardInfoWithDic:@{@"cardType":@"IC",
                                   @"DcData":[NLISOUtils hexStringWithData:[tlvPackage pack]],
                                   @"maskedPAN":[context cardNo],
                                   @"KSN":[context cardSequenceNumber],
                                   @"ICNumber":[context cardSequenceNumber],
                                   @"encTrankSecond":erciStr,
                                   @"expiryDate":[context.cardExpirationDate substringToIndex:4]
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

- (void)onEmvFinished:(BOOL)isSuccess context:(NLEmvTransInfo*)context error:(NSError*)err {
    
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


#pragma mark - helpers
- (id<NLDeviceEvent>)eventFilter:(NLAbstractProcessDeviceEvent<NLDeviceEvent>*)event exCode:(int)defaultExCode
{
    if (event.isSuccess || event.isUserCanceled) {
        return event;
    }
    if (event.error) {
        return nil;
    }
    return nil;
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
    [_app.device destroy];
    [NSThread detachNewThreadSelector:@selector(chexiao) toTarget:self withObject:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)chexiao {
    [[TDAppDelegate sharedAppDelegate].device cancelCurrentExecute];
}

-(NSString *)getMessageString:(NSData *)data{
    
    NSString * string = [NSString stringWithFormat:@"%@",data];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string substringWithRange:NSMakeRange(1, string.length -2)];
    
    return string;
}
@end
