//
//  TDArae.m
//  TFB
//
//  Created by Nothing on 15/3/23.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDProvince.h"

@implementation TDProvince

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
//        cityList =     (
//                        {
//                            cityId = 110100;
//                            cityName = "\U5317\U4eac";
//                            provId = 110000;
//                        }
//                        );
//        provId = 110000;
//        provName = "\U5317\U4eac";
//    },
        self.provId = [dictionary objectForKey:@"provId"];
        self.provName = [dictionary objectForKey:@"provName"];
        NSArray * cityList = [dictionary objectForKey:@"cityList"];
        if (cityList.count) {
            NSMutableArray * cityArray = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i < cityList.count; i++) {
                NSDictionary * dic = [[dictionary objectForKey:@"cityList"] objectAtIndex:i];
                TDCity * city = [[TDCity alloc]initWithDictionary:dic];
                
                [cityArray addObject:city];
            }
            self.cityDataSourceArr = [NSArray arrayWithArray:cityArray];
        }
    }
    return self;
}
+(NSArray *)userDefaultObjectWithArray:(NSArray *)arr{
   
    NSMutableArray * array =  [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < arr.count; i++) {
        TDProvince * province = [[TDProvince alloc]initWithDictionary:arr[i]];
        [array addObject:province];
    }
    return array;
}
@end

@implementation TDCity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.cityId = [dictionary objectForKey:@"cityId"];
        self.cityName = [dictionary objectForKey:@"cityName"];
    }
    return self;
}

@end


@implementation TDArea

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

@end


