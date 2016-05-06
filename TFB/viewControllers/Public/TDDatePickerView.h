//
//  TDDatePickerView.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFenRunViewController.h"
@interface TDDatePickerView : UIView


- (IBAction)clickActionButton:(UIButton *)sender;
- (IBAction)clickBackButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *tittleContextLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *myDatePicker;

@property (nonatomic,strong) NSString * startDateString;
@property (nonatomic,strong) NSString * endDataString;
@property (nonatomic,strong) NSDate * startDate;
@property (nonatomic,assign) BOOL isRemove;
@property (nonatomic,assign) TDFenRunViewController * cv;
@end
