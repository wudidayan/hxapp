#import "TDScanCodeResultViewController.h"

@interface TDScanCodeResultViewController ()

@end

@implementation TDScanCodeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付结果";
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatUI {
    
    self.navigationItem.hidesBackButton = YES;
    
    if (self.isSuccess) {
        self.statesImageView.image = [UIImage imageNamed:@"succes"];
    }
    else {
        self.statesImageView.image = [UIImage imageNamed:@"fail"];
    }
    
    self.statesLabel.text = self.resultState;
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    
    [[TDControllerManager sharedInstance]createTabbarController];
}
@end
