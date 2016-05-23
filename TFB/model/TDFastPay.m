#import "TDFastPay.h"

@implementation TDFastPay

// bankName        银行列表
// cardNo          银行卡号
// cardCvv         CVV校验值
// cardExpireDate  有效期
// cardSigned      是否签约
// cardSignDate    签约日期
// idNo            身份证号
// mobileNo        手机号
// mobileAuthNo    手机验证码
// txnAmt          交易金额
// payType         支付方式，（0）支付，（1）签约＋支付

- (instancetype)initWithDictionary:(NSDictionary *)dic{

    self = [super init];
    if ( self) {
        self.bankName =  [dic objectForKey:@"bankName"];
        self.cardNo =  [dic objectForKey:@"cardNo"];
        self.cardCvv =  [dic objectForKey:@"cardCvv"];
        self.cardExpireDate =  [dic objectForKey:@"cardExpireDate"];
        self.cardSigned = [[dic objectForKey:@"cardSigned"] integerValue];
        self.cardSignDate = [dic objectForKey:@"cardSignDate"];
        self.idNo = [dic objectForKey:@"idNo"];
        self.mobileNo = [dic objectForKey:@"mobileNo"];
        self.mobileAuthNo = [dic objectForKey:@"mobileAuthNo"];
        self.txnAmt = [dic objectForKey:@"txnAmt"];
        self.payType = [dic objectForKey:@"payType"];
    }
    
    return self;
}

@end
