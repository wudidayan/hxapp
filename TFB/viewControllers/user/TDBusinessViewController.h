//
//  TDBusinessViewController.h
//  TFB
//
//  Created by Nothing on 15/3/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDBusinessViewController : TDBaseViewController<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UITableView *bottomTableView;
@property (strong, nonatomic) IBOutlet UILabel *BalanceLabel;


@end
