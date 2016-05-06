//
//  TDBankCardInfo.h
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDBankCardInfo : TDBaseModel


@property (nonatomic, strong) NSString*issnam;
@property (nonatomic, strong) NSString*provinceId;
@property (nonatomic, strong) NSString*cityId;
@property (nonatomic, strong) NSString*cardType;
@property (nonatomic, strong) NSString*cardNo;
@property (nonatomic, strong) NSString*CNAPS_CODE;
@property (nonatomic, strong) NSString*issno;
@property (nonatomic, strong) NSString*termNum;


@property (nonatomic, strong) NSString * cardNoStar;
//审核信息
@property (nonatomic,copy) NSString * cerStatus;

@property (nonatomic,strong) NSString * bankName;
@property (nonatomic,strong) NSString * prov;
@property (nonatomic,strong) NSString * city;
@property (nonatomic,strong) NSString * cnapsCode;
@property (nonatomic,strong) NSString * subBranch;
- (instancetype)initWithDictionary:(NSDictionary *)aDic;

@end
