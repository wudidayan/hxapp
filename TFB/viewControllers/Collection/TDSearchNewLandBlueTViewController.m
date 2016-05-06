//
//  TDSearchNewLandBlueTViewController.m
//  TFB
//
//  Created by Nothing on 15/11/16.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDSearchNewLandBlueTViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TDAppDelegate.h"
#import "TDBindNLBlueViewController.h"
#import "TDNLBlueSwipeViewController.h"

#define SEARCHTIMEOUT 6


@interface TDSearchNewLandBlueTViewController ()
{
    NSDictionary *_allDevDic;
    
    MBProgressHUD *_HUD;
    
    UIBarButtonItem *_rightBar;
    NSMutableArray *_deviceMuArray;
    UITableView *_listTableView;
    
    NSString *_termName;
    //
    dispatch_queue_t queue ;
    dispatch_source_t _timer;
}
@end

@implementation TDSearchNewLandBlueTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title = @"搜索新大陆蓝牙设备";
    
    [self crearUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)crearUI {
    
    _rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(startScan)];
    _rightBar.enabled = NO;
    self.navigationItem.rightBarButtonItem = _rightBar;
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SVFS.width, SVFS.height - 20) style:UITableViewStyleGrouped];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    
    
    [self startScan];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allDevDic.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellInde = @"CELLINDE";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInde];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInde];
    }

    cell.textLabel.text = _allDevDic.allKeys[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _termName = _allDevDic.allKeys[indexPath.row];
    [self performSelector:@selector(initalizedDriverWithBleName:) withObject:_termName afterDelay:0.5];
}


- (void)startScan {
    
    if ([NLBluetoothHelper isConnected]) {
        
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.labelText = @"搜索蓝牙设备中...5s";
    [_HUD show:YES];
    [self timerFireMethod];
    
    [NLBluetoothHelper startScan];
    [self performSelector:@selector(stopScanNL) withObject:self afterDelay:5.0f];
}

- (void)stopScanNL {
    
    [_HUD hide:YES];
    _rightBar.enabled = YES;
    [NLBluetoothHelper stopScan];
    _allDevDic = [NLBluetoothHelper devices];
    NSLog(@"-----%@", [NLBluetoothHelper devices]);
    [_listTableView reloadData];
    
}

- (void)initalizedDriverWithBleName:(NSString*)name
{
    TDAppDelegate *app = [TDAppDelegate sharedAppDelegate];
    
    //    NSDictionary* bleMap = [NLBluetoothHelper syncScanWithDuration:2];
    NSDictionary* bleMap = [NLBluetoothHelper devices]; // 当前扫描到的蓝牙设备（key-value，蓝牙名-uuid）
    NSLog(@"devices %@", bleMap);
    NSLog(@"is has device connected %d", [NLBluetoothHelper isConnected]); // 判断是否有蓝牙连接
    
    // 蓝牙连接参数
    id<NLDeviceConnParams> params = [[NLBlueToothV100ConnParams alloc] initWithUuid:[bleMap objectForKey:name]];
    // 请求连接并获取ME30终端设备
    NSError *err = nil; // 驱动连接设备错误指针
    // 驱动连接ME30获取设备对象信息
    app.device = [app.driver connectWithConnParams:params closedListener:self error:&err];
    if (err || !app.device) { // 获取失败
        [self performSelectorOnMainThread:@selector(onDeviceConnectFailed:) withObject:[NSString stringWithFormat:@"%@", err] waitUntilDone:NO];
        return ;
    }
    NSLog(@"Bluetooth device instance %@", app.device);
    [app.device registerInitiativeListener:self];
    [self performSelectorOnMainThread:@selector(onDevicecConnectSuccess) withObject:nil waitUntilDone:NO];
}

- (void)onDeviceConnectFailed:(NSString*)errMsg {

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"设备连接失败：%@!!!", errMsg);
    
    
}

- (void)onDevicecConnectSuccess {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"设备连接成功");
    
    if (_pushVCType == BindDevice) {
        
        TDBindNLBlueViewController *bindNLBlueVC = [[TDBindNLBlueViewController alloc] init];
        bindNLBlueVC.termName = _termName;
        [self.navigationController pushViewController:bindNLBlueVC animated:YES];
    }
    else if (_pushVCType == SwipeCard) {
        
        TDNLBlueSwipeViewController *nlBlueSwipeVC = [[TDNLBlueSwipeViewController alloc] init];
        nlBlueSwipeVC.hfbNewLandPayType = self.hfbNewLandPayType;
        nlBlueSwipeVC.payInfo = self.payInfo;
        nlBlueSwipeVC.payMoney = self.payMoney;
        [self.navigationController pushViewController:nlBlueSwipeVC animated:YES];
    }
    
}

- (void)timerFireMethod
{
    __block int timeout = SEARCHTIMEOUT-1; //倒计时时间
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }else{
            int seconds = timeout % SEARCHTIMEOUT;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _HUD.labelText = [NSString stringWithFormat:@"搜索蓝牙设备中...%@",strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
