//
//  TDNoticeInfoViewController.h
//  TFB
//
//  Created by Nothing on 15/4/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDNoticeInfo.h"

@interface TDNoticeInfoViewController : TDBaseViewController

@property (nonatomic, strong) TDNoticeInfo *noticeInfo;
@property (strong, nonatomic) IBOutlet UILabel *noticeTittle;
@property (strong, nonatomic) IBOutlet UITextView *noticeContent;
@property (strong, nonatomic) IBOutlet UILabel *noticeTime;

@end
