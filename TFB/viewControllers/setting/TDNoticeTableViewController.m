//
//  TDNoticeTableViewController.m
//  TFB
//
//  Created by Nothing on 15/4/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDNoticeTableViewController.h"
#import "TDNoticeInfoViewController.h"
#import "MJRefresh.h"
#import "TDNoticeInfo.h"
#import "TDNoticeTableViewCell.h"
#import "TDNoticeInfoViewController.h"

@interface TDNoticeTableViewController ()
{
    NSString * _lastId;
    int _startPage;
}
@end

@implementation TDNoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"消息中心";
    _lastId = @"";
    _startPage = 0;
    [self backButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.dataMuArray = [[NSMutableArray alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf downPull];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf upPull];
    }];
    
    [self.tableView.header beginRefreshing];
    
}
-(void)backButton{
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickbackButton)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}
-(void)clickbackButton{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downPull
{
    [self.dataMuArray removeAllObjects];

    _lastId  = @"";
    [TDHttpEngine requestForNoticeWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin start:@"0" pageSize:@"15" noticeStatus:@"2" lastId:_lastId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *noticeArray) {
        [self.tableView.header endRefreshing];
        if (succeed) {
            NSLog(@"shuju: %@", noticeArray);
            if (noticeArray.count == 0) {
                [self.view makeToast:@"暂无公告" duration:2.0f position:@"center"];
                return;
            }
            [self.dataMuArray addObjectsFromArray:noticeArray];
            [self.tableView reloadData];
        }
        else{
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
    
}

- (void)upPull
{
    if (15 > self.dataMuArray.count) {
        
        [self.view makeToast:@"公告已经全部在这里了,亲" duration:2.0f position:@"center"];
         [self.tableView.footer endRefreshing];
        return;
    }
    
    if (self.dataMuArray.count) {
      _lastId = [(TDNoticeInfo *)[self.dataMuArray lastObject] noticeId];
        _startPage += 15;
    }else{
    _lastId = @"";
        _startPage = 0;
    }
    

    
    [TDHttpEngine requestForNoticeWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin start:[NSString stringWithFormat:@"%d",_startPage] pageSize:@"15"noticeStatus:@"2" lastId:_lastId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *noticeArray) {
        [self.tableView.footer endRefreshing];
        if (succeed) {
            if (noticeArray.count == 0) {
                [self.view makeToast:@"无更多数据" duration:2.0f position:@"center"];
                return;
            }
            [self.dataMuArray addObjectsFromArray:noticeArray];
            [self.tableView reloadData];
        }
        else{
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 55.0f;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataMuArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"CELL";
    TDNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = (TDNoticeTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"TDNoticeTableViewCell" owner:self options:nil] firstObject];
    }
    
    TDNoticeInfo *notice = self.dataMuArray[indexPath.row];
    cell.noticeTittle.text = notice.noticeTitle;
    cell.noticeTime.text = notice.noticeIssueDate;
    cell.NoticeContent.text = notice.noticeBody;
    return cell;
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TDNoticeInfoViewController * info = [[TDNoticeInfoViewController alloc]init];
    info.noticeInfo = self.dataMuArray[indexPath.row];
    [self.navigationController pushViewController:info animated:YES];
    
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
