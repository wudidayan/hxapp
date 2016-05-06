//
//  TDUser.h
//  TFB
//
//  Created by Nothing on 15/3/21.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"


@interface TDUser : TDBaseModel


@property (nonatomic, strong) NSString *redDot;
@property (nonatomic, strong) NSString *custId;
@property (nonatomic, strong) NSString *custLogin;
@property (nonatomic, strong) NSString *custStatus;
@property (nonatomic, assign) NSNumber *cardNum;
@property (nonatomic, assign) NSNumber *termNum;
@property (nonatomic, strong) NSString *custName;
@property (nonatomic, strong) NSString *cardBundingStatus;
@property (nonatomic, strong) NSString *ideCardAuthError;    //实名认证审核意见
@property (nonatomic, strong) NSString *bankCardAuthError;    //绑定银行卡审核意见


@property (nonatomic, strong) NSString * custLoginStar;

+ (instancetype)defaultUser;
/* 
 status  状态
 type YES 实名认证状态   NO 银行卡绑定状态
 */
+(NSString *)messageTextWithStatus:(NSString *)status andTYPE:(BOOL)type;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
