//
//  TDDeviceTableViewCell.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDDeviceTableViewCell.h"

@implementation TDDeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickPayButton:(UIButton *)sender {
    
    [_delegate clickPayButtonWithTerm:self.term];
}
@end
