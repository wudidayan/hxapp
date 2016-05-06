//
//  TDBindNLBlueViewController.m
//  TFB
//
//  Created by Nothing on 15/11/17.
//  Copyright © 2015年 TD. All rights reserved.
//

#import "TDBindNLBlueViewController.h"
#import "TDAppDelegate.h"

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

@interface TDBindNLBlueViewController ()
{
    TDAppDelegate *_app;
}
@end

@implementation TDBindNLBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title = @"绑定怡丰蓝牙设备";
    
    _termNameLabel.text = _termName;
    _termTypeLabel.text = @"新大陆蓝牙";
    
    _app = [TDAppDelegate sharedAppDelegate];
    
    [self getDeviceInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getDeviceInfo {
    
    if ([NLBluetoothHelper isConnected]) {
        
        id<NLDeviceInfo> info = [_app.device deviceInfo];
        
        NSString *inf = [NSString stringWithFormat:@"device info - sn:%@ , ksn:%@, csn:%@", [info SN], [info KSN], [info CSN]];
        NSLog(@"device info:%@", inf);
        if ([info CSN]) {
            
            _termCsnLabel.text = [info CSN];
            //[self regestDeviceWithKSN:[info CSN]];
        }
        else {
            
            NSLog(@"get csn failed");
        }
    }
}

- (void)regestDeviceWithKSN:(NSString *)ksn {
    NSLog(@"16ksn---%@", ksn);
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForBDZDWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:ksn complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.f position:@"center"];
        //[self addText:msg];
        if (succeed) {
            [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
        }
        else{
            
        }
    }];
}

- (IBAction)bindBtnClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForBDZDWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:_termCsnLabel.text complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.f position:@"center"];
        if (succeed) {
            [self performSelector:@selector(clickbackButton) withObject:self afterDelay:2.f];
        }
        else{
            
        }
    }];
}

- (void)clickbackButton {
    
    [_app.device destroy];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
