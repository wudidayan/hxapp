//
//  TDNoticeInfo.h
//  TFB
//
//  Created by Nothing on 15/4/16.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDNoticeInfo : TDBaseModel

//        createDate = "<null>";
//        createUserId = "";
//        noticeBody = "2015.04.20  testing rnn";
//        noticeId = 000000030;
//        noticeIssue = hujinsong;
//        noticeIssueDate = 20150429163812;
//        noticePlatform = 2;
//        noticeTitle = "APP\U7b2c\U4e00\U8f6e\U6d4b\U8bd5";

@property (nonatomic,strong) NSString * noticeId;
@property (nonatomic,strong) NSString * noticeIssue;
@property (nonatomic,strong) NSString * noticeIssueDate;
@property (nonatomic,strong) NSString * noticeTitle;
@property (nonatomic,strong) NSString * noticeBody;
@property (nonatomic,strong) NSString * noticeType;
@property (nonatomic,strong) NSString * noticeText;
- (instancetype)initWithDictionary:(NSDictionary *)aDic;

@end
