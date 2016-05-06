//
//  TDDeviceTableViewCell.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDDeviceListTableViewController.h"
#

@interface TDDeviceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *termTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *termDevNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *pay;
@property (strong, nonatomic) TDTerm * term;
- (IBAction)clickPayButton:(UIButton *)sender;

@property (nonatomic,assign) TDDeviceListTableViewController * delegate;
@end
