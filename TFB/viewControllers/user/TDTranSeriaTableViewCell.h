//
//  TDTranSeriaTableViewCell.h
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTranSeriaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *busTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tranAmtLabel;

@end
