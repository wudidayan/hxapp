//
//  TDNoticeInfo.m
//  TFB
//
//  Created by Nothing on 15/4/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDNoticeInfo.h"

@implementation TDNoticeInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        //[self setValuesForKeysWithDictionary:aDic];

//        createDate = "<null>";
//        createUserId = "";
//        noticeBody = "2015.04.20  testing rnn";
//        noticeId = 000000030;
//        noticeIssue = hujinsong;
//        noticeIssueDate = 20150429163812;
//        noticePlatform = 2;
//        noticeTitle = "APP\U7b2c\U4e00\U8f6e\U6d4b\U8bd5";
      
//        @property (nonatomic,strong) NSString * noticeId;
//        @property (nonatomic,strong) NSString * noticeIssue;
//        @property (nonatomic,strong) NSString * noticeIssueDate;
//        @property (nonatomic,strong) NSString * noticeTitle;
//        @property (nonatomic,strong) NSString * noticeBody;
        
        self.noticeId = [aDic objectForKey:@"noticeId"];
        self.noticeIssue = [aDic objectForKey:@"noticeIssue"];
        
        self.noticeIssueDate = [TDBalanceInfo dataChangeWithString:[aDic objectForKey:@"noticeIssueDate"]];
        self.noticeTitle = [aDic objectForKey:@"noticeTitle"];
        self.noticeBody = [aDic objectForKey:@"noticeBody"];
        self.noticeType = [aDic objectForKey:@"noticeType"];
        self.noticeText = [aDic objectForKey:@"noticeText"];
        
        
    }
    return self;
}

@end
