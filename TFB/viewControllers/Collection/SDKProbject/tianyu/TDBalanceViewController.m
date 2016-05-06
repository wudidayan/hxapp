//
//  TDBalanceViewController.m
//  TFB
//
//  Created by 宋亚轩 on 16/4/14.
//  Copyright © 2016年 TD. All rights reserved.
//

#import "TDBalanceViewController.h"
#import "TDBankInquiryViewController.h"
#import "TDHttpEngine.h"

@interface TDBalanceViewController ()
{
    NSString *_termNo;
    NSString *_track;
    NSString *_pinblk;
    NSString *_random;
    NSString *_period;
    NSString *_icdata;
    NSString *_crdnum;
    NSMutableArray * _devArr;
    NSMutableDictionary *lanYaDic;
    UISegmentedControl *segmentedControlCheckCardMode;
    //
    ZSYPopoverListView *_listView;
    UIAlertView * genericAlert;
    BOOL _isCanRequest1;
    BOOL _isCanRequest2;
    BOOL lanyaYes;
    NSString *strMark;
    int ciShu;
    
}

@property (nonatomic,strong)TYSwiperController *tyMos;
@property (nonatomic, strong)  NSMutableArray * devListArr;
@property (nonatomic, strong)  NSIndexPath *selectedIndexPath;
@property (nonatomic, strong)  NSString *deviceNum; // 蓝牙刷卡器的终端号
@property (nonatomic, strong)  UIAlertView *getInfoFaileView; // 获取银行卡信息失败提示窗
@property (nonatomic,assign) Boolean flag;
@property (nonatomic,assign) Boolean execFlag;
@property (nonatomic,strong) TDPayInfo * payInfo;
@property (nonatomic,strong) TDLanYaUerInfo * lanYaInfo;
@end

@implementation TDBalanceViewController
#pragma mark - 属性懒加载
-(TYSwiperController *)tyMos
{
    if(!_tyMos)
    {
        _tyMos = [TYSwiperController shareInstance];
    }
    return _tyMos;
}
-(Boolean)flag
{
    if(!_flag)
    {
        _flag = NO;
    }
    return _flag;
}
-(Boolean)execFlag
{
    if(!_execFlag)
    {
        _execFlag = NO;
    }
    return _execFlag;
}
-(NSMutableArray *)devListArr
{
    if(!_devArr)
    {
        _devArr = [NSMutableArray array];
    }
    return _devArr;
}
-(TDPayInfo *)payInfo
{
    if(!_payInfo)
    {
        _payInfo = [[TDPayInfo alloc]init];
    }
    return _payInfo;
}
#pragma mark - 视图相关
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tyMos cancel];
    [self.tyMos disconnectDevice];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.payInfo.payType  = STATUSTWO;
    self.statusLabel.text = @"请连接天瑜刷卡器";
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.payBtn setTitle:@"搜索蓝牙设备" forState:0];
    
}

#pragma mark - 核心按钮点击
-(void)payBtnClick:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"搜索蓝牙设备"])
    {
        self.payBtn.userInteractionEnabled = NO;
        [self.payBtn setTitle:@"正在搜索..." forState:UIControlStateNormal];
        [self.payBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.tyMos.delegate = self;
        [self.tyMos initdevice:TY_BLUETOOTH_DEVICE];
        [self.devListArr removeAllObjects];
        _listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        _listView.tag = 100;
        _listView.titleName.text = @"蓝牙设备列表";
        _listView.datasource = self;
        _listView.delegate = self;
        [_listView show];
    }
    else
    {
        TDBankInquiryViewController * Inquiry = [[TDBankInquiryViewController alloc]init];
        Inquiry.payInfo = self.payInfo;
        [self.navigationController pushViewController:Inquiry animated:YES];
    }
}
#pragma mark - 刷卡器相关
//出现错误
-(void)onErrorCode:(NSInteger)code AndInfo:(NSString *)str
{
    [self.tyMos cancel];
    [self.tyMos disconnectDevice];
    [self.view makeToast:str duration:2.0f position:@"center"];
    [self pop];
}
//连接设备
- (void)onConnectedDevice:(BOOL)isSuccess
{
    if(isSuccess)
    {
        [self.payBtn setTitle:@"连接成功" forState:UIControlStateNormal];
        [self.tyMos getDeviceSN];
    }
    else
    {
        [self.payBtn setTitle:@"连接失败请重试" forState:UIControlStateNormal];
        [self pop];
        NSLog(@"连接失败");
    }
}
//设备断开
- (void)onDisConnectedDevice:(BOOL)isSuccess
{
    NSLog(@"设备连接断开");
}
//获取到SN
-(void)onReceiveDeviceSN:(NSString *)sn
{
    [self getKsn:sn];
}
//搜索到设备
-(void)onDiscoverDevice:(CBPeripheral *)device
{
    [self.devListArr addObject:device];
    [_listView.mainPopoverListView reloadData];
}
//签到成功
-(void)onUpdateWorkingKeyResult:(BOOL)TDK result:(BOOL)PIK result:(BOOL)MAK
{
//    NSDate *nowDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyMMddHHmmss";
//    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
//    if(TDK)
//    {
//        NSLog(@"TDK写入成功");
//        [self.tyMos readCard:@"0" TerminalTime:dateStr TradeType:0x31 timeout:60 Demote:nil];
//        [self updateSwipeCardUI];
//    }
}
//卡信息
/**
 获取刷卡后返回的数据
 @param  data 卡片数据
 磁条卡:
 cardType:卡类型
 cardNumber:卡号
 expiryDate:有效期
 serviceCode:服务代码
 encTrack2Ex:二磁道信息
 encTrack3Ex:三磁道信息
 pin:密码
 ic 卡:
 cardType:卡类型
 cardSeqNum:卡序号
 cardNumber:卡号
 icData: icData
 encTrack2Ex: 二磁道信息
 pin:密码
 */
-(void)onReadCard:(NSDictionary *)data
{
    [self updateNextUI];
    self.cardNumLabel.text = data[@"cardNumber"];
    NSString *cardType = data[@"cardType"];
    //共用
    NSString *cardNum = data[@"cardNumber"];
    NSString *cardTrack2 = data[@"encTrack2Ex"];
    //IC卡
    NSString *data55 = data[@"icData"];
    NSString *sqn = data[@"cardSeqNum"];
    NSString *validityDate = data[@"cardValidDate"];
    //磁条卡
    NSString *cardTrack3 = data[@"encTrack3Ex"];
//    self.payInfo = [[TDPayInfo alloc]init];
    /*服务器需要参数
     *  @param payType    支付方式
     *  @param payType    订单类型
     *  @param rate       费率类型
     *  @param termNo     终端号
     *  @param termType   终端类型
     *  @param payAmt     交易金额
     *  @param track      磁道信息
     *  @param pinblk     密码密文
     *  @param random     随机数     C		音频设备时使用
     *  @param mediaType  介质类型   C		01 刷卡 02 插卡
     *  @param period     有效期     C		mediaType 02时必填
     *  @param icdata     55域      C		mediaType 02时必填
     *  @param crdnum     卡片序列号  C		mediaType 02时必填
     *  @param mac        Mac       C		设备计算的mac
     ctype     付款类型 TO  TI
     *  @param complete   block回传
     */
//服务器需要的参数
//custID:16041400002691
//custMobile:13280503699
//termNo:(null)
//termType:(null)
//track:(null)
//pinblk:(null)
//random:(null)
//mediaType:(null)
//period:(null)
//icdata:(null)
//crdnum:(null)
//mac:(null)
    self.payInfo.bankCardNumber = cardNum;
    self.payInfo.termType = STATUSTWO;
//    self.payInfo.termInfo = [[TDTerm alloc]init];
//    self.payInfo.termInfo.termNo = _termNo;
    self.payInfo.mac =  @"";
    if([cardType isEqualToString:@"0"])
    {
        //刷磁条卡
        self.payInfo.mediaType = @"01";
        if (cardTrack3!=nil) {
            self.payInfo.track=[NSString stringWithFormat:@"%@|%@",cardTrack2,cardTrack3];
        }else{
            self.payInfo.track=[NSString stringWithFormat:@"%@|",cardTrack2];
        }
        self.payInfo.period = @"";
        self.payInfo.icdata = @"";
        self.payInfo.crdnum = @"";
    }
    else
    {
        //刷IC卡
        self.payInfo.mediaType = @"02";
        self.payInfo.track = [NSString stringWithFormat:@"%@|",cardTrack2];
        self.payInfo.icdata = data55;
        self.payInfo.crdnum = sqn;
        self.payInfo.period = validityDate;
        NSLog(@"%@",self.payInfo.period);
    }
    
    
    NSLog(@"%@",data);
}
//遍历终端号若存在进行终端签到
-(void)getKsn:(NSString *)ksn
{
    
    //获取终端列表
    ksn = [ksn substringFromIndex:2];
    _termNo = ksn;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForGetTermListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray) {
        
        if (succeed) {
            ciShu = 0;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            if (termArray == nil) {
                [weakSelf.view makeToast:@"未绑定刷卡器,请前往绑定再进行交易" duration:2.0f position:@"center"];
                [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
                self.statusLabel.text = @"交易过程出现异常";
            }else{
                BOOL isCompareKsn = NO;
                for (TDTerm * term in termArray)
                {
                    if ([term.termNo isEqualToString:ksn])
                    {
                        self.payInfo.termInfo = term;
                        self.lanYaInfo.type=ksn;
                        self.lanYaInfo.ksn=ksn;
                        self.lanYaInfo.termInfo = term;
                        isCompareKsn = YES;

                     }
                }
                if (isCompareKsn)
                {
                        self.payInfo.termType = STATUSONE;
                        self.lanYaInfo.type=STATUSONE;
                        [self getCompateWirhKsn:ksn];
                    
                }
                else
                {
                    [weakSelf.view makeToast:@"未绑定刷卡器,请前往绑定再进行交易" duration:2.0f position:@"center"];
                    [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
                }
            }
        }else{
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];

}
//终端签到
-(void)getCompateWirhKsn:(NSString *)ksn
{
    [TDHttpEngine requestForGetMiYaoWithCustMobile:[TDUser defaultUser].custLogin termNo:ksn termType:STATUSTWO custId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, TDPinKeyInfo *pinkey) {
        if(succeed)
        {
            NSLog(@"终端签到成功");
            //        NSString *TDK = @"83052530F0DB6C0178D5DF681849195187B861EF";
            //        [self.tyMos updateWorkingKey:TDK PIK:nil MAK:nil];
            NSDate *nowDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyMMddHHmmss";
            NSString *dateStr = [dateFormatter stringFromDate:nowDate];
            [self.tyMos readCard:@"0" TerminalTime:dateStr TradeType:0x31 timeout:60 Demote:nil];
            [self updateSwipeCardUI];
        }

    }];

    
         
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

#pragma mark - 蓝牙们的框框和选择相关代码
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devListArr.count;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    CBPeripheral *selectDeviceName = self.devListArr[indexPath.row];
    NSString *bDeviceName = selectDeviceName.name;
    //    NSString *uuidStr = (__bridge NSString *)CFUUIDCreateString(NULL, (CFUUIDRef)dataPath.UUID);
    //    if (uuidStr && uuidStr.length >= 8) {
    //        uuidStr = [uuidStr substringToIndex:8];
    //    }
    //    NSString *strdeName =dataPath.name?dataPath.name:@"Unknow";
    //    uuidStr = [strdeName  stringByAppendingString:uuidStr];
    cell.textLabel.text =bDeviceName;
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSLog(@"%@",self.devListArr[indexPath.row]);
    CBPeripheral *selectDeviceName = self.devListArr[indexPath.row];
    NSString *bDeviceName = selectDeviceName.name;
    [bDeviceName stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.tyMos connectDevice:bDeviceName];
    [self.tyMos stopScanDevice];
    [tableView dismiss];
}
#pragma mark - 通用方法
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
/** 设置刷卡UI */
-(void)updateSwipeCardUI
{
    self.statusLabel.text = @"请刷卡或插卡...";
    self.cardNumLabel.text = @"正在检测银行卡信息...";
}
/** 设置下一步UI */
-(void)updateNextUI
{
    [self.payBtn setBackgroundColor:[UIColor colorWithRed:122/255.0 green:204/255.0 blue:253/255.0 alpha:1]];
    [self.payBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.statusLabel.text = @"刷卡完成,请点击下一步";
    self.payBtn.userInteractionEnabled = YES;
}
@end
