//
//  TDBankCardListViewController.h
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDBankCardListViewController : TDBaseViewController<UITableViewDataSource, UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *bankCardTableView;
@property (nonatomic, strong) UITableView *bankCardTableView;
@property (nonatomic, strong) NSMutableArray *dataMuArray;
@end
