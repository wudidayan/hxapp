//
//  TDBusinessViewController.m
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBusinessViewController.h"
#import "TDUseHelpTableViewController.h"
#import "TDAboutMineViewController.h"
#import "TDRealCertificationViewController.h"
#import "TDVerificationCodeViewController.h"
#import "TDForgetPwdViewController.h"
#import "TDEditPwdTypeViewController.h"
#import "Toast+UIView.h"
//#import "TDReadingAVDeviceViewController.h"
#import "TDUserInfoViewController.h"
//#import "TDBankCardListViewController.h"
#import "TDTranSeriaViewController.h"
#import "TDTranSeriaSecondViewController.h"

#import "TDDeviceListTableViewController.h"
#import "TDDrawingCashViewController.h"
#import "TDBindBankCardViewController.h"
#import "TDFenRunViewController.h"

#import "MJRefresh.h"
#import "TDBalanceInfo.h"

#define CALL_ALERT_TAG    100
#define EDITPWD_ALERT_TAG 101
#define CHECK_DEVI_TAG    102
#define BUND_DEVI_TAG     103

#define REALNAME_ALERT    200
#define BINDCARD_ALERT    201

#define KEFU_PNONENUM @"400-800-1234"
#define VER @"V1.0"
@interface TDBusinessViewController ()
{
    NSArray *_cellTextArray;
    NSArray *_cellImageArray;
//    UILabel * _cerStatusLabel;
//    UILabel * _bankStatusLabel;
    UIView  * _cellSubView;
    UIView *_redView;
    BOOL redDot;

}
@end

@implementation TDBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _cellTextArray = @[@"提款到银行账户", @"未完成交易",@"已完成交易",@"修改密码",@"设备列表", @"实名认证", @"绑定银行卡"];
    _cellImageArray = @[@"shanghu_tixian", @"shanghu_notdone",@"shanghu_done",@"shanghu_xiugaipwd", @"shanghu_shebei" , @"shanghu_shiming", @"shanghu_bindBank"];
    [self creatUI];
//    if ([[TDUser defaultUser].custStatus isEqualToString:@"0"]) {
//        //未实名认证
//        [self.view makeToast:@"尚未实名认证,请先进行实名认证" duration:2.0f position:@"center"];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bottomTableView.header setFont:[UIFont systemFontOfSize:12.0f]];
    [self.bottomTableView.header setTextColor:[UIColor colorWithRed:154/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    [self.bottomTableView.header beginRefreshing];
}

- (void)creatUI
{
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserInfo)];
    userTap.delegate = self;
    userTap.numberOfTapsRequired = 1;
    self.topView.userInteractionEnabled = YES;
    [self.topView addGestureRecognizer:userTap];
    
    self.bottomTableView.tableFooterView = [[UIView alloc] init];
    self.bottomTableView.rowHeight = 36;
//    self.bottomTableView.backgroundColor = [UIColor redColor];
//    NSLog(@"%@", self.bottomTableView.frame);
    
    [self.bottomTableView addLegendHeaderWithRefreshingBlock:^{
    
        [self upDataUserBalance];

    }];

}

- (void)gotoUserInfo
{
    TDUserInfoViewController *userInfoVC = [[TDUserInfoViewController alloc] init];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
#pragma mark-------
#pragma mark   TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellTextArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndef = @"cellIndef";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndef];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_cellImageArray[indexPath.row]]];
        imageView.frame = CGRectMake(10, 6, 24, 24);
        [cell.contentView addSubview:imageView];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 8, 2, self.bottomTableView.bounds.size.width / 2 - (imageView.frame.size.width + imageView.frame.origin.x + 8), 32);
        textLabel.text = _cellTextArray[indexPath.row];
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textAlignment = NSTextAlignmentLeft;
        //textLabel.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:textLabel];
        
        if (indexPath.row == 1) {
            _redView = [[UIView alloc]init];
            _redView.tag = 1;
            _redView.frame = CGRectMake(self.bottomTableView.bounds.size.width - 30, 13, 10, 10);
            _redView.layer.cornerRadius = 5;//圆形
            _redView.backgroundColor = [UIColor redColor];//颜色：红色
            [cell.contentView addSubview:_redView];
        }
//        NSLog(@"%hhd",redDot);
//        if (redDot == YES) {
//            [_redView setHidden:NO];
//        }
//        else
//        {
//            [_redView setHidden:YES];
//        }
        if (indexPath.row == 5||indexPath.row == 6) {
            UILabel *cerStatus = [[UILabel alloc] init];
            
            if(indexPath.row == 5){
                cerStatus.tag = 5;
            }
            
            if(indexPath.row == 6){
                cerStatus.tag = 6;
            }
            cerStatus.frame = CGRectMake(self.bottomTableView.bounds.size.width / 2, 2, self.bottomTableView.bounds.size.width / 2 - 10, 32);
            cerStatus.font = [UIFont systemFontOfSize:12.0f];
            cerStatus.textAlignment = NSTextAlignmentRight;
            //154 170 170
            cerStatus.textColor = [UIColor colorWithRed:154/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
            [cell.contentView addSubview:cerStatus];

        }
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", (long)indexPath.row);
    switch (indexPath.row) {
            
            /**
             *  @"提款到银行账户", @"交易记录", @"设备签到", @"修改密码", @"实名认证", @"绑定银行卡"
             */
        case 0:
        {
            if (2 != [[TDUser defaultUser].custStatus intValue]) {
                [self.view makeToast:@"实名认证尚未通过,请先进行实名认证" duration:2.0f position:@"center"];
            }else{
//                if (0 == [[TDUser defaultUser].cardNum intValue]) {
//                    [self.view makeToast:@"尚未绑定银行卡,请先绑定银行卡" duration:2.0f position:@"center"];
//                }else{
                if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"2"]) {
                    //提款的到银行账户
                    TDDrawingCashViewController * cashViewController = [[TDDrawingCashViewController alloc]init];
                    cashViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cashViewController animated:YES];
                }else
                {
                    [self.view makeToast:@"绑定银行卡尚未通过" duration:2.0f position:@"center"];
                }
                
//                }
            }

        }
            break;
        case 1:
        {
            
            //未完成交易
            TDTranSeriaViewController *tranSeriaVC = [[TDTranSeriaViewController alloc] init];
            tranSeriaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tranSeriaVC animated:YES];
        }
            break;
        case 2:
        {
            
            //已完成交易
            TDTranSeriaSecondViewController *tranSeriaVC = [[TDTranSeriaSecondViewController alloc] init];
            tranSeriaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tranSeriaVC animated:YES];
        }
            break;
            
            /*
        case 2:
        {
            //分润查询
            TDFenRunViewController * fenRunCV = [[TDFenRunViewController alloc]init];
            fenRunCV.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fenRunCV animated:YES];
        }
            break;
             */
            
        case 3:
        {
            //修改密码
            TDEditPwdTypeViewController *editPwdTypeVC = [[TDEditPwdTypeViewController alloc] init];
            editPwdTypeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:editPwdTypeVC animated:YES];
            
                   }
            break;
        case 4:
        {
            //设备列表
            TDDeviceListTableViewController * list = [[TDDeviceListTableViewController alloc]init];
            list.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:list animated:YES];
    
        }
            break;
        case 5:
        {
            if ([[TDUser defaultUser].custStatus isEqualToString:@"0"]) {
                //实名认证
                TDRealCertificationViewController *realNameCerVC = [[TDRealCertificationViewController alloc] init];
                realNameCerVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:realNameCerVC animated:YES];
            }
            
            else if ([[TDUser defaultUser].custStatus isEqualToString:@"1"] || [[TDUser defaultUser].custStatus isEqualToString:@"2"]) {
                [self.view makeToast:@"当前状态不可更改" duration:2.0f position:@"center"];
                
            }
            
            else if ([[TDUser defaultUser].custStatus isEqualToString:@"3"]) {
                
                UIAlertView *realNameAlert = [[UIAlertView alloc] initWithTitle:@"实名审核未通过" message:[TDUser defaultUser].ideCardAuthError delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去重新认证", nil];
                realNameAlert.tag = REALNAME_ALERT;
                [realNameAlert show];
                
            }
            
        }
            break;
        case 6:
        {
            if ([[TDUser defaultUser].custStatus isEqualToString:@"1"] || [[TDUser defaultUser].custStatus isEqualToString:@"2"]) {
                if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"0"]) {
                    
                    TDBindBankCardViewController *bankCardListVC = [[TDBindBankCardViewController alloc] init];
                    bankCardListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bankCardListVC animated:YES];
                }
                
                else if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"1"] || [[TDUser defaultUser].cardBundingStatus isEqualToString:@"2"]) {
                    if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"2"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"在信息审核尚未通过期间，用户无法进行资金业务的操作！" preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认修改" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            
                            [TDHttpEngine requestForGetBankCardInfoWithMobile:[TDUser defaultUser].custLogin WithCustId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [self.view makeToast:msg duration:2.0f position:@"center"];
                                NSLog(@"shuju:   %@", temArray);
                                if (succeed) {
                                    
                                    TDBankCardInfo * info = temArray[0];
                                    TDBindBankCardViewController *bindBankCardVC = [[TDBindBankCardViewController alloc] init];
                                    bindBankCardVC.state = kModificationBankCard;
                                    bindBankCardVC.bankCardInfo = info;
                                    bindBankCardVC.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:bindBankCardVC animated:YES];
                                    
                                }
                                
                            }];
                        }];
                        UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"放弃修改" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [alert addAction:action1];
                        [alert addAction:action2];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    //                [self.view makeToast:@"当前状态不可更改" duration:2.0f position:@"center"];
                    
                }
                
                else if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"3"]) {
                    
                    UIAlertView *bindCardAlert = [[UIAlertView alloc] initWithTitle:@"银行卡绑定审核未通过" message:[TDUser defaultUser].bankCardAuthError delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去重新绑定", nil];
                    bindCardAlert.tag = BINDCARD_ALERT;
                    [bindCardAlert show];
                }
                
            }else
            {
                UIAlertView * AL = [[UIAlertView alloc]initWithTitle:nil message:@"请先实名认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去认证", nil];
                AL.tag = 5;
                [AL show];
            }
            
        }
            
        default:
            break;
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == REALNAME_ALERT) {
        
        if (buttonIndex == 1) {
            
            TDRealCertificationViewController *realNameCerVC = [[TDRealCertificationViewController alloc] init];
            realNameCerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realNameCerVC animated:YES];
        }
    }
    
    else if (alertView.tag == BINDCARD_ALERT) {
        
        if (buttonIndex == 1) {
            
            TDBindBankCardViewController *bankCardListVC = [[TDBindBankCardViewController alloc] init];
            bankCardListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankCardListVC animated:YES];
        }
    }else if (alertView.tag == 5)
    {
        if (0 == buttonIndex) {
            TDRealCertificationViewController *realNameCerVC = [[TDRealCertificationViewController alloc] init];
            realNameCerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realNameCerVC animated:YES];
            
        }
    }
    
}


-(void)requestUserMessage{

    
    __weak typeof(self)weakself = self;
    [TDHttpEngine requestForGetCustInfWithCustMobile:[TDUser defaultUser].custLogin custId:[TDUser defaultUser].custId complete:^(BOOL succeed, NSString *msg, NSString *cod, TDUser *user) {
        
        if (succeed) {
            NSLog(@"%@",[TDUser defaultUser].redDot);
            if ([[TDUser defaultUser].redDot isEqualToString:@"1"]) {
                redDot = YES;
                [_redView setHidden:NO];
            }else
            {
                redDot = NO;
                [_redView setHidden:YES];
            }
            if (!Empty_Str([TDUser defaultUser].custName)) {
                weakself.userNameLabel.text = [TDUser defaultUser].custName;
            }else{
                weakself.userNameLabel.text = @"--";
            }
            weakself.userIDLabel.text = [TDUser defaultUser].custLoginStar;
            /*  认证状态（0未认证，1审核中，2审核通过，3审核不通过）*/
            
            UILabel * labelCer = (UILabel *)[self.bottomTableView viewWithTag:5];
            labelCer.text = [TDUser messageTextWithStatus:[TDUser defaultUser].custStatus andTYPE:YES];
            UILabel * labelBank = (UILabel *)[self.bottomTableView viewWithTag:6];
            labelBank.text = [TDUser messageTextWithStatus:[TDUser defaultUser].cardBundingStatus andTYPE:NO];
        }
        else
        {
            [weakself.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
    

}
-(void)upDataUserBalance{
  
    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForgetBalanceWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, TDBalanceInfo *info) {
      
        
        [_bottomTableView.header endRefreshing];

        if (succeed) {
            
            weakSelf.BalanceLabel.text = [NSString stringWithFormat:@"%.2f",info.acT1AP.floatValue/100];
            
            [self requestUserMessage];
        }else{
       
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
