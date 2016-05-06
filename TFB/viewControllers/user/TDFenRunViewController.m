//
//  TDFenRunViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/12.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDFenRunViewController.h"
#import "MJRefresh.h"
#import "TDFenRunTableViewCell.h"
#import "TDDatePickerView.h"
#import "TDFenRunInfo.h"

#define DATANUMBER  @"10"
@interface TDFenRunViewController (){

    UIView * _bgView;
    UIDatePicker * _datePicker;
    NSString * _startPage;
    NSString * _pageSize;
    NSString * _StartDateS;
    NSString * _EndDateS;
    BOOL * _isHeader;
}

@property (nonatomic,strong) UITableView * myTabeView;
@property (nonatomic,strong) NSMutableArray * dataSourceArr;



@end

@implementation TDFenRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backButton];
    self.title =  @"分润查询";
    _dataSourceArr = [NSMutableArray arrayWithCapacity:5];
    _myTabeView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_myTabeView];
    _myTabeView.delegate = self;
    _myTabeView.dataSource = self;
    _myTabeView.tableFooterView = [UIView new];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"日期" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
     self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    _startPage = @"0";
    _pageSize = DATANUMBER;
    _StartDateS = @"";
    _EndDateS = @"";
    __weak typeof(self)weakSelf = self;
    [_myTabeView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf upLoadFenRunWhthUp:YES];
    }];
    [_myTabeView addLegendFooterWithRefreshingBlock:^{
        [weakSelf upLoadFenRunWhthUp:NO];
    }];
    
}
-(void)clickRightButton{
   

       _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_bgView];
        _bgView.alpha = 0.4f;
        _bgView.backgroundColor =  [UIColor blackColor];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
   
    [self createPicker];
    
}
-(void)createPicker{
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    TDDatePickerView * dataPView = [[[NSBundle mainBundle]loadNibNamed:@"TDDatePickerView" owner:self options:nil]firstObject];
    [self.view addSubview:dataPView];
    dataPView.myDatePicker.datePickerMode = UIDatePickerModeDate;
    dataPView.myDatePicker.locale =  locale;
    dataPView.tittleContextLabel.text =  @"开始时间";
    dataPView.cv = self;
 
}
-(void)clickPicker:(TDDatePickerView *)pic{
    _startPage = @"0";
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    if (pic) {
        _StartDateS = pic.startDateString;
        _EndDateS = pic.endDataString;
        [_myTabeView.header beginRefreshing];
    }

    [pic removeFromSuperview];
    [_bgView removeFromSuperview];
}




-(void)upLoadFenRunWhthUp:(BOOL)up{
    
    if (!up) {
        if(_dataSourceArr.count < [DATANUMBER intValue]){
            
        [self.view makeToast:@"无更多分润纪录了,亲" duration:2.0f position:@"center"];
        [_myTabeView.footer endRefreshing];
            return;
        }else{
            _startPage = [NSString stringWithFormat:@"%d",_startPage.intValue + [DATANUMBER intValue]];
        
        }
        
    }
   [TDHttpEngine requestGetProfitInfoWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin andStart:_startPage andPageSize:_pageSize profitStartDate:_StartDateS profitEndDate:_EndDateS complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *tempArray) {
       self.navigationController.navigationBar.userInteractionEnabled = YES;
       if (up) {
           [_myTabeView.header endRefreshing];
       }else{
            [_myTabeView.footer endRefreshing];
       }
       
       if (tempArray) {
           [_dataSourceArr removeAllObjects];
           [_dataSourceArr addObjectsFromArray:tempArray];
           [_myTabeView reloadData];
       }
       
   }];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myTabeView.header beginRefreshing];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 57.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TDFenRunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FunRunCell"];
    if (!cell) {
        cell =  (TDFenRunTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"TDFenRunTableViewCell" owner:self options:nil] firstObject];
    }
    TDFenRunInfo * info = [_dataSourceArr objectAtIndex:indexPath.row];
    NSString * date = [NSString stringWithFormat:@"%ld",(long)info.profitDate];
    NSString * dateString = [NSString stringWithFormat:@"%@-%@-%@",[date substringToIndex:4],[date substringWithRange:(NSRange){4,2}],[date substringFromIndex:date.length-2]];
    cell.dateLabel.text = dateString;
    cell.contextLabel.text = [NSString stringWithFormat:@"管理分润:%@ 元",info.mngAmt];
    cell.contextTwoLabel.text = [NSString stringWithFormat:@"交易分润:%@ 元",info.txnAmt];
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
