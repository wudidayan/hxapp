//
//  TDTixianSerialViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/6/5.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDTranSerial.h"

@interface TDTixianSerialViewController : TDBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) TDTranSerial * tranSerial;
@property (strong, nonatomic) IBOutlet UILabel *tittleLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
