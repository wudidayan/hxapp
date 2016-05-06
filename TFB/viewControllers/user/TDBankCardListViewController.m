//
//  TDBankCardListViewController.m
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBankCardListViewController.h"
#import "TDBindBankCardViewController.h"
#import "TDBankCardInfo.h"
#import "TDBankCardCell.h"
@interface TDBankCardListViewController (){

    UIView * _bgView;
    int  _index;
    BOOL _isMove;

}


@end

@implementation TDBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"银行卡列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isMove = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
     [self backButton];
    [self creatUI];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI
{
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBankCard)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

- (void)reloadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [TDHttpEngine requestForGetBankCardInfoWithMobile:[TDUser defaultUser].custLogin WithCustId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.0f position:@"center"];
        NSLog(@"shuju:   %@", temArray);
        if (succeed) {
            self.dataMuArray = [[NSMutableArray alloc] initWithArray:temArray];
            [self creatTableView];
        }
        else
        {
            //[self performSelector:@selector(pop) withObject:self afterDelay:2.0f];
        }
    }];
}

- (void)creatTableView
{
    self.bankCardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, SVFS.width, SVFS.height - 70) style:UITableViewStylePlain];
    self.bankCardTableView.delegate = self;
    self.bankCardTableView.dataSource = self;
    self.bankCardTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.bankCardTableView];
}

- (void)addBankCard
{
    TDBindBankCardViewController *bindBankCardVC = [[TDBindBankCardViewController alloc] init];
    bindBankCardVC.state = kBandingBankCard;
    [self.navigationController pushViewController:bindBankCardVC animated:YES];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMuArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 67;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:[TDBankCardCell description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TDBankCardCell" owner:self options:nil]firstObject];
    }
    
    TDBankCardInfo *bankCardInfo = _dataMuArray[indexPath.row];
    cell.statusLabel.text = bankCardInfo.cerStatus;
    cell.BankNameLabel.text = bankCardInfo.issnam;
    cell.cardNumLabel.text = bankCardInfo.cardNo;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDBankCardCell * cell = (TDBankCardCell *)[tableView cellForRowAtIndexPath:indexPath];
  
    if ([cell.statusLabel.text isEqualToString:@"正在审核中"]) {
        [self.view makeToast:@"该银行卡正在审核中..." duration:2.0f position:@"center"];
        return;
    }
 
    if (_isMove) {
        _isMove = NO;
        [self creatViewWithCellButton:cell andIndex:indexPath.row];
        [UIView animateWithDuration:0.5f animations:^{
            
            cell.frame = CGRectMake(cell.frame.origin.x-183, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        _isMove = YES;
        [UIView animateWithDuration:0.5f animations:^{
            
            cell.frame = CGRectMake(cell.frame.origin.x+183, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        } completion:^(BOOL finished) {
             [_bgView removeFromSuperview];
        }];
    
    }

    
    

}
-(void)creatViewWithCellButton:(TDBankCardCell *)cell andIndex:(int)index{
    _index = index;
    UIView * bgview = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.frame)-182, cell.frame.origin.y, 182, cell.bounds.size.height)];
    _bgView = bgview;
    [cell.superview.superview addSubview:bgview];
    [cell.superview.superview bringSubviewToFront:cell.superview];
    for (int i = 0; i < 3; i++) {
        
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(60 * i + i, 0, 60, bgview.bounds.size.height);
        [bgview addSubview:button];
        button.tag = i;
        button.backgroundColor = [UIColor redColor];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button addTarget:self action:@selector(clickbutton:) forControlEvents:1 << 6];
        if (i == 0) {
            [button setTitle:@"设为默认" forState:0];
        }else if (i == 1){
            [button setTitle:@"修改" forState:0];
        }else{
            [button setTitle:@"删除" forState:0];
        }
        
    }

}
-(void)clickbutton:(UIButton *)sender{
//   1-银行卡绑定；2-银行卡信息修改；3-设为默认银行卡，4-解绑(删除)
    NSString * operType = nil;
    if (sender.tag == 0) {
        operType = @"3";
    }else if (sender.tag == 2){
        operType = @"4";
    }
    TDBankCardInfo * info = _dataMuArray[_index];
    if (1 == sender.tag) {
    TDBindBankCardViewController *bindBankCardVC = [[TDBindBankCardViewController alloc] init];
        bindBankCardVC.bankCardInfo = info;
        bindBankCardVC.state = kModificationBankCard;
    [self.navigationController pushViewController:bindBankCardVC animated:YES];
    }else{
    
        [TDHttpEngine requestForUpBankCardWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin OperType:operType oldCardNo:@"" cardNo:info.cardNo cardFront:@"" cardBack:@"" provinceId:@"" cityId:@"" cnapsCode:@"" subBranch:@"" certificateNo:@"" complete:^(BOOL succeed, NSString *msg, NSString *cod) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:msg duration:2.0f position:@"center"];
            if (succeed) {
                [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@YES afterDelay:2.5f];
            }
            else{
                
            }
        }];
    
    }

}
@end
