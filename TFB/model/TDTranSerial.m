//
//  TDTranSerial.m
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDTranSerial.h"

@implementation TDTranSerial


- (instancetype)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {


//        @property (nonatomic,strong) NSString * ordamt;
//        @property (nonatomic,strong) NSString * ordno;
//        @property (nonatomic,strong) NSString * ordstatus;
//        @property (nonatomic,strong) NSString * ordtime;
//        @property (nonatomic,strong) NSString * ordtype;
        
        self.ordamt = [aDic objectForKey:@"ordamt"];
        self.ordno = [aDic objectForKey:@"ordno"];
        self.ordstatus = [aDic objectForKey:@"ordstatus"];
        self.ordtime = [aDic objectForKey:@"ordtime"];
        self.ordtype = [aDic objectForKey:@"ordtype"];
        self.prdordno = [aDic objectForKey:@"prdordno"];
        self.payWay = [aDic objectForKey:@"payWay"];
        self.acctType = [aDic objectForKey:@"acctType"];
   
//        @property (nonatomic,strong) NSString * ordMessage;
//        @property (nonatomic,strong) NSString * prdordMessage;
        NSString * ordm = @"";
        NSLog(@"---> %d",self.ordstatus.intValue);
        switch (self.ordstatus.intValue) {

            case 0:  ordm = @"未交易";   break;
            case 1:  ordm = @"交易成功";     break;
            case 2:  ordm = @"交易失败";     break;
            case 3:  ordm = @"可疑";     break;
            case 4:  ordm = @"审核中";   break;
            case 5:  ordm = @"审核拒绝";  break;
            case 6:  ordm = @"未交易";   break;
            case 7:  ordm = @"交易成功";   break;
            case 8:  ordm = @"交易中";   break;
        }
        self.ordMessage =  ordm;
        
        if (1 == self.ordtype.intValue) {
            self.prdordMessage = @"收款";
            if(2 == self.payWay.intValue) {
                self.payTypeMessage = @"刷卡";
            } else if (3 == self.payWay.intValue) {
                self.payTypeMessage = @"快捷";
            } else if (4 == self.payWay.intValue) {
                self.payTypeMessage = @"扫码";
            }
        }else if (2 == self.ordtype.intValue){
            self.prdordMessage  = @"商品";
        }else if (3 == self.ordtype.intValue){
            self.prdordMessage = @"提现";
            if(2 == self.acctType.intValue) {
                self.payTypeMessage = @"刷卡";
            } else if (3 == self.acctType.intValue) {
                self.payTypeMessage = @"快捷";
            } else if (4 == self.acctType.intValue) {
                self.payTypeMessage = @"扫码";
            }
        }
    }
    
    return self;
}



@end

@implementation TDTranDetailedSerial

- (instancetype)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        
//        @property (nonatomic,strong) NSString * FEE;
//        @property (nonatomic,strong) NSString * PRICE;
//        @property (nonatomic,strong) NSString * TXAMT;
//        @property (nonatomic,strong) NSString * amt;
//        @property (nonatomic,strong) NSString * custId;
//        @property (nonatomic,strong) NSString * custName;
//        @property (nonatomic,strong) NSString * fjname;
//        @property (nonatomic,strong) NSString * goodsName;
//        @property (nonatomic,strong) NSString * ordamt;
//        @property (nonatomic,strong) NSString * ordstatus;
//        @property (nonatomic,strong) NSString * ordtime;
//        @property (nonatomic,strong) NSString * payCardNo;
//        @property (nonatomic,strong) NSString * payType;
//        @property (nonatomic,strong) NSString * picId;
//        @property (nonatomic,strong) NSString * prdordtype;
//        @property (nonatomic,strong) NSString * rate;
//        @property (nonatomic,strong) NSString * rateType;
//        @property (nonatomic,strong) NSString * termNo;
//        @property (nonatomic,strong) NSString * txamt;
        self.FEE = [aDic objectForKey:@"FEE"];
        self.PRICE = [aDic objectForKey:@"PRICE"]?[aDic objectForKey:@"PRICE"]:@"";
        self.TXAMT = [aDic objectForKey:@"TXAMT"];
        self.amt = [aDic objectForKey:@"amt"];
        self.custId = [aDic objectForKey:@"custId"];
        self.custName = [aDic objectForKey:@"custName"];
        self.fjname = [aDic objectForKey:@"fjname"];
        self.goodsName = [aDic objectForKey:@"goodsName"];
        self.ordamt = [aDic objectForKey:@"ordamt"];
        self.ordstatus = [aDic objectForKey:@"ordstatus"];
        self.ordtime = [TDTranDetailedSerial dataChangeWithString:[aDic objectForKey:@"ordtime"]];
        self.payCardNo = [aDic objectForKey:@"payCardNo"];
        self.payType = [aDic objectForKey:@"payType"];
        self.picId = [aDic objectForKey:@"picId"];
        self.prdordtype = [aDic objectForKey:@"prdordtype"];
        self.rate = [aDic objectForKey:@"rate"];
        self.rateType = [aDic objectForKey:@"rateType"];
        self.termNo = [aDic objectForKey:@"termNo"];
        self.txamt = [aDic objectForKey:@"txamt"];
        self.fjpath = [aDic objectForKey:@"fjpath"];
        self.cardNoStar = [TDTranDetailedSerial cardNoStarWithCardNo:self.payCardNo];
        self.prdordno = [aDic objectForKey:@"prdordno"];
        self.acctType = [aDic objectForKey:@"acctType"];
        self.payTypeMessage = [aDic objectForKey:@"payTypeMessage"];
        self.ordstatusMessage = [aDic objectForKey:@"ordstatus"];
        
        if (1 == self.payType.intValue) {
            self.payTypeMessage = @"支付账户";
        }else if (2 == self.payType.intValue){
            self.payTypeMessage  = @"终端刷卡";
        }else if (3 == self.payType.intValue){
            self.payTypeMessage = @"快捷支付";
        }else if (4 == self.payType.intValue){
            self.payTypeMessage = @"扫码支付";
        }

        if (1 == self.acctType.intValue) {
            self.payTypeMessage = @"合并提现";
        }else if (2 == self.acctType.intValue){
            self.payTypeMessage  = @"终端账户";
        }else if (3 == self.acctType.intValue){
            self.payTypeMessage = @"快捷账户";
        }else if (4 == self.acctType.intValue){
            self.payTypeMessage = @"扫码账户";
        }
        
        if (0 == self.ordstatus.intValue) {
            self.ordstatusMessage = @"未处理";
        } else if (1 == self.ordstatus.intValue){
            self.ordstatusMessage  = @"成功";
        } else if (2 == self.ordstatus.intValue){
            self.ordstatusMessage = @"失败";
        } else if (3 == self.ordstatus.intValue){
            self.ordstatusMessage  = @"可疑";
        } else if (4 == self.ordstatus.intValue){
            self.ordstatusMessage = @"处理中";
        } else if (5 == self.ordstatus.intValue){
            self.ordstatusMessage = @"已取消";
        }
    }
    return self;
}

@end

@implementation TDTiXianDetailedSerial

- (instancetype)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        
//        @property (nonatomic,strong) NSString * cardno;
//        @property (nonatomic,strong) NSString * casDate;
//        @property (nonatomic,strong) NSString * casType;
//        @property (nonatomic,strong) NSString * casordno;
//        @property (nonatomic,strong) NSString * custId;
//        @property (nonatomic,strong) NSString * custName;
//        @property (nonatomic,strong) NSString * fee;
//        @property (nonatomic,strong) NSString * netrecAmt;
//        @property (nonatomic,strong) NSString * ordstatus;
//        @property (nonatomic,strong) NSString * serviceFee;
//        @property (nonatomic,strong) NSString * sucDate;
        
        self.cardno = [TDTiXianDetailedSerial cardNoStarWithCardNo:[aDic objectForKey:@"cardno"]];
        self.casDate = [TDTiXianDetailedSerial dataChangeWithString:[aDic objectForKey:@"casDate"]];
        self.casType = [aDic objectForKey:@"casType"];
        self.casordno = [aDic objectForKey:@"casordno"];
        self.custId = [aDic objectForKey:@"custId"];
        self.custName = [aDic objectForKey:@"custName"];
        self.fee = [aDic objectForKey:@"fee"];
        self.netrecAmt = [aDic objectForKey:@"netrecAmt"];
        self.ordstatus = [aDic objectForKey:@"ordstatus"];
        self.serviceFee = [aDic objectForKey:@"serviceFee"];
        self.sucDate = [TDTiXianDetailedSerial dataChangeWithString:[aDic objectForKey:@"sucDate"]];;
        self.ordamt = [aDic objectForKey:@"ordamt"];
        self.prdordno = [aDic objectForKey:@"prdordno"];
        self.acctType = [aDic objectForKey:@"acctType"];
        
        if (0 == self.casType.intValue) {
            self.casTypeMessage = @" T0 提现";
        }else if (1 == self.casType.intValue){
            self.casTypeMessage  = @" T1 提现";
        }else if (2 == self.casType.intValue){
            self.casTypeMessage = @"T0 + T1 提现";
        }

        if (1 == self.acctType.intValue) {
            self.payTypeMessage = @"合并提现";
        } else if (2 == self.acctType.intValue){
            self.payTypeMessage  = @"刷卡账户";
        } else if (3 == self.acctType.intValue){
            self.payTypeMessage = @"快捷账户";
        } else if (4 == self.acctType.intValue){
            self.payTypeMessage = @"扫码账户";
        } else {
            self.payTypeMessage = @"";
        }
        
        if (0 == self.ordstatus.intValue) {
            self.ordstatusMessage = @"未处理";
        } else if (1 == self.ordstatus.intValue){
            self.ordstatusMessage  = @"成功";
        } else if (2 == self.ordstatus.intValue){
            self.ordstatusMessage = @"失败";
        } else if (3 == self.ordstatus.intValue){
            self.ordstatusMessage  = @"可疑";
        } else if (4 == self.ordstatus.intValue){
            self.ordstatusMessage = @"处理中";
        } else if (5 == self.ordstatus.intValue){
            self.ordstatusMessage = @"已取消";
        }
    }
    return self;
}

@end