//
//  TDFinanceViewController.m
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDFinanceViewController.h"
#import "TDUseHelpTableViewController.h"
#import "TDAboutMineViewController.h"
#import "TDAgreementViewController.h"
#import "TDLoginViewController.h"
#import "TDNoticeTableViewController.h"
#import "TDControllerManager.h"
#import "TDAppDelegate.h"
#define CALL_ALERT_TAG    100
#define LOGOUT            101

@interface TDFinanceViewController ()
{
    NSArray *_cellTextArray;
    NSArray *_cellImageArray;
    NSString * _updataUrl;

}
@end

@implementation TDFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:31/255.0f green:121/255.0f blue:132/255.0f alpha:1.0f];
    
    _cellTextArray = @[@"联系客服", @"版本更新", @"关于我们"];
    _cellImageArray = @[@"shanghu_kefu", @"shanghu_renew", @"shanghu_shiming"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    if ([cell viewWithTag:10010]) {
        [[cell viewWithTag:10010] removeFromSuperview];
    }
    
    UIView *view = [self creatCellViewWithIndexPath:indexPath];
    [cell.contentView addSubview:view];
    
    if (indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    }
    
    return cell;
}

- (UIView *)creatCellViewWithIndexPath:(NSIndexPath *)indexPath
{
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = 10010;
    bgView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    //    bgView.backgroundColor = [UIColor greenColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_cellImageArray[indexPath.row]]];
    imageView.frame = CGRectMake(10, 8, 30, 30);
    [bgView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 8, 2, self.tableView.bounds.size.width / 2 - (imageView.frame.size.width + imageView.frame.origin.x + 8), 40);
    textLabel.text = _cellTextArray[indexPath.row];
    [bgView addSubview:textLabel];
    
    if (indexPath.row == 0) {
        UILabel *verLabel = [[UILabel alloc] init];
        verLabel.frame = CGRectMake(self.tableView.bounds.size.width / 2, 2, self.tableView.bounds.size.width / 2 -10, 40);
        verLabel.text = APP_SERVICE_PHONE;
        verLabel.textAlignment = NSTextAlignmentRight;
        //154 170 170
        verLabel.textColor = [UIColor colorWithRed:154/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        [bgView addSubview:verLabel];
    }
    
    if (indexPath.row == 1) {
        UILabel *phoneNum = [[UILabel alloc] init];
        phoneNum.frame = CGRectMake(self.tableView.bounds.size.width / 2, 2, self.tableView.bounds.size.width / 2 - 10, 40);
        phoneNum.text = [NSString stringWithFormat:@"V %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        phoneNum.textAlignment = NSTextAlignmentRight;
        //154 170 170
        phoneNum.textColor = [UIColor colorWithRed:154/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        [bgView addSubview:phoneNum];
    }
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            
        case 0:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //联系客服
            UIAlertView *callAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"确定要拨打%@么？", APP_SERVICE_PHONE] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            callAlertView.tag = CALL_ALERT_TAG;
            callAlertView.delegate = self;
            [callAlertView show];
            
        }
            break;
        case 1:
        {
            //版本更新
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [TDHttpEngine requestForUpDataAppWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dic) {
                
                NSLog(@"---> %@",dic);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (succeed) {
                    
                    _updataUrl = [dic objectForKey:@"fileUrl"];
                    
                    //2 已经最新  1 需要更新  3 强制更新
                    if (3 == [[dic objectForKey:@"checkState"] integerValue]) {
                        
                        UIAlertView * AL = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"亲,有新版本需要更新喔" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                        AL.tag = 3;
                        [AL show];
                        
                        
                    }else if (2 == [[dic objectForKey:@"checkState"] integerValue]){
                        
                        UIAlertView * AL = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"亲,已经是最新版本了喔" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [AL show];
                        
                    }else if (1 == [[dic objectForKey:@"checkState"] integerValue]){
                        
                        UIAlertView * AL = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"亲,有新版本需要更新喔" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                        [AL show];
                        AL.tag = 1;
                    }
                }else{
                    
                    [self.view makeToast:msg duration:2.0f position:@"center"];
                }
            }];

        }
            break;
        case 2:
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //关于我们
            TDAboutMineViewController *aboutUsVC = [[TDAboutMineViewController alloc] init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == CALL_ALERT_TAG) {
        if (buttonIndex == 1) {
            NSLog(@"拨打");
            NSString *deviceType = [UIDevice currentDevice].model;
            if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
                NSLog(@"该设备不可拨打电话");
                [self.view makeToast:@"该设备不可拨打电话" duration:1.5f position:@"center"];
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", APP_CALL_PHOME]]];
        }
    }else if (alertView.tag == LOGOUT){
    
        if (0 == buttonIndex) {
            
            //退出登录
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [TDHttpEngine requestForLogoutWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[TDControllerManager sharedInstance] popToLogin];
            }];

        }
    }else if (alertView.tag == 3){
    
        if (0 == buttonIndex) {
            [[TDAppDelegate sharedAppDelegate] exitApplication];
            
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_updataUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updataUrl]];
            }
        }
    }else if (alertView.tag == 1){
       
        if (0 == buttonIndex) {
           
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_updataUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updataUrl]];
            }
        }
    }
}

- (void)share
{
    NSArray *activityItems = [[NSArray alloc]initWithObjects:@"满e刷", nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:Nil];
    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType, BOOL completed) {
        if (completed) {
            NSLog(@"completed");
        } else
        {
            NSLog(@"cancled");
        }
        [activityVC dismissViewControllerAnimated:YES completion:Nil];
    };
    activityVC.completionHandler = myBlock;
    [self presentViewController:activityVC animated:YES completion:Nil];
}

- (IBAction)ClickOutLogin:(UIButton *)sender {
    
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"真的要退出吗,亲" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    al.tag = LOGOUT;
    [al show];
    
}

@end
