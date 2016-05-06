//
//  TDNoticeTableViewCell.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/8.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDNoticeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *noticeTime;
@property (strong, nonatomic) IBOutlet UILabel *noticeTittle;
@property (strong, nonatomic) IBOutlet UILabel *NoticeContent;

@end
