#import "TDScanCode.h"

@implementation TDScanCode

// txnAmt          交易金额
// prdordNo        订单号
// payData         二维码数据
// payResult       支付结果 S成功 F失败 U支付中
// payResultMsg    支付结果描述

- (instancetype)initWithDictionary:(NSDictionary *)dic{

    self = [super init];
    if (self) {
        self.txnAmt = [dic objectForKey:@"prdordAmt"];
        self.prdordNo = [dic objectForKey:@"prdordNo"];
        self.payData = [dic objectForKey:@"payData"];
        self.payResult = [dic objectForKey:@"payResult"];
        self.payResultMsg = [dic objectForKey:@"payResultMsg"];
    }
    
    return self;
}

@end
