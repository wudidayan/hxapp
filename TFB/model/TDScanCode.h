#import "TDBaseModel.h"

@interface TDScanCode : TDBaseModel

// txnAmt          交易金额
// prdordNo        订单号
// payData         二维码数据
// payResult       支付结果 S成功 F失败 U支付中
// payResultMsg    支付结果描述

@property (nonatomic, strong) NSString *txnAmt;
@property (nonatomic, strong) NSString *prdordNo;
@property (nonatomic, strong) NSString *payData;
@property (nonatomic, strong) NSString *payResult;
@property (nonatomic, strong) NSString *payResultMsg;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
