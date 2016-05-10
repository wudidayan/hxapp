//
//  TDDeviceListTableViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDDeviceListTableViewController.h"
#import "MJRefresh.h"
#import "TDDeviceTableViewCell.h"
#import "TDTermMessageViewController.h"
#import "TDBindNewLandViewController.h"
#import "TDSearchNewLandBlueTViewController.h"
#import "TDBindTYViewController.h"

@interface TDDeviceListTableViewController ()
@property (nonatomic,strong) NSArray * dataSourceArray;
@end

@implementation TDDeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷卡器列表";
    [self creatUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];

}
-(void)creatUI{
   
    UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];

    self.tableView.tableFooterView = BGView;

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:0];
    [BGView addSubview:button];
    [button setTitle:@"绑定刷卡器" forState:0];
    button.frame = CGRectMake(0, 0, BGView.bounds.size.width-30, 40);
    button.center = CGPointMake(BGView.bounds.size.width/2, BGView.bounds.size.height/2);
    [button addTarget:self action:@selector(clickButton) forControlEvents:1 << 6];
    
    
//    UILabel * Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-20, 40)];
//    Label.textColor = [UIColor grayColor];
//    Label.text = @"备注：商户365天内使用A费率和线上支付刷卡达到30万，系统返还设备押金。";
//    Label.font = [UIFont systemFontOfSize:12.0F];
//    [BGView addSubview:Label];
////    [Label sizeToFit];
//    Label.lineBreakMode = NSLineBreakByWordWrapping;
//    Label.numberOfLines = 0;
//    Label.center = CGPointMake(self.view.bounds.size.width/2, CGRectGetMaxY(button.frame)+20);
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf getDeviceList];
    }];
    [self backButton];
}
-(void)backButton{
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickbackButton)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}
-(void)clickbackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)clickButton{

    //新大陆音频
//    TDBindNewLandViewController *bindNewLandVC = [[TDBindNewLandViewController alloc] init];
//    bindNewLandVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:bindNewLandVC animated:YES];
    
//    TDSeachDeviceViewController *seachDeviceVC = [[TDSeachDeviceViewController alloc] init];
//    seachDeviceVC.pushVCType = BindDevice;
//    seachDeviceVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:seachDeviceVC animated:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请选择刷卡器类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新大陆音频", @"新大陆蓝牙", @"新大陆蓝牙(带键盘)", @"天瑜蓝牙", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        // 新大陆音频
        TDBindNewLandViewController *bindNewLandVC = [[TDBindNewLandViewController alloc] init];
        [self.navigationController pushViewController:bindNewLandVC animated:YES];
    }
    else if (buttonIndex == 1) {
        // 新大陆蓝牙
        TDSearchNewLandBlueTViewController *searchNewLandBlueVC = [[TDSearchNewLandBlueTViewController alloc] init];
        [self.navigationController pushViewController:searchNewLandBlueVC animated:YES];
    }
    else if (buttonIndex == 2) {
        // 新大陆蓝牙(带键盘)
        TDSearchNewLandBlueTViewController *searchNewLandBlueVC2 = [[TDSearchNewLandBlueTViewController alloc] init];
        [self.navigationController pushViewController:searchNewLandBlueVC2 animated:YES];
    }
    else if (buttonIndex == 3) {
        // 天瑜蓝牙
        TDBindTYViewController *bindVC = [[TDBindTYViewController alloc]init];
        [self.navigationController pushViewController:bindVC animated:YES];
    }
    else {
        //
    }
}

-(void)getDeviceList{

    //获取终端列表

    __weak typeof(self)weakSelf = self;
    [TDHttpEngine requestForGetTermListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray) {
        [weakSelf.tableView.header endRefreshing];
        if (succeed) {
            weakSelf.dataSourceArray = [NSArray arrayWithArray:termArray];
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 63.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TDDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDCELL"];
    if (!cell) {

        cell = [[[NSBundle mainBundle]loadNibNamed:@"TDDeviceTableViewCell" owner:self options:nil]firstObject];
    }
    TDTerm * term = [_dataSourceArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:245.0f/255 green:245.0f/255 blue:245.0f/255 alpha:1];
    cell.termTypeLabel.text = term.termTypeName;
    cell.termDevNumLabel.text = term.termNo;
//#ifdef POSDERVICE_PAY
//    cell.pay.hidden = term.termPayFlag.intValue -1;
//#else
//    cell.pay.hidden = YES;
//#endif
//    cell.pay.layer.cornerRadius =  2.0f;
    cell.term = term;
    cell.delegate = self;
    return cell;
}
-(void)clickPayButtonWithTerm:(TDTerm *)term{
   
    TDTermMessageViewController * termCV = [[TDTermMessageViewController alloc]init];
    termCV.term = term;
    [self.navigationController pushViewController:termCV animated:YES];

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
