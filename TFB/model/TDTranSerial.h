//
//  TDTranSerial.h
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseModel.h"

@interface TDTranSerial : TDBaseModel//交易记录


//PAYTYPE = 02;
//ordamt = 10000;
//ordno = 20150521000000003;
//ordstatus = 02;
//ordtime = 20150521151912;
//ordtype = 01;

@property (nonatomic,strong) NSString * ordamt;
@property (nonatomic,strong) NSString * ordno;
@property (nonatomic,strong) NSString * ordstatus;
@property (nonatomic,strong) NSString * ordtime;
@property (nonatomic,strong) NSString * ordtype;

@property (nonatomic,strong) NSString * ordMessage; 
@property (nonatomic,strong) NSString * prdordMessage;
@property (nonatomic, strong) NSString *Fjname;
@property (nonatomic,strong) NSString * prdordno;

- (instancetype)initWithDictionary:(NSDictionary *)aDic;



@end

@interface TDTranDetailedSerial : TDBaseModel

//FEE = 3;
//PRICE = "<null>";
//TXAMT = 1000;
//amt = 1000;
//custId = 15051500000103;
//custName = "\U90d1\U5f3a";
//fjname = "";
//goodsName = "";
//ordamt = 1000;
//ordstatus = 04;
//ordtime = 20150521155015;
//payCardNo = 6212261001018057353;
//payType = 02;
//picId = "";
//prdordtype = 01;
//rate = "0.39";
//rateType = 1;
//termNo = 2150500000001;
//txamt = 1000;
//收款  +  商品
@property (nonatomic,strong) NSString * FEE;
@property (nonatomic,strong) NSString * PRICE;
@property (nonatomic,strong) NSString * TXAMT;
@property (nonatomic,strong) NSString * amt;
@property (nonatomic,strong) NSString * custId;
@property (nonatomic,strong) NSString * custName;
@property (nonatomic,strong) NSString * fjname;
@property (nonatomic,strong) NSString * goodsName;
@property (nonatomic,strong) NSString * ordamt;
@property (nonatomic,strong) NSString * ordstatus;
@property (nonatomic,strong) NSString * ordtime;
@property (nonatomic,strong) NSString * payCardNo;
@property (nonatomic,strong) NSString * payType;
@property (nonatomic,strong) NSString * picId;
@property (nonatomic,strong) NSString * prdordtype;
@property (nonatomic,strong) NSString * rate;
@property (nonatomic,strong) NSString * rateType;
@property (nonatomic,strong) NSString * termNo;
@property (nonatomic,strong) NSString * txamt;
@property (nonatomic,strong) NSString * cardNoStar;
@property (nonatomic,strong) NSString * payTypeMessage;
@property (nonatomic,strong) NSString * fjpath;
@property (nonatomic,strong) NSString * prdordno;

- (instancetype)initWithDictionary:(NSDictionary *)aDic;
@end


@interface TDTiXianDetailedSerial : TDBaseModel



//cardno = 6214850212463647;
//casDate = 20150521152007;
//casType = 3;
//casordno = 20150521000000065;
//custId = 15051500000103;
//custName = "\U90d1\U5f3a";
//fee = 1;
//netrecAmt = 10999;
//ordamt = "11100.00";
//ordstatus = 00;
//serviceFee = 100;
//sucDate = "";
//提现
@property (nonatomic,strong) NSString * cardno;
@property (nonatomic,strong) NSString * casDate;
@property (nonatomic,strong) NSString * casType;
@property (nonatomic,strong) NSString * casordno;
@property (nonatomic,strong) NSString * custId;
@property (nonatomic,strong) NSString * custName;
@property (nonatomic,strong) NSString * fee;
@property (nonatomic,strong) NSString * netrecAmt;
@property (nonatomic,strong) NSString * ordamt;
@property (nonatomic,strong) NSString * ordstatus;
@property (nonatomic,strong) NSString * serviceFee;
@property (nonatomic,strong) NSString * sucDate;

@property (nonatomic,strong) NSString * casTypeMessage;
@property (nonatomic,strong) NSString * ordstatusMessage;
@property (nonatomic,strong) NSString * prdordno;

- (instancetype)initWithDictionary:(NSDictionary *)aDic;
@end
