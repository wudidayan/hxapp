//
//  TDBindTYViewController.h
//  TFB
//
//  Created by YangTao on 16/4/12.
//  Copyright © 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"

@interface TDBindTYViewController : TDBaseViewController

@property (nonatomic, strong)NSString *termName;

@property (weak, nonatomic) IBOutlet UILabel *termNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *termTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *termCsnLabel;

- (IBAction)bindBtnClick:(id)sender;

@end
