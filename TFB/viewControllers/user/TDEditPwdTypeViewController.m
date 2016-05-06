//
//  TDEditPwdTypeViewController.m
//  TFB
//
//  Created by Nothing on 15/4/8.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDEditPwdTypeViewController.h"
#import "TDForgetPwdViewController.h"
#import "TDVerificationCodeViewController.h"

#define LOGINPWD_ALERTTAG 100
#define PAYPWD_ALERTTAG   101

@interface TDEditPwdTypeViewController ()

@property (nonatomic,strong) UITableView * myTableView;
@property (nonatomic,strong) NSArray * dataArray;

@end

@implementation TDEditPwdTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码管理";
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _dataArray = [NSArray arrayWithObjects:@"修改登录密码",@"修改支付密码",@"找回支付密码", nil];
   
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(-2, 120, self.view.bounds.size.width+4, 130)];
    _myTableView.layer.borderColor = [UIColor grayColor].CGColor;
    _myTableView.layer.borderWidth = 1.0f;
    _myTableView.tableFooterView = [UIView new];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.bounces = NO;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"shanghu_xiugaipwd"];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row) {
       TDForgetPwdViewController *forgetPwdVC = [[TDForgetPwdViewController alloc] init];
        forgetPwdVC.pwdType = kModifyLoginPwd;
        forgetPwdVC.custMobile = [TDUser defaultUser].custLogin;
        [self.navigationController pushViewController:forgetPwdVC animated:YES];
    }else if (1 == indexPath.row){
        
        if (![[TDUser defaultUser].custStatus isEqualToString:@"2"]) {
             [self.view makeToast:@"亲,需要先实名认证设置支付密码哦" duration:2.0f position:@"center"];
            return;
        }
        
        TDForgetPwdViewController *forgetPwdVC = [[TDForgetPwdViewController alloc] init];
        forgetPwdVC.pwdType = kModifyPayPwd;
        forgetPwdVC.custMobile = [TDUser defaultUser].custLogin;
        [self.navigationController pushViewController:forgetPwdVC animated:YES];

    }else if(2 == indexPath.row){
        
        if (![[TDUser defaultUser].custStatus isEqualToString:@"2"]) {
            [self.view makeToast:@"亲,需要先实名认证设置支付密码哦" duration:2.0f position:@"center"];
            return;
        }
        
        TDVerificationCodeViewController *verifiVC = [[TDVerificationCodeViewController alloc] init];
        verifiVC.verCodeType = VerEditPayPwd;
        [self.navigationController pushViewController:verifiVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
