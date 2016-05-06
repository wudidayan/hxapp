//
//  TDTerm.h
//  TFB
//
//  Created by Nothing on 15/4/1.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDTerm : TDBaseModel

@property (nonatomic, strong) NSString *termNo;
@property (nonatomic, strong) NSString *agentId;
@property (nonatomic, strong) NSMutableArray *ratesArray;

@property (nonatomic,strong) NSString * termPayAmt;
@property (nonatomic,strong) NSString * termTypeName;
@property (nonatomic,strong) NSString * termRecipient;
@property (nonatomic,strong) NSString * termPayFlag;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface TDRate : TDBaseModel

@property (nonatomic, strong) NSString *rateDesc;
@property (nonatomic, strong) NSString *rateNo;
@property (nonatomic, strong) NSString *rateMaximun;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end