//
//  TDTranSeriaViewController.m
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDTranSeriaViewController.h"
#import "TDTranSeriaTableViewCell.h"
#import "TDTranSeriaInfoViewController.h"
#import "TDTranSerial.h"
#import "MJRefresh.h"
#import "REMenu.h"
#import "TDTixianSerialViewController.h"
#import "TDNewTranSeriaInfoViewController.h"

@interface TDTranSeriaViewController ()
{
    int page;
    NSString * _tranMeString;
    UIView *timeView;
    UILabel *labelTitle;
    UILabel *labelStartTime;
    UILabel *labelEndTime;
    UIButton *startBtn;
    UIButton *endBtn;
    UIButton *sure;
    UIButton *exit;
}

@property (strong, nonatomic) REMenu *menu;

@end

@implementation TDTranSeriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPhoto = YES;
    self.title = @"全部记录";
    _tranMeString = @"00";// 00：所有，01：收款,02:消费,03:提现
    /*
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    */
    
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more_top"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.dataMuArray = [[NSMutableArray alloc] init];
    //交易未成功存放的数组
//    self.successArray = [[NSMutableArray alloc] init];
    [self backButton];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf downPull];
    }];

    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf upPull];
    }];

    [self.tableView.header setFont:[UIFont systemFontOfSize:12.0f]];
    [self.tableView.header setTextColor:[UIColor colorWithRed:154/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    [self.tableView.header beginRefreshing];

    [self.tableView reloadData];

}
- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"全部"
                                                    subtitle:@"所有交易记录"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          _tranMeString = @"00";
                                                          self.title =  @"全部记录";
                                                          [self updataRecord];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"收款"
                                                       subtitle:@"收款交易记录"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                            _tranMeString = @"01";
                                                            self.title =  @"收款记录";
                                                             [self updataRecord];
                                                         }];
 /*
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"消费"
                                                        subtitle:@"消费交易记录"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              _tranMeString = @"02";
                                                              self.title =  @"消费记录";
                                                              [self updataRecord];
                                                          }];
*/
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"提现"
                                                        subtitle:@"提现交易记录"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              _tranMeString = @"03";
                                                              self.title =  @"提现记录";
                                                              [self updataRecord];
                                                          }];
    REMenuItem *timeItem = [[REMenuItem alloc] initWithTitle:@"时间"
                                                       subtitle:@"时间查询记录"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             _tranMeString = @"00";
                                                             self.title =  @"时间查询";
                                                             [self updataTimeRecord];
                                                         }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    //activityItem.tag = 2;
    profileItem.tag = 3;
    timeItem.tag = 4;
    
    //_menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem,timeItem]];
    _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, profileItem,timeItem]];
    _menu.cornerRadius = 5;
    _menu.shadowColor = [UIColor blackColor];
    _menu.font = [UIFont systemFontOfSize:14.0f];
    _menu.subtitleFont = [UIFont systemFontOfSize:12.0f];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}
//时间查询
-(void)updataTimeRecord{
    timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
    timeView.backgroundColor = [UIColor whiteColor];
    
    startBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 140, 30)];
    startBtn.backgroundColor = [UIColor darkGrayColor];
    [startBtn setTitle:@"请选择开始时间" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];

    labelStartTime = [[UILabel alloc]initWithFrame:CGRectMake(170, 20, 140, 30)];
    labelStartTime.text = @"开始时间";
    
    endBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 70, 140, 30)];
    endBtn.backgroundColor = [UIColor darkGrayColor];
    [endBtn setTitle:@"请选择结束时间" forState:UIControlStateNormal];
    [endBtn addTarget:self action:@selector(endBtn:) forControlEvents:UIControlEventTouchUpInside];

    labelEndTime = [[UILabel alloc]initWithFrame:CGRectMake(170, 70, 140, 30)];
    labelEndTime.text = @"结束时间";
    
    sure = [[UIButton alloc]initWithFrame:CGRectMake(10, 120, 140, 30)];
    sure.backgroundColor = [UIColor darkGrayColor];
    [sure setTitle:@"确认" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    
    exit = [[UIButton alloc]initWithFrame:CGRectMake(170, 120, 140, 30)];
    exit.backgroundColor = [UIColor darkGrayColor];
    [exit setTitle:@"取消" forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    
    [timeView addSubview:startBtn];
    [timeView addSubview:endBtn];
    [timeView addSubview:sure];
    [timeView addSubview:exit];
    [timeView addSubview:labelStartTime];
    [timeView addSubview:labelEndTime];
    [self.view addSubview:timeView];
    
}
-(void)exit:(UIButton *)sender
{
    [timeView removeFromSuperview];
}
-(void)startBtn:(UIButton *)sender
{
    CGRect _rect = CGRectMake(0, -5, self.view.frame.size.width, self.view.frame.size.height);
    
    UUDatePicker* picker = [[UUDatePicker alloc] initWithframe:_rect PickerStyle:UUDateStyle_YearMonthDayHourMinuteSecond didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *second, NSString *weekDay) {
        
        NSString* date = [NSString stringWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,second];
        labelStartTime.text = date;
        NSLog(@"date = %@",date);
        
    }];
    [self.view addSubview:picker];
}
-(void)endBtn:(UIButton *)sender
{
    CGRect _rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UUDatePicker* picker = [[UUDatePicker alloc] initWithframe:_rect PickerStyle:UUDateStyle_YearMonthDayHourMinuteSecond didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *second, NSString *weekDay) {
        
        NSString* date = [NSString stringWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,second];
        labelEndTime.text = date;
        NSLog(@"date = %@",date);
        
    }];
    [self.view addSubview:picker];
}
-(void)sure:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *start = [dateFormatter dateFromString:labelStartTime.text];
    NSDate *end = [dateFormatter dateFromString:labelEndTime.text];
    
    NSDate *earlyDate = [start earlierDate:end];
    NSLog(@"%@",earlyDate);
    
    if ([earlyDate isEqual:start]) {

        [self.dataMuArray removeAllObjects];
//        [self.successArray removeAllObjects];
        page = 0;
        /*
         *  交易记录
         *
         *  @param custId     商户id
         *  @param custMobile 商户手机号
         *  @param busType    业务类型 N	 00：所有，01：收款,02:消费,03:提现
         *  @param payWay     支付方式 Y	 01 支付账户，02 终端，03 快捷支付
         *  @param tranState  交易状态 Y	 0：失败，1：成功，2：退货
         *  @param startTime  交易开始时间	 Y	开始时间要小于结束时间
         *  @param endTime    交易结束时间	 Y	结束时间要大于开始时间
         *  @param start      开始取记录的行号
         *  @param pageSize   要取出记录数
         *  @param complete   block回传
         */
        NSString *pageStr = [NSString stringWithFormat:@"%d", page];
        [TDHttpEngine requestForGetTranSerialListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin busType:_tranMeString payWay:@"" tranState:@"" startTime:labelStartTime.text endTime:labelEndTime.text startLineNum:pageStr pageSize:@"15" recordType:@"2" complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
            [self.tableView.header endRefreshing];
            if (succeed) {
                NSLog(@"shuju: %@", temArray);
                if (temArray.count == 0) {
                    [self.view makeToast:@"无交易记录" duration:2.0f position:@"center"];
                    //return;
                }
                [self.dataMuArray addObjectsFromArray:temArray];
                
                [self.tableView reloadData];
            }
            else{
                [self.view makeToast:msg duration:2.0f position:@"center"];
            }
        }];
        
    }else
    {
        [self.view makeToast:@"结束时间应大于开始时间" duration:2.0f position:@"center"];
    }
    [timeView removeFromSuperview];
}

-(void)updataRecord{

    [self downPull];
}

- (void)downPull
{
    [self.dataMuArray removeAllObjects];
//    [self.successArray removeAllObjects];
    page = 0;
    /*
     *  交易记录
     *
     *  @param custId     商户id
     *  @param custMobile 商户手机号
     *  @param busType    业务类型 N	 00：所有，01：收款,02:消费,03:提现
     *  @param payWay     支付方式 Y	 01 支付账户，02 终端，03 快捷支付
     *  @param tranState  交易状态 Y	 0：失败，1：成功，2：退货
     *  @param startTime  交易开始时间	 Y	开始时间要小于结束时间
     *  @param endTime    交易结束时间	 Y	结束时间要大于开始时间
     *  @param start      开始取记录的行号
     *  @param pageSize   要取出记录数
     *  @param complete   block回传
    */
    
    NSString *pageStr = [NSString stringWithFormat:@"%d", page];
    [TDHttpEngine requestForGetTranSerialListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin busType:_tranMeString payWay:@"" tranState:@"" startTime:@"" endTime:@"" startLineNum:pageStr pageSize:@"15" recordType:@"2" complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
        [self.tableView.header endRefreshing];
        if (succeed) {
            NSLog(@"shuju: %@", temArray);
            if (temArray.count == 0) {
                [self.view makeToast:@"无交易记录" duration:2.0f position:@"center"];
                //return;
            }
            [self.dataMuArray addObjectsFromArray:temArray];
            
            [self.tableView reloadData];
        }
        else{
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];

}

- (void)upPull
{
    
//    NSLog(@"%lu",(unsigned long)self.successArray.count);
    if (self.dataMuArray.count < 15) {
        [self.tableView.footer endRefreshing];
    }else{
        page += 15;
        if (self.dataMuArray.count == 0) {
            page = 0;
        }
        
        NSString *pageStr = [NSString stringWithFormat:@"%d", page];
        [TDHttpEngine requestForGetTranSerialListWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin busType:_tranMeString payWay:@"" tranState:@"" startTime:@"" endTime:@"" startLineNum:pageStr pageSize:@"15" recordType:@"2" complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray) {
            [self.tableView.footer endRefreshing];
            if (temArray.count == 0) {
                [self.view makeToast:@"无更多数据" duration:2.0f position:@"center"];
                return;
            }
            for (TDTranSerial *tranSerial in temArray) {
//                if (![tranSerial.ordMessage isEqualToString:@"交易成功"]) {
//                    [self.successArray addObject:tranSerial];
//                }
                [self.dataMuArray addObject:tranSerial];
            }
            
            [self.tableView reloadData];
        }];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 30;
    
//    for (int i = 0; i < self.dataMuArray.count; i++) {
//        TDTranSerial *tranSerial = self.dataMuArray[i];
//        if (![tranSerial.ordMessage isEqualToString:@"交易成功"]) {
//            [self.successArray addObject:tranSerial];
//        }
//    }
    
    return self.dataMuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndefi = @"cellIndefi";
    TDTranSeriaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndefi];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TDTranSeriaTableViewCell" owner:nil options:nil]firstObject];
    }
    
//  NSLog(@"%d",self.successArray.count);
    TDTranSerial *tranSerial = self.dataMuArray[indexPath.row];
    cell.busTypeLabel.text = tranSerial.prdordMessage;
//    cell.timeLabel.text = tranSerial.ordtime;
    cell.timeLabel.text = [TDBaseModel dataChangeWithString: tranSerial.ordtime];
    cell.stateLabel.text = tranSerial.ordMessage ;
    cell.tranAmtLabel.text = [NSString stringWithFormat:@"%.2f",tranSerial.ordamt.floatValue/100];
    cell.cardNoLabel.text = tranSerial.payTypeMessage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TDTranSerial * tranSerial = self.dataMuArray[indexPath.row];
    if (3 == tranSerial.ordtype.intValue) {
        TDTixianSerialViewController * tixian =  [[TDTixianSerialViewController alloc]init];
        tixian.tranSerial = tranSerial;
        [self.navigationController pushViewController:tixian animated:YES];
    }else{
//        TDTranSeriaInfoViewController *infoVC = [[TDTranSeriaInfoViewController alloc] init];
//        infoVC.tranSerial = tranSerial;
//        [self.navigationController pushViewController:infoVC animated:YES];
        
        
        if (![tranSerial.ordstatus isEqualToString:@"01"]) {
            
            [self.view makeToast:[NSString stringWithFormat:@"该订单%@,无法查看电子小票", tranSerial.ordMessage] duration:2.f position:@"center"];
        }
        else {
            TDNewTranSeriaInfoViewController *infoVC = [[TDNewTranSeriaInfoViewController alloc] init];
            infoVC.tranSerial = tranSerial;
            infoVC.isPhoto = _isPhoto;
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
        
    }
}

@end
