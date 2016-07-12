#import "ZSYPopoverListView.h"
#import "TDScanCodeStep1ViewController.h"
#import "TDScanCodeStep2ViewController.h"

@interface TDScanCodeStep1ViewController ()

@end

@implementation TDScanCodeStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置扫码收款金额";
    self.scanCodeContext = [[TDScanCode alloc]init];
    [self.txnAmt becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitBtnClick:(id)sender {
    [self.view endEditing:YES];

    if (self.txnAmt.text.length == 0 || self.txnAmt.text.length > 9) {
        [self.view makeToast:@"请输入有效的收款金额" duration:2.0f position:@"center"];
        return;
    } else {
        self.scanCodeContext.txnAmt = _txnAmt.text;
    }
    
    // 收款订单
    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *payAmt = [NSString stringWithFormat:@"%.2f", _scanCodeContext.txnAmt.floatValue * 100];
    [TDHttpEngine requestForPrdOrderWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordType:@"01" bizType:@"04" prdordAmt:payAmt prdName:@"扫码" price:payAmt complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic) {
        
        if (succeed) {
            _scanCodeContext.prdordNo = [infoDic objectForKey:@"prdordNo"];
            NSLog(@"prdordNo: %@", _scanCodeContext.prdordNo);
            
            // 订单成功后支付
            [TDHttpEngine requestForPayWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin prdordNo:_scanCodeContext.prdordNo payType:@"04" rate:@"" termNo:@"999999999" termType:@"" payAmt:payAmt track:@"" pinblk:@"" random:@"" mediaType:@"" period:@"" icdata:@"" crdnum:@"" mac:@"" ctype:@"00" scancardnum:@"" scanornot:@"" address:@"上海市" complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic) {
                
                if (succeed) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    _scanCodeContext.payData = [infoDic objectForKey:@"payData"];
                    if(_scanCodeContext.payData.length > 16) {
                        TDScanCodeStep2ViewController *scanCodeController = [[TDScanCodeStep2ViewController alloc]init];
                        scanCodeController.scanCodeContext = self.scanCodeContext;
                        scanCodeController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:scanCodeController animated:YES];
                    } else {
                        [weakSelf.view makeToast:@"生成二维码失败，请稍候重试" duration:2.0f position:@"center"];
                    }
                } else {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
                    return;
                }
                
            }];
        } else {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
            return;
        }
    }];
}

- (void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickbackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

@end
