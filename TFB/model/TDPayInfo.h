//
//  TDPayInfo.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"
#import "TDTerm.h"
@interface TDPayInfo : TDBaseModel
/*
*  @param payType    支付方式
*  @param payType    订单类型
*  @param rate       费率类型
*  @param termNo     终端号
*  @param termType   终端类型
*  @param payAmt     交易金额
*  @param track      磁道信息
*  @param pinblk     密码密文
*  @param random     随机数     C		音频设备时使用
*  @param mediaType  介质类型   C		01 刷卡 02 插卡
*  @param period     有效期     C		mediaType 02时必填
*  @param icdata     55域      C		mediaType 02时必填
*  @param crdnum     卡片序列号  C		mediaType 02时必填
*  @param mac        Mac       C		设备计算的mac
                    ctype     付款类型 TO  TI  
*  @param complete   block回传
 */
@property (nonatomic,strong) NSString * payType;
@property (nonatomic,strong) NSString * prdordType;
@property (nonatomic,strong) NSString * rate;
@property (nonatomic,strong) TDTerm * termInfo;
@property (nonatomic,strong) NSString * termType;
@property (nonatomic,strong) NSString * payAmt;
@property (nonatomic,strong) NSString * track;
@property (nonatomic,strong) NSString * pinblk;
@property (nonatomic,strong) NSString * random;
@property (nonatomic,strong) NSString * mediaType;
@property (nonatomic,strong) NSString * period;
@property (nonatomic,strong) NSString * icdata;
@property (nonatomic,strong) NSString * crdnum;
@property (nonatomic,strong) NSString * mac;
@property (nonatomic,strong) NSString * ctype;

@property(nonatomic,strong)  NSString *ksn;



@property (nonatomic,strong) NSString * subPayType;  //下单的时候 子业务类型

@property (nonatomic,strong) NSString * prdordNo; //订单号
@property (nonatomic,strong) NSString * bankCradNum;  //卡号  -> 中间*替代
@property (nonatomic,strong) NSString * bankCardNumber; //卡号 不带*


//单利 (为了保证每次刷卡该对象已被初始化 干脆不用单利)
//-(TDPayInfo *)sharePayDefault;
//刷卡器参数传入
-(void)SwipeWithDictionary:(NSDictionary *)dic;

@end
