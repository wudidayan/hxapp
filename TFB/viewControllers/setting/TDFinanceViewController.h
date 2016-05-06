//
//  TDFinanceViewController.h
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDFinanceViewController : TDBaseViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)ClickOutLogin:(UIButton *)sender;

@end
