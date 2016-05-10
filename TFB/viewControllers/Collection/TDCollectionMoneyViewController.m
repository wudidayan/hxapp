//
//  TDCollectionMoneyViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/28.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDCollectionMoneyViewController.h"
#import "TDPayInfo.h"
#import "TDTerm.h"
#import "HFBSwipeViewController.h"
#import "TDSearchNewLandBlueTViewController.h"
#import "TDPayViewController.h"
#import "TDTYPayViewController.h"

#define CHOOSEDEVICEACTIONSHEETTAG 1001
@interface TDCollectionMoneyViewController (){

    TDPayInfo * _payInfo;
}
@property (nonatomic,assign) TDTerm * term;         //终端对象
@end

@implementation TDCollectionMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self backButton];
    if (_payment == kPaymentT1) {
        self.navigationItem.title = @"安全收款";
    }else if(_payment == kPaymentT0){
        self.navigationItem.title = @"即时到帐";
    }
    _payInfo = [[TDPayInfo alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{

    [self viewWillDisappear:animated];


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

- (IBAction)clickButton:(UIButton *)sender {
    
    if ([_moneyLabel.text rangeOfString:@"."].length > 0) {
        if ([[[_moneyLabel.text componentsSeparatedByString:@"."]lastObject] isEqualToString:@""]) {
            _moneyLabel.text = [_moneyLabel.text substringToIndex:_moneyLabel.text.length-1];
        }
    }
    
    if ([_moneyLabel.text isEqualToString:@"0"]) {
        
        [self.view makeToast:@"请输入支付金额" duration:2.0f position:@"center"];
        return;
    }
    _payInfo.payAmt = _moneyLabel.text;
    
    UIActionSheet *chooseDeviceActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择刷卡器类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新大陆音频", @"新大陆蓝牙", @"新大陆蓝牙(带键盘)", @"天瑜蓝牙", nil];
    chooseDeviceActionSheet.tag = CHOOSEDEVICEACTIONSHEETTAG;
    [chooseDeviceActionSheet showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == CHOOSEDEVICEACTIONSHEETTAG) {
        if (buttonIndex == 0) {
            // 新大陆音频
            HFBSwipeViewController *hfbSwipeVC = [[HFBSwipeViewController alloc] init];
            if (_payment == kPaymentT1) {
                hfbSwipeVC.hfbNewLandPayType = HFBkNewLandPayment;
            }
            else if(_payment == kPaymentT0){
                hfbSwipeVC.hfbNewLandPayType = HFBkNewLandPaymentT;
            }
            
            hfbSwipeVC.payMoney = _moneyLabel.text;
            hfbSwipeVC.payInfo = _payInfo;
            hfbSwipeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hfbSwipeVC animated:YES];

        }
        else if (buttonIndex == 1) {
            // 新大陆蓝牙
            TDSearchNewLandBlueTViewController *searchNLBlueVC = [[TDSearchNewLandBlueTViewController alloc] init];
            if (_payment == kPaymentT1) {
                searchNLBlueVC.hfbNewLandPayType = HFBkNewLandPayment;
            }
            else if(_payment == kPaymentT0) {
                searchNLBlueVC.hfbNewLandPayType = HFBkNewLandPaymentT;
            }
            
            searchNLBlueVC.payMoney = _moneyLabel.text;
            searchNLBlueVC.payInfo = _payInfo;
            searchNLBlueVC.pushVCType = SwipeCard;
            searchNLBlueVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchNLBlueVC animated:YES];
        }
        else if (buttonIndex == 2) {
            // 新大陆蓝牙(带键盘)
            TDSearchNewLandBlueTViewController *searchNLBlueVC2 = [[TDSearchNewLandBlueTViewController alloc] init];
            if (_payment == kPaymentT1) {
                searchNLBlueVC2.hfbNewLandPayType = HFBkNewLandPayment;
            }
            else if(_payment == kPaymentT0) {
                searchNLBlueVC2.hfbNewLandPayType = HFBkNewLandPaymentT;
            }
            
            searchNLBlueVC2.NLDevWithPinKey = 1; // 目的: 用于区分ME15和ME30
            searchNLBlueVC2.payMoney = _moneyLabel.text;
            searchNLBlueVC2.payInfo = _payInfo;
            searchNLBlueVC2.pushVCType = SwipeCard;
            searchNLBlueVC2.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchNLBlueVC2 animated:YES];
        }
        else if (buttonIndex == 3) {
            // 天瑜蓝牙
            TDTYPayViewController *payVC = [[TDTYPayViewController alloc]init];
            payVC.payInfo = _payInfo;
            payVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else {
            //
        }
    }
}

- (IBAction)clickNumberButton:(UIButton *)sender {
    
    if (sender.tag != 11) {
        if (![self controlWithStringTAG:sender.tag]) {
            return;
        }
    }
    
    if (10 > sender.tag) {//数字
        
        if (![_moneyLabel.text isEqualToString:@"0"]) {
            _moneyLabel.text = [NSString stringWithFormat:@"%@%ld",_moneyLabel.text,(long)sender.tag];
        }else{
            _moneyLabel.text = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        }
        
    }else if (11 == sender.tag){//chear
        
        
        if (![_moneyLabel.text isEqualToString:@"0"]) {
            
            if (1 >= _moneyLabel.text.length) {
                _moneyLabel.text = @"0";
            }else{
                if ([_moneyLabel.text rangeOfString:@"."].length == 0) {
                    _moneyLabel.text = [_moneyLabel.text substringToIndex:_moneyLabel.text.length-1];
                }else{
                    
                    NSString * string = [[_moneyLabel.text componentsSeparatedByString:@"."]lastObject];
                    NSInteger index = string.integerValue;
                    if (string.length >= 2) {
                        
                        if (index>=10) { //去掉一位
                            _moneyLabel.text = [_moneyLabel.text substringToIndex:_moneyLabel.text.length-1];
                        }else{
                            _moneyLabel.text = [_moneyLabel.text substringToIndex:_moneyLabel.text.length-3];
                        }
                    }else if (string.length == 1){
                        _moneyLabel.text = [_moneyLabel.text substringToIndex:_moneyLabel.text.length-2];
                    }else{
                        _moneyLabel.text = [_moneyLabel.text substringToIndex:_moneyLabel.text.length-1];
                    }
                    
                }
            }
        }
        
    }else if (20 == sender.tag){//0
        
        if (![_moneyLabel.text isEqualToString:@"0"]) {
            _moneyLabel.text = [NSString stringWithFormat:@"%@0",_moneyLabel.text];
        }
        
    }else if (21 == sender.tag){ // .
        if ([_moneyLabel.text rangeOfString:@"."].length == 0) {
            _moneyLabel.text = [NSString stringWithFormat:@"%@.",_moneyLabel.text];
        }
        
    }else if (22 == sender.tag){ // 00
        if (![_moneyLabel.text isEqualToString:@"0"]) {
            _moneyLabel.text = [NSString stringWithFormat:@"%@00",_moneyLabel.text];
        }
        
    }
    
}
-(BOOL)controlWithStringTAG:(NSInteger )tag{
    
    if ([_moneyLabel.text rangeOfString:@"."].length > 0) { //小数位
        NSString * string = [[_moneyLabel.text componentsSeparatedByString:@"."]lastObject];
        
        if (string.length >= 2) { //小输位数位数控制
            return NO;
        }else if(string.length == 1){                    //小数位输入控制
            
            if(tag == 0 || tag == 22){//如果输入0  不让输入
                return NO;
            }
        }else{
            if (tag ==22) { //如果输入0  不让输入
                return NO;
            }
        }
    }
    
    return YES;
}
@end
