//
//  TDBindTYViewController.m
//  TFB
//
//  Created by YangTao on 16/4/12.
//  Copyright © 2016年 TD. All rights reserved.
//

#import "TDBindTYViewController.h"
#import "TYCommonLib.h"
@interface TDBindTYViewController ()<TYSwiperControllerDelegate,ZSYPopoverListDelegate,ZSYPopoverListDatasource>

@property (nonatomic,strong) TYSwiperController *tyMos;
@property (nonatomic,strong) ZSYPopoverListView *listView;
@property (nonatomic,strong) NSMutableArray *termArray;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;

@end

@implementation TDBindTYViewController
#pragma mark - 属性们懒加载
- (TYSwiperController *)tyMos
{
    if(!_tyMos)
    {
        _tyMos = [TYSwiperController shareInstance];
    }
    return _tyMos;
}
-(NSMutableArray *)termArray
{
    if(!_termArray)
    {
        _termArray = [NSMutableArray array];
    }
    return _termArray;
}
#pragma mark - 视图相关
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tyMos disconnectDevice];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定终端";
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tyMos.delegate = self;
    [self.tyMos  initdevice: TY_BLUETOOTH_DEVICE];
}
#pragma mark - 核心按钮点击
-(void)bindBtnClick:(id)sender
{
    _listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    _listView.tag = 100;
    _listView.titleName.text = @"蓝牙设备列表";
    _listView.datasource = self;
    _listView.delegate = self;
    [_listView show];
}
#pragma mark - 刷卡器相关
//出错
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
        [self.tyMos getDeviceSN];
    }
    else
    {
        NSLog(@"连接失败");
    }
}
//设备断开
- (void)onDisConnectedDevice:(BOOL)isSuccess
{
    NSLog(@"设备连接断开");
}
-(void)onReceiveDeviceSN:(NSString *)sn
{
    [self getKsn:sn];
}
//获取KSN
-(void)getKsn:(NSString *)ksn
{
    [self.tyMos disconnectDevice];
    NSString *str = [ksn substringWithRange:NSMakeRange(0,ksn.length)];
    str = [str substringFromIndex:2];
    self.termCsnLabel.text = str;
    self.termTypeLabel.text = @"蓝牙刷卡器";
    self.termNameLabel.text = @"天瑜";
    self.termName = str;
    self.title = @"已获取设备";
    NSLog(@"%@",str);
    [self bundTermWithDeviceNum:str];
}

//设备绑定
- (void)bundTermWithDeviceNum:(NSString *)aDeviceNum
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForBDZDWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:aDeviceNum complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            
        }
        else
        {
            
        }
        [self.tyMos disconnectDevice];
        [self performSelector:@selector(pop) withObject:self afterDelay:2.5f];
    }];
}
//返回主页
- (void)pop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//发现设备
- (void)onDiscoverDevice:(CBPeripheral*)device
{
    NSLog(@"%@",device.name);
    [self.termArray addObject:device];
    [_listView.mainPopoverListView reloadData];
}
#pragma mark - 蓝牙们的框框和选择相关代码
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.termArray.count;
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
    CBPeripheral *selectDeviceName = self.termArray[indexPath.row];
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
    NSLog(@"%@",self.termArray[indexPath.row]);
    
    CBPeripheral *selectDeviceName = self.termArray[indexPath.row];
    NSString *bDeviceName = selectDeviceName.name;
    [bDeviceName stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.tyMos connectDevice:bDeviceName];
    [self.tyMos stopScanDevice];
    [tableView dismiss];
}


@end
