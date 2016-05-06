//
//  TDNoticeInfoViewController.m
//  TFB
//
//  Created by Nothing on 15/4/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDNoticeInfoViewController.h"

@interface TDNoticeInfoViewController ()

@end

@implementation TDNoticeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self backButton];
    self.title = @"公告详情";
     self.noticeTime.text = self.noticeInfo.noticeIssueDate;
    self.noticeTittle.text = self.noticeInfo.noticeTitle;
    self.noticeContent.text = self.noticeInfo.noticeBody; 
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
