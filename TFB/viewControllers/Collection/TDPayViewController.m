//
//  TDPayViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/11.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDPayViewController.h"
#import "TSLocateView.h"
#import "TDTerm.h"
#import "CJCommon.h"
#import "TDPayResaultViewController.h"

@interface TDPayViewController (){

    TSLocateView * _locationView;
//    TDTerm * _term;
    
    NSArray *_termRateArray;
    NSString *_location;

}

//定位管理器
@property (strong,nonatomic) CLLocationManager * locationManage;
@end

@implementation TDPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self backButton];
 
    //定位
    [self findLocation];
    self.title = @"支付";
    _termRateArray = [NSArray array];
    
    _BankCardNumLabel.text = _payInfo.bankCardNumber;
    _PayAmtLabel.text = _payInfo.payAmt;
    _typeButton.layer.borderColor = [UIColor grayColor].CGColor;
    _typeButton.layer.borderWidth = 1.0f;
    _typeButton.layer.cornerRadius = 3.0f;
    UIView * bgView = _BankCardNumLabel.superview;
    [self layerWithView:bgView];
    
    [self getTermRates];
    
//    if ([_payInfo.subPayType isEqualToString:PAY_SUB_TYPE]) {
//        
//        _typeButton.userInteractionEnabled = NO;
//        [_typeButton setTitle:@" - - " forState:0];
//        
//         _payInfo.rate = [(TDRate *)[_payInfo.termInfo.ratesArray firstObject] rateNo];
//    }
    
    
}

-(void)findLocation
{
    self.locationManage=[[CLLocationManager alloc]init];
    //设置属性
    //在后台和前台一直更新我们的地理位置信息
    [self.locationManage requestAlwaysAuthorization];
    //用的时候才更新
    //        [self.locationManage requestWhenInUseAuthorization];
    //设置精度
    self.locationManage.desiredAccuracy=100;
    //筛选器
    self.locationManage.distanceFilter=kCLLocationAccuracyBest;
    //开始我们的定位
    self.locationManage.delegate=self;
    [self.locationManage startUpdatingLocation];
}
#pragma mark - delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //数组里面第一个对象就是我们当前定位的对象
    CLLocation *loc=[locations objectAtIndex:0];
    //经纬度  海拔
    //纬度
    double wd=loc.coordinate.latitude;
    //经度
    double jd=loc.coordinate.longitude;
    //海拔
    double hb=loc.altitude;
    
    //地理位置的方向编译
    //就是将经纬度变成具体的地址
    //地理位置编码器
    CLGeocoder *geo=[[CLGeocoder alloc]init];
    [geo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            //地理标示
            CLPlacemark *placemark=[placemarks objectAtIndex:0];
            NSLog(@"*******%@",placemark.locality);
            _location=placemark.locality;

            
        }
    }];
    
}
- (void)getTermRates {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForGetTermRateListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin termNo:_payInfo.termInfo.termNo complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *rateArray) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (succeed) {
            _termRateArray = rateArray;
            if (_termRateArray.count == 1) {
                NSString *string = [(TDRate *)[_termRateArray objectAtIndex:0] rateDesc];
                [self.typeButton setTitle:string forState:UIControlStateNormal];
                _payInfo.rate = [(TDRate *)[_termRateArray objectAtIndex:0] rateNo];
            }
        }
        else {
            [self.view makeToast:msg duration:2.f position:@"center"];
        }
    }];
}



-(void)layerWithView:(UIView *)view{

    view.layer.cornerRadius = 5.0f;
    view.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    view.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
    view.layer.shadowOpacity = 0.5;//不透明度
    view.layer.shadowRadius = 10.0;//半径
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

- (IBAction)clickTypeButton:(UIButton *)sender {
    
    if (!_locationView) {
        _locationView = [[TSLocateView alloc]init];
        _locationView.viewType = kPAYVIEW;
    }
    
    
    if (_termRateArray.count == 0) {
        [self.view makeToast:@"无费率可供选择" duration:2.f position:@"center"];
    }
    else {
        _locationView = [_locationView initWithTitle:@"费率" delegate:self];
        [_locationView updataWithArray:_termRateArray];
        [self.view endEditing:YES];
        [_locationView showInView:self.view];
    }
    
}

- (IBAction)ClickPayButton:(UIButton *)sender {
    
    if (![_payInfo.subPayType isEqualToString:PAY_SUB_TYPE]) {
        if ([_typeButton.titleLabel.text hasPrefix:@"请选择"]) {
            [self.view makeToast:@"请选择费率类型" duration:2.0f position:@"center"];
            return;
        }
    }

    if (6 != _BankPasswordText.text.length) {
        
        [self.view makeToast:@"银行卡密码位数错误" duration:2.0f position:@"center"];
        return;
    }
    
    if ([_BankPasswordText.text isEqualToString:@""]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无密码支付？" delegate:self cancelButtonTitle:@"输入密码" otherButtonTitles:@"是的", nil];
        alertView.tag = 1;
        [alertView show];
        return;
    }
    
    if (_payInfo.mac == nil) {
        _payInfo.mac = @"";
    }
    
    if (!_payInfo.pinblk) {
        _payInfo.pinblk = [CJCommon pinResultMak:[TDPinKeyInfo pinKeyDefault].zpinkey account:_payInfo.bankCardNumber passwd:_BankPasswordText.text];
    }
    
    if (!_payInfo.period || [_payInfo.period isEqualToString:@""]) {
        _payInfo.period = @"1111";
    }
    NSLog(@"%@",_payInfo.period);
    NSString * payAmt = [NSString stringWithFormat:@"%.2f",_payInfo.payAmt.floatValue*100];

        if (_isWrite == NO) {
            _scanOrNot = @"1";
        }else
        {
            _scanOrNot = @"2";
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"1%@",_payInfo.prdordNo );
        NSLog(@"2%@",_payInfo.payType);
        NSLog(@"3%@",_payInfo.rate);
        NSLog(@"4%@",_payInfo.termInfo.termNo);
        NSLog(@"5%@",_payInfo.termType);
        NSLog(@"6%@",payAmt);
        NSLog(@"7%@",_payInfo.track);
        NSLog(@"8%@",_payInfo.pinblk);
        NSLog(@"9%@",_payInfo.mediaType);
        NSLog(@"10%@",_payInfo.period);
        NSLog(@"11%@",_payInfo.icdata);
        NSLog(@"12%@",_payInfo.crdnum);
        NSLog(@"13%@",_payInfo.mac);
        NSLog(@"14%@",_payInfo.ctype);
//        NSLog(@"15%@",_scanCardNum);
        NSLog(@"16%@",_scanOrNot);
        NSLog(@"17%@",_location);
    if (_location) {
        [TDHttpEngine requestForPayWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordNo:_payInfo.prdordNo payType:_payInfo.payType rate:_payInfo.rate termNo:_payInfo.termInfo.termNo termType:_payInfo.termType payAmt:payAmt track:_payInfo.track pinblk:_payInfo.pinblk random:@"CDB9C9D14724091B" mediaType:_payInfo.mediaType period:_payInfo.period icdata:_payInfo.icdata crdnum:_payInfo.crdnum mac:_payInfo.mac ctype:_payInfo.ctype scancardnum:_finalCardNum scanornot:_scanOrNot address:_location complete:^(BOOL succeed, NSString *msg, NSString *cod) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            TDPayResaultViewController *resultVC = [[TDPayResaultViewController alloc] init];
            resultVC.isSuccess = succeed;
            resultVC.resultState = msg;
            [self.navigationController pushViewController:resultVC animated:YES];
            
        }];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取位置信息失败，请设置允许方位定位" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alertView.tag = 2;
        [alertView show];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [_BankPasswordText becomeFirstResponder];
        }
        else if (buttonIndex == 1) {
            
            
            if ([_payInfo.termType isEqualToString:@"01"]) {
                
            }
            else if ([_payInfo.termType isEqualToString:@"02"]) {
                if (!_payInfo.pinblk) {
                    _payInfo.pinblk = @"NNNNNNNNNNNNNNNN";
                }
            }
            if (!_payInfo.mac) {
                _payInfo.mac = @"";
            }
            if (!_payInfo.period || [_payInfo.period isEqualToString:@""]) {
                _payInfo.period = @"1111";
            }
            
            if ([_payInfo.mediaType isEqualToString:@"01"]) {
                if (!_payInfo.icdata) {
                    _payInfo.icdata = @"";
                }
                if (!_payInfo.crdnum) {
                    _payInfo.crdnum = @"";
                }
            }
            
            NSString * payAmt = [NSString stringWithFormat:@"%.0f",_payInfo.payAmt.floatValue*100];
            if (_isWrite == NO) {
                _scanOrNot = @"1";
            }else
            {
                _scanOrNot = @"2";
            }
            if (_location) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [TDHttpEngine requestForPayWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordNo:_payInfo.prdordNo payType:_payInfo.payType rate:_payInfo.rate termNo:_payInfo.termInfo.termNo termType:_payInfo.termType payAmt:payAmt track:_payInfo.track pinblk:_payInfo.pinblk random:@"CDB9C9D14724091B" mediaType:_payInfo.mediaType period:_payInfo.period icdata:_payInfo.icdata crdnum:_payInfo.crdnum mac:_payInfo.mac ctype:_payInfo.ctype scancardnum:_finalCardNum scanornot:_scanOrNot address:_location complete:^(BOOL succeed, NSString *msg, NSString *cod) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    TDPayResaultViewController *resultVC = [[TDPayResaultViewController alloc] init];
                    resultVC.isSuccess = succeed;
                    resultVC.resultState = msg;
                    [self.navigationController pushViewController:resultVC animated:YES];
                    
                }];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取位置信息失败，请设置允许方位定位" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alertView.tag = 3;
                [alertView show];
            }
            
        }
    }else if (alertView.tag == 2)
    {
        if (buttonIndex == 0) {
            [[TDControllerManager sharedInstance]createTabbarController];
        }else if (buttonIndex == 1)
        {
            NSLog(@"*****");
        }
    }else
    {
        if (buttonIndex == 0) {
            [[TDControllerManager sharedInstance]createTabbarController];
        }else if (buttonIndex == 1)
        {
            NSLog(@"*****___");
        }
    }
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    [_locationView cancelWithView];
    
}

-(void)clickbackButton{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0) {
        
        UITableView * table = nil;
        table.tableHeaderView = [[UIView alloc]init];
        
    }else {
        
        if ([_locationView.titleLabel.text isEqualToString:@"费率"]) {
            [_typeButton setTitle:_locationView.rate.rateDesc forState:0];
            [_typeButton setTitleColor:[UIColor orangeColor] forState:0];
            _payInfo.rate = _locationView.rate.rateNo;
        }else if([_locationView.titleLabel.text isEqualToString:@"终端"]){
//            _term = _locationView.term;
//            [_temButton setTitle:_locationView.resultTermString forState:0];
//            [_temButton setTitleColor:[UIColor orangeColor] forState:0];
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_locationView cancelWithView];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
////  获取终端列表
//-(void)getTerminal{
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    __weak typeof(self)weakSelf = self;
//    [TDHttpEngine requestForGetTermListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        if (succeed) {
//            if (termArray.count) {
//                _term =  (TDTerm *)[termArray firstObject];
//            }
//        }else{
//            
//          [self.view makeToast:@"获取费率失败" duration:2.0f position:@"center"];
//            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@YES afterDelay:2];
//        }
//    }];
//}

@end
