//
//  TDDeviceListTableViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTerm.h"
@interface TDDeviceListTableViewController : UITableViewController<UIActionSheetDelegate>
-(void)clickPayButtonWithTerm:(TDTerm *)term;
@end
