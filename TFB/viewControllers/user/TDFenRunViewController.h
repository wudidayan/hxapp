//
//  TDFenRunViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/12.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
@class TDDatePickerView;

@interface TDFenRunViewController : TDBaseViewController<UITableViewDataSource,UITableViewDelegate>

-(void)clickPicker:(TDDatePickerView *)pic;

@end
