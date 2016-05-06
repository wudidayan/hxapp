//
//  TDPinKeyInfo.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/7.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDPinKeyInfo : TDBaseModel

@property (nonatomic,strong) NSString * zmakcv;  //MAC校验值
@property (nonatomic,strong) NSString * zmakkey; // MAC密钥
@property (nonatomic,strong) NSString * zpincv;  // PIN校验值
@property (nonatomic,strong) NSString * zpinkey; // PIN  密钥
@property (nonatomic, strong) NSString *termTdk; //磁道秘钥
@property (nonatomic, strong) NSString *termTdkCv;

+ (instancetype)pinKeyDefault;
@end
