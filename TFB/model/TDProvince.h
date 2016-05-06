//
//  TDArae.h
//  TFB
//
//  Created by Nothing on 15/3/23.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDProvince : TDBaseModel

@property (nonatomic, strong) NSString *provId;
@property (nonatomic, strong) NSString *provName;
@property (nonatomic, strong) NSArray * cityDataSourceArr;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)userDefaultObjectWithArray:(NSArray *)arr;
@end


@interface TDCity : NSObject

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface TDArea : TDBaseModel

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
