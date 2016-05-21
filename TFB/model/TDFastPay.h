#import "TDBaseModel.h"

@interface TDFastPay : TDBaseModel

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

@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSString *cardCvv;
@property (nonatomic, strong) NSString *cardExpireDate;
@property (nonatomic, assign) NSInteger cardSigned;
@property (nonatomic, strong) NSString *cardSignDate;
@property (nonatomic, strong) NSString *idNo;
@property (nonatomic, strong) NSString *mobileNo;
@property (nonatomic, strong) NSString *mobileAuthNo;
@property (nonatomic, strong) NSString *txnAmt;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
