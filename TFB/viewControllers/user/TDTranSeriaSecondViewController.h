//
//  TDTranSeriaSecondViewController.h
//  TFB
//
//  Created by YangTao on 15/12/31.
//  Copyright © 2015年 TD. All rights reserved.
//交易成功

#import "TDBaseViewController.h"
#import "UUDatePicker.h"

@interface TDTranSeriaSecondViewController : TDBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMuArray;
@property (assign,nonatomic) BOOL isPhoto;
//@property (nonatomic, strong) NSMutableArray *successArray;
@end
