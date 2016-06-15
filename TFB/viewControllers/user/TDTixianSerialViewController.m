//
//  TDTixianSerialViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/6/5.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDTixianSerialViewController.h"
#import "TDTixianViewCell.h"

@interface TDTixianSerialViewController ()

@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) TDTiXianDetailedSerial * tixianInfo;
@end

@implementation TDTixianSerialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      [self backButton];
    self.title  = @"提现详情";
    self.automaticallyAdjustsScrollViewInsets = NO;

    _myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_myTableView];
    _myTableView.bounces = NO;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _array = @[@"流水号",@"提现类型",@"订单时间",@"完成时间",@"订单状态",@"商户编号",@"商户名称",@"提现金额",@"手续费",@"实际到账金额",@"提现银行卡"];
    [self RequestTiXian];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _array.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TDTixianViewCell * tixianCell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!tixianCell) {
        tixianCell = [[[NSBundle mainBundle]loadNibNamed:@"TDTixianViewCell" owner:self options:nil] firstObject];
    }
    tixianCell.backgroundColor = [UIColor clearColor];
    tixianCell.tittleLabel.text = _array[indexPath.row];
    
    if (0 == indexPath.row) {
        tixianCell.contextLabel.text = _tixianInfo.casordno;
    }else if (1== indexPath.row){
        if(_tixianInfo.payTypeMessage.length > 0) {
            tixianCell.contextLabel.text = [NSString stringWithFormat:@"%@(%@)", _tixianInfo.casTypeMessage, _tixianInfo.payTypeMessage];
        } else {
            tixianCell.contextLabel.text = [NSString stringWithFormat:@"%@", _tixianInfo.casTypeMessage];
        }
    }else if (2== indexPath.row){
           tixianCell.contextLabel.text = _tixianInfo.casDate;
    }else if (3== indexPath.row){
           tixianCell.contextLabel.text =  _tixianInfo.sucDate;
    }else if (4== indexPath.row){
        tixianCell.contextLabel.text = _tixianInfo.ordstatusMessage;
    }else if (5== indexPath.row){
           tixianCell.contextLabel.text = _tixianInfo.custId;
    }else if (6== indexPath.row){
           tixianCell.contextLabel.text = _tixianInfo.custName;
    }else if (7== indexPath.row){
            tixianCell.contextLabel.text = [NSString stringWithFormat:@"%.2f 元",_tixianInfo.ordamt.floatValue /100];
    }else if (8== indexPath.row){
           tixianCell.contextLabel.text = [NSString stringWithFormat:@"%.2f 元",_tixianInfo.fee.floatValue /100];
    }else if (9== indexPath.row){
            tixianCell.contextLabel.text = [NSString stringWithFormat:@"%.2f 元",_tixianInfo.netrecAmt.floatValue /100];
    }else if (10== indexPath.row){
           tixianCell.contextLabel.text = [TDBaseModel cardNoStarWithCardNo:_tixianInfo.cardno];
    }
    
        
    return tixianCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RequestTiXian{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestGetTranDetailWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin busType:_tranSerial.ordtype bizType:@"" ordno:_tranSerial.ordno complete:^(BOOL succeed, NSString *msg, NSString *cod, id serialInfo) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (succeed) {
            _tixianInfo = (TDTiXianDetailedSerial *)serialInfo;
            _tittleLabel.text = _tixianInfo.ordstatusMessage;
            [_myTableView reloadData];
        }else{
            
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
            [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:2];
        }
        
        
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
