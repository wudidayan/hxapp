//
//  TDDynamicImg.h
//  TFB
//
//  Created by Nothing on 15/3/31.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDDynamicImg : TDBaseModel

@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *fileDesc;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
