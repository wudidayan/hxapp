//
//  TDFastPayStep1ViewController.m
//  TFB
//
//  Created by Nothing on 16/5/15.
//  Copyright (c) 2016年 TD. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import "TDFastPayStep1ViewController.h"
#import "TDFastPayStep2ViewController.h"
#define ALERT_VIEW_TAG_CARDSIGN  10

@interface TDFastPayStep1ViewController ()
{
    ZSYPopoverListView *listView;
}

@property (nonatomic,strong) NSArray *bankArr;
@property (nonatomic,strong) NSArray *bankArrDefault;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation TDFastPayStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"银行卡";
    [self.bankNameButtom.layer setCornerRadius:5.0f];
    
    // 获取支持的银行列表
    self.bankArrDefault = [NSArray arrayWithObjects:
                           @"农业银行",@"交通银行",@"中国银行",@"建设银行",@"光大银行",
                           @"兴业银行",@"招商银行",@"中信银行",@"广东发展银行",@"华夏银行",
                           @"工商银行",@"平安银行",@"中国邮政",@"浦发银行",nil];
    self.bankArr = _bankArrDefault;
    [_bankNameButtom setTitle:@"= 请选择支持的银行 =" forState:0];
    self.fastPayContext = [[TDFastPay alloc]init];
}

-(void)viewWillAppear:(BOOL)animated {
    [self viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitBtnClick:(id)sender {
    [self.view endEditing:YES];

    if ([[_bankNameButtom.titleLabel.text substringToIndex:1] isEqualToString:@"="]) {
        [self.view makeToast:@"请选择银行名称" duration:2.0f position:@"center"];
        return;
    }

    if (_cardNumTF.text.length < 16) {
        [self.view makeToast:@"请输入正确的银行卡号" duration:2.0f position:@"center"];
        return;
    }

    self.fastPayContext.bankName = _bankNameButtom.titleLabel.text;
    self.fastPayContext.cardNo = _cardNumTF.text;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view makeToast:CString(@"%@／%@", self.fastPayContext.cardNo, self.fastPayContext.bankName) duration:2.0f position:@"center"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if(_cardNumTF.text.length == 17) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"签约提示" message:@"您的卡尚未签约，是否现在去签约？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去签约", nil];
        alertView.tag = ALERT_VIEW_TAG_CARDSIGN;
        [alertView show];
    } else {
        TDFastPayStep2ViewController *fastPayController = [[TDFastPayStep2ViewController alloc]init];
        fastPayController.fastPayContext = self.fastPayContext;
        fastPayController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fastPayController animated:YES];
    }
}

- (void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 选择银行
- (IBAction)clickBankButton:(UIButton *)sender {
    [self.cardNumTF resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 240, 320)];
    listView.tag = 100;
    listView.titleName.text = @"请选择银行";
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankArr.count;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"viewlist_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"viewlist_normal.png"];
    }
    
    NSString *bankName = self.bankArr[indexPath.row];
    cell.textLabel.text = bankName;
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"viewlist_normal.png"];
    
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"viewlist_selected.png"];
    NSLog(@"Select: %@", self.bankArr[indexPath.row]);
    [_bankNameButtom setTitle:self.bankArr[indexPath.row] forState:0];
    [tableView dismiss];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickbackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_VIEW_TAG_CARDSIGN) {
        if (0 == buttonIndex) {
            [self clickbackButton];
        } else {
            [self.view makeToast:@"去签约" duration:2.0f position:@"center"];
        }
    }
}

@end
