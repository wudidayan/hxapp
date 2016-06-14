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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitBtnClick:(id)sender {
    [self.view endEditing:YES];

    if (self.txnAmt.text.length == 0 || self.txnAmt.text.length > 9) {
        [self.view makeToast:@"请输入有效的收款金额" duration:2.0f position:@"center"];
        return;
    }

    self.scanCodeContext.txnAmt = _txnAmt.text;
    self.scanCodeContext.payData = @"http://123.com/test测试";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view makeToast:CString(@"%@", self.scanCodeContext.txnAmt) duration:2.0f position:@"center"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    TDScanCodeStep2ViewController *scanCodeController = [[TDScanCodeStep2ViewController alloc]init];
    scanCodeController.scanCodeContext = self.scanCodeContext;
    scanCodeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanCodeController animated:YES];
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
