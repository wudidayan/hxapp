//
//  TDBankCardInfo.m
//  TFB
//
//  Created by Nothing on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBankCardInfo.h"

@implementation TDBankCardInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        //[self setValuesForKeysWithDictionary:aDic];
        /**
         *  issnam;
         provinceId;
         cityId;
         cardType;
         cardNo;
         CNAPS_CODE;
         issno;
         */
        
        self.issnam = [aDic objectForKey:@"issnam"];
        self.provinceId = [aDic objectForKey:@"provinceId"];
        self.cityId = [aDic objectForKey:@"cityId"];
        self.cardType = [aDic objectForKey:@"cardType"];
        self.cardNo = [aDic objectForKey:@"cardNo"];
        self.CNAPS_CODE = [aDic objectForKey:@"CNAPS_CODE"];
        self.issno = [aDic objectForKey:@"issno"];
        self.cardNoStar = [TDBankCardInfo cardNoStarWithCardNo:self.cardNo];
        self.bankName = [aDic objectForKey:@"bankNames"];
        self.prov = [aDic objectForKey:@"provinceId"];
        self.city = [aDic objectForKey:@"cityId"];
        self.cnapsCode = [aDic objectForKey:@"cnapsCode"];
        self.subBranch = [aDic objectForKey:@"subBranch"];
        self.termNum = [aDic objectForKey:@"termNum"];
    }
    return self;
}

@end
