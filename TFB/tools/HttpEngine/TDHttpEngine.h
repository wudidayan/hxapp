//
//  TDHttpEngine.h
//  TFB
//
//  Created by Nothing on 15/3/20.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"
#import "TDUser.h"
#import "TDBalanceInfo.h"
#import "TDPinKeyInfo.h"
#import "TDHttpManager.h"


@interface TDHttpEngine : NSObject

//初始化网络引擎
+ (instancetype)shareHttpEngine;



/**
 *  发送验证码
 *
 *  @param custMobile 手机号
 *  @param codeType   验证码类型 
 *  @param complete   block回传
 */
+ (void)requestForGetMsgCodeWithCustMobile:(NSString *)custMobile codeType:(NSString *)codeType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;

/**
 *  验证验证码
 *
 *  @param custMobile 手机号
 *  @param codeType   验证码类型
 *  @param msgCode    验证码
 *  @param complete   block回传
 */
+ (void)requestForVerifyMsgCodeWithCustMobile:(NSString *)custMobile codeType:(NSString *)codeType msgCode:(NSString *)msgCode complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;

/**
 *  注册
 *
 *  @param custMobile      手机号
 *  @param custPwd         登录密码
 *  @param referrer        推荐码
 *  @param complete        block回传
 */
+ (void)requestForRegistWithCustMobile:(NSString *)custMobile custPwd:(NSString *)custPwd referrer:(NSString *)referrer complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;


/**
 *  登录
 *
 *  @param CustMobile 手机号
 *  @param custPwd    登录密码
 *  @param complete   block回传
 */
+ (void)requestForLoginWithCustMobile:(NSString *)custMobile custPwd:(NSString *)custPwd complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;

/**
 *  银行名称列表查询
 *
 *  @param custId
 *  @param custMobile
 *  @param bankProId  省ID
 *  @param bankCityId 市ID
 *  @param complete
 */
+(void)requestGetBankNamecustId:(NSString *)custId custMobile:(NSString *)custMobile bankProId:(NSString *)bankProId bankCityId:(NSString *)bankCityId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSArray * bankList))complete;

/**
 *  支行名称列表查询
 *
 *  @param custId
 *  @param custMobile
 *  @param bankProId  省ID
 *  @param bankCityId 市ID
 *  @param bankName   银行名称
 *  @param complete
 */
+(void)requestGetBankListNameCustId:(NSString *)custId custMobile:(NSString *)custMobile bankProId:(NSString *)bankProId bankCityId:(NSString *)bankCityId bankName:(NSString *)bankName categories:(NSString *)categories complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSArray * bankList))complete;
/**
 *  商户信息查询
 *
 *  @param custMobile 手机号
 *  @param custId     商户id
 *  @param complete   block回传
 */
+ (void)requestForGetCustInfWithCustMobile:(NSString *)custMobile custId:(NSString *)custId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, TDUser *user))complete;


/**
 *  商户密码修改与找回
 *
 *  @param pwdType    修改的密码类型	N		密码类型：1-登录密码；2-支付密码
 *  @param updateType 修改方式	N		1：根据原密码修改；2：根据短信验证码找回
 *  @param value      短信验证码或原始密码	N
 *  @param newPwd     新密码	N
 *  @param custMobile 手机号	N
 *  @param complete   block回传
 */
+ (void)requestForUpdatePwdWithPwdType:(NSString *)pwdType updateType:(NSString *)updateType value:(NSString *)value newPwd:(NSString *)newPwd custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;


/**
 *  商户实名认证
 *
 *  @param cardHandheld 手持身份证照片	N
 *  @param cardFront    身份证正面照片	N
 *  @param cardBack     身份证背面照片	N
 *  @param custId       商户编号	N
 *  @param complete     block回传
 */
+ (void)requestForCertificationWithCardHandheld:(NSString *)cardHandheld cardFront:(NSString *)cardFront cardBack:(NSString *)cardBack custId:(NSString *)custId custMobile:(NSString *)custMobile custName:(NSString *)custName certificateType:(NSString *)certificateType certificateNo:(NSString *)certificateNo userEmail:(NSString *)userEmail provinceId:(NSString *)provinceId cityId:(NSString *)cityId payPwd:(NSString *)payPwd complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;


/**
 *  银行卡修改与绑定
 *
 *  @param operType   	操作类型	N   1-银行卡绑定；2-银行卡信息修改；3-设为默认银行卡，4-解绑(删除)
 *  @param oldCardNo  	原银行卡号	Y	当操作类型为银行卡号修改时，该字段必须为改变前的银行卡号
 *  @param cardNo     	银行卡号	N		需要绑定的银行卡号或需要变更的新卡号
 *  @param cardFront  	银行卡正面照片	Y		商户绑定或更改的银行卡正面照片
 *  @param cardBack   	银行卡正面照片	Y		商户绑定或更改的银行卡正面照片
 *  @param provinceId 	银行卡所属省份Id	Y		省份来源：服务器省市列表获取接口
 *  @param cityId     	银行卡开户城市Id	Y		城市来源：服务器省市列表获取接口
 *  @param cnapsCode  	联行号	Y		当用户可以选择到对应的联行号时上传
 *  @param complete     block回传
 */
+ (void)requestForUpBankCardWithCustId:(NSString *)custId custMobile:(NSString *)custMobile OperType:(NSString *)operType oldCardNo:(NSString *)oldCardNo cardNo:(NSString *)cardNo cardFront:(NSString *)cardFront cardBack:(NSString *)cardBack provinceId:(NSString *)provinceId cityId:(NSString *)cityId cnapsCode:(NSString *)cnapsCode subBranch:(NSString *)subBranch certificateNo:(NSString *)certificateNo complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;


/**
 *  获取省列表
 *
 *  @param custId       商户id    Y
 *  @param complete     block回传
 */
+ (void)requestForGetProvinceWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *array))complete;


/**
 *  绑定终端
 *
 *  @param custId   商户id
 *  @param custId   手机号
 *  @param termNo   终端序列号
 *  @param complete block回传
 */
+ (void)requestForBDZDWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;

/**
 *  交易记录
 *
 *  @param custId     商户id
 *  @param custMobile 商户手机号
 *  @param busType    业务类型 N	 00：所有，01：收款,02:消费,03:提现
 *  @param payWay     支付方式 Y	 01 支付账户，02 终端，03 快捷支付
 *  @param tranState  交易状态 Y	 0：失败，1：成功，2：退货
 *  @param startTime  交易开始时间	 Y	开始时间要小于结束时间
 *  @param endTime    交易结束时间	 Y	结束时间要大于开始时间
 *  @param start      开始取记录的行号
 *  @param pageSize   要取出记录数
 *  @param recordType   交易记录类型
 *  @param complete   block回传
 */
+ (void)requestForGetTranSerialListWithCustId:(NSString *)custId custMobile:(NSString *)custMobile busType:(NSString *)busType payWay:(NSString *)payWay tranState:(NSString *)tranState startTime:(NSString *)startTime endTime:(NSString *)endTime startLineNum:(NSString *)start pageSize:(NSString *)pageSize recordType:(NSString *)recordType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray))complete;


/**
 *  获取轮播图
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForDynamicImgWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *imageArray))complete;


/**
 *  商品订单(下单)
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param prdordType 订单类型	N	01收款  02商品 (便民)
 *  @param bizType    子订单类型	Y	当prdordType取值02，该字段取值：01 手机充值 02 …
 *  @param prdordAmt  订单金额
 *  @param prdName    商品名称
 *  @param price      单价
 *  @param complete   block回传
 */
+ (void)requestForPrdOrderWithCustId:(NSString *)custId custMobile:(NSString *)custMobile prdordType:(NSString *)prdordType bizType:(NSString *)bizType prdordAmt:(NSString *)prdordAmt prdName:(NSString *)prdName price:(NSString *)price  complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic))complete;



/**
 *  4.2.4	终端签到
 *
 *  @param custId   商户id
 *  @param custId   手机号
 *  @param termNo   终端序列号
 termType   终端类型  01 蓝牙 02 音频
 *  @param complete block回传
 */
+ (void)requestForSignTDKWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo termType:(NSString *)termType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic))complete;


/**
 *  获取终端列表
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForGetTermListWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray))complete;

/**
 *  获取终端费率列表
 *
 *  @param termNo     终端号
 *  @param complete   block回传
 */
+ (void)requestForGetTermRateListWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *rateArray))complete;



/**
 *  设备签到，获取秘钥
 *
 *  @param custMobile 手机号
 *  @param termNo     设备号
 *  @param termType   设备类型
 *  @param custId     商户id
 *  @param complete   block回传
 */
+ (void)requestForGetMiYaoWithCustMobile:(NSString *)custMobile termNo:(NSString *)termNo termType:(NSString *)termType custId:(NSString *)custId complete:(void(^)(BOOL succeed, NSString *msg,NSString *cod, TDPinKeyInfo *pinkey))complete;

/**
 *  获取已绑定的银行卡列表
 *
 *  @param custMobile 手机号
 *  @param custId     商户id
 *  @param complete   block回调
 */
+(void)requestForGetBankCardInfoWithMobile:(NSString *)custMobile WithCustId:(NSString *)custId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray))complete;
/**
 *  提现接口
 *
 *  @param custId     商户id
 *  @param custMobile 手机号码
 *  @param txamt      提现金额
 *  @param casType    提现类型  (01：T0提现 02：T1提现)
 *  @param cardNo     结算银行卡卡号
 *  @param complete   block回调
 */
+(void)requestFortxTranWithCustId:(NSString *)custId Mobile:(NSString *)custMobile txamt:(NSString *)txamt casType:(NSString *)casType cardNo:(NSString *)cardNo payPwd:(NSString *)payPwd complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;
/**
 *  公告查询
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param pageSize   每次刷新条数
 *  @param lastId     上次加载完成后最后一条公告的Id
 *  @param complete   block回传
 */
+ (void)requestForNoticeWithCustId:(NSString *)custId custMobile:(NSString *)custMobile start:(NSString *)start pageSize:(NSString *)pageSize noticeStatus:(NSString *)noticeStatus lastId:(NSString *)lastId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *noticeArray))complete;

/**
 *  记录公告
 *
 *  @param custId   商户id
 *  @param noticeId 公告id
 *  @param complete block回传
 */
+ (void)requestForNoticeQueryWithCustId:(NSString *)custId custMobile:(NSString *)custMobile noticeId:(NSString *)noticeId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSDictionary * dic))complete;
/**
 *  账户余额
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForgetBalanceWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,TDBalanceInfo * info))complete;

/**
 *  支付
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param prdordNo   订单号
 *  @param payType    支付方式
 *  @param rate       费率类型
 *  @param termNo     终端号
 *  @param termType   终端类型
 *  @param payAmt     交易金额
 *  @param track      磁道信息
 *  @param pinblk     密码密文
 *  @param random     随机数	C		音频设备时使用
 *  @param mediaType  介质类型	C		01 磁条卡 02 IC卡
 *  @param period     有效期	C		mediaType 02时必填
 *  @param icdata     55域	C		mediaType 02时必填
 *  @param crdnum     卡片序列号	C		mediaType 02时必填
 *  @param mac        Mac	C		设备计算的mac
 *  @param ctype      到帐类型  TO   T1
 *  @param scancardnum      扫描银行卡号
 *  @param scanornot   是否扫描所得
 *  @param complete   block回传
 */
+ (void)requestForPayWithCustId:(NSString *)custId custMobile:(NSString *)custMobile prdordNo:(NSString *)prdordNo payType:(NSString *)payType rate:(NSString *)rate termNo:(NSString *)termNo termType:(NSString *)termType payAmt:(NSString *)payAmt track:(NSString *)track pinblk:(NSString *)pinblk random:(NSString *)random mediaType:(NSString *)mediaType period:(NSString *)period icdata:(NSString *)icdata crdnum:(NSString *)crdnum mac:(NSString *)mac ctype:(NSString *)ctype scancardnum:(NSString *)scancardnum scanornot:(NSString *)scanornot address:(NSString *)address complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;

/**
 * 上传扫描银行卡照片
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param prdordNo   商品订单号
 *  @param bankcard   银行卡照片
 *  @param cardnum    银行卡号
 *  @param complete   block回传
 */
+ (void)requestForUpScanBankCardWithCustId:(NSString *)custId custMobile:(NSString *)custMobile prdordNo:(NSString *)prdordNo bankcard:(NSString *)bankcard cardnum:(NSString *)cardnum complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;
/**
 *  获取注册协议
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForgetAgreementWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSString *urlPath))complete;
/**
 *  银行卡余额查询
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param termNo     终端号
 *  @param termType   终端类型
 *  @param track      磁道信息
 *  @param pinblk     密码密文
 *  @param random     随机数	C		音频设备时使用
 *  @param mediaType  介质类型	C		01 磁条卡 02 IC卡
 *  @param period     有效期	C		mediaType 02时必填
 *  @param icdata     55域	C		mediaType 02时必填
 *  @param crdnum     卡片序列号	C		mediaType 02时必填
 *  @param mac        Mac	C		设备计算的mac
 *  @param complete   block回传
 */

+ (void)requestForBankCardBalanceWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo termType:(NSString *)termType track:(NSString *)track pinblk:(NSString *)pinblk random:(NSString *)random mediaType:(NSString *)mediaType period:(NSString *)period icdata:(NSString *)icdata crdnum:(NSString *)crdnum mac:(NSString *)mac complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod , NSString * balance))complete;



/**
 *  手续费计算
 *
 *  @param custId       商户id
 *  @param custMobile   手机号
 *  @param txamt        金额
 *  @param casType      提现类型
 *  @param complete   block回传
 */
+ (void)requestGetFeeWithCustId:(NSString *)custId custMobile:(NSString *)custMobile andTxamt:(NSString *)txamt andCasType:(NSString *)casType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod , NSString * fee))complete;
/**
 *  用户退出
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForLogoutWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;
//电子签名
+ (void)requestForupOrderSignWithCustId:(NSString *)custId custMobile:(NSString *)custMobile andPrdordNo:(NSString *)PrdordNo andImageString:(NSString * )string complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete;
//分润查询
+ (void)requestGetProfitInfoWithCustId:(NSString *)custId custMobile:(NSString *)custMobile andStart:(NSString *)start andPageSize:(NSString *)pageSize profitStartDate:(NSString *)profitStartDate profitEndDate:(NSString *)profitEndDate complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray * tempArray))complete;
/**
 *  交易记录详情
 *
 *  @param custId     商户id
 *  @param custMobile 商户手机号
 *  @param busType    业务类型 N	 00：所有，01：收款,02:消费,03:提现
 *  @param bizType     	当busType取值02，该字段取值：000001 手机充值 000002 …
 *  @param ordno  交易状态 Y	 0：失败，1：成功，2：退货
 *  @param complete   block回传
 */
+ (void)requestGetTranDetailWithCustId:(NSString *)custId custMobile:(NSString *)custMobile busType:(NSString *)busType bizType:(NSString *)bizType ordno:(NSString *)ordno complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, id  serialInfo))complete;

/**
 *  自动更新接口
 *
 *  @param custId     custId
 *  @param custMobile custMobile
 *  @param complete   block回传
 */
+ (void)requestForUpDataAppWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSDictionary * dic))complete;
@end
