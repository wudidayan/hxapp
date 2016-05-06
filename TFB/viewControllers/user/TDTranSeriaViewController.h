//
//  TDTranSeriaViewController.h
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//未交易成功

#import "TDBaseViewController.h"
#import "UUDatePicker.h"


@interface TDTranSeriaViewController : TDBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMuArray;
@property (assign,nonatomic) BOOL isPhoto;
//@property (nonatomic, strong) NSMutableArray *successArray;
@end
