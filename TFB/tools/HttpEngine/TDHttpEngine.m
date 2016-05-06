//
//  TDHttpEngine.m
//  TFB
//
//  Created by Nothing on 15/3/20.
//  Copyright (c) 2015年 TD. All rights reserved.
//
#import "TDbankListName.h"
#import "TDHttpEngine.h"
#import "MBProgressHUD.h"
#import "GTMBase64.h"
#import "NSString+MD5Addition.h"
#import "NSString+MD5.h"
#import "JSONKit.h"
#import "TDProvince.h"
#import "TDDynamicImg.h"
#import "TDFunctionObject.h"
#import "TDTerm.h"
#import "TDTranSerial.h"
#import "TDNoticeInfo.h"
#import "TDBankCardInfo.h"
#import "CJCommon.h"
#import "TDHttpManager.h"
#import "TDFenRunInfo.h"
#import "TDTranSerial.h"


#define GETMSGCODE          @"SY0001"    //发送验证码
#define REGIST              @"SY0002"    //注册
#define LOGIN               @"SY0003"    //登录
#define VERIFYMSGCODE       @"SY0013"    //验证码验证
#define GETCUSTINF          @"SY0004"    //商户信息查询
#define UPDATAPWD           @"SY0005"    //商户密码修改与找回
#define LOGOUT              @"SY0006"    //退出登录
#define CERTIFICATION       @"SY0007"    //商户实名认证
#define UPBANKCARD          @"SY0008"    //银行卡绑定与修改
#define CHECKVERSION        @"SY0009"    //版本检测与更新
#define DYNAMICIMG          @"SY0010"    //首页轮播图获取
#define NOTICE              @"SY0011"    //公告查询

#define GETPROVINCE         @"SY0012"    //获取省列表

#define GETCITY             @"SY0014"    //获取市列表
#define GETAREA             @"SY0015"    //获取地区列表

#define GETMIYAO            @"SG0002"    //获取秘钥
#define SIGNTDK             @"SG0003"    //签到下发装载工作秘钥

#define CARDINQUIRYBALANCE  @"PY0003"    //银行卡余额查询
#define BANKBINDINGLIST     @"SY0015"    //绑定的银行卡列表
#define FEE                 @"GB0002"    //提现费率

#define GETTRANSERIALIST    @"TR0001"    //交易记录
#define GETTRANDETAIL       @"TR0002"    //交易记录详情
#define GETPROFITINFO       @"PF0001"    //商户分润

#define DEAWINGCASH         @"PY0004"    //提现接口
#define GETBALANCE          @"GB0001"    //账户余额

#define TERMBIND            @"TE0001"    //终端绑定
#define GETTERMLIST         @"TE0002"    //终端列表查询
#define GETTERMRATE         @"TE0003"    //终端费率查询

#define BANKNAME            @"BU0001"    //银行名称列表
#define BANKLISTNAME        @"BU0002"    //支行名称列表

#define PARORDER            @"OD0001"    //商品订单(下单)
#define PAYMENT             @"PY0001"    //支付

#define UPORDERSIGN         @"UP0001"    //电子签名
#define UPSCANBANKCARD      @"UP0002"    //上传扫描银行卡照片
#define GETAGREEMENT        @"AG0001"    //获取注册协议

#define RSPCOD_SUCCEED      @"000000"   //成功响应码
#define RSPCOD_TIMEOUE      @"888888"   //在线超时，要求重新登录
#define UPDATA_APP          @"SY0009"   //自动鞥新
#define NOTICEQUERY         @"SY0020"   //记录已阅公告

@implementation TDHttpEngine


//初始化网络请求引擎
+ (instancetype)shareHttpEngine
{
    
    static TDHttpEngine *httpEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpEngine = [[self alloc] init];
    });
    return httpEngine;
}




/**
 *  发送验证码
 *
 *  @param custMobile 手机号
 *  @param codeType   验证码类型
 *  @param complete   block回传
 */
+ (void)requestForGetMsgCodeWithCustMobile:(NSString *)custMobile codeType:(NSString *)codeType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{

    if (![TDHttpManager requestCanContinuationWith:2 andParams:custMobile,codeType, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custMobile, codeType] forKeys:@[@"custMobile", @"codeType"]];
    
    
      [TDHttpManager requestWithParams:dataDic tradeCode:GETMSGCODE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
         
              if (complete) {
                  complete(succeed, msg, cod);
              }
    
      }];

}

/**
 *  验证验证码
 *
 *  @param custMobile 手机号
 *  @param codeType   验证码类型
 *  @param msgCode    验证码
 *  @param complete   block回传
 */
+ (void)requestForVerifyMsgCodeWithCustMobile:(NSString *)custMobile codeType:(NSString *)codeType msgCode:(NSString *)msgCode complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:3 andParams:custMobile,codeType,msgCode, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custMobile, codeType, msgCode] forKeys:@[@"custMobile", @"codeType", @"msgCode"]];
    
    
    [TDHttpManager requestWithParams:dataDic tradeCode:VERIFYMSGCODE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod);
        }
        
    }];
    
}


/**
 *  注册
 *
 *  @param custMobile      手机号
 *  @param custPwd         登录密码
 *  @param complete        block回传
 */

+ (void)requestForRegistWithCustMobile:(NSString *)custMobile custPwd:(NSString *)custPwd referrer:(NSString *)referrer complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custMobile,custPwd, nil]) {
        return;
    }
    
    NSString * pwdMD5 = [custPwd MD5];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custMobile, pwdMD5,referrer] forKeys:@[@"custMobile", @"custPwd",@"referrer"]];

    
    [TDHttpManager requestWithParams:dataDic tradeCode:REGIST complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod);
        }
        
    }];
}

/**
 *  登录
 *
 *  @param CustMobile 手机号
 *  @param custPwd    登录密码
 *  @param complete   block回传
 */
+ (void)requestForLoginWithCustMobile:(NSString *)custMobile custPwd:(NSString *)custPwd complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custMobile,custPwd, nil]) {
        return;
    }
    
    NSString *pwdMD5 = [custPwd MD5];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custMobile, pwdMD5,] forKeys:@[@"custMobile", @"custPwd"]];
    
    
    [TDHttpManager requestWithParams:dataDic tradeCode:LOGIN complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            TDUser * user = [TDUser defaultUser];
            
            user.custId = [dictionary objectForKey:@"custId"];
            user.custLogin = [dictionary objectForKey:@"custLogin"];
            
            complete(succeed, msg, cod);
        }
        
    }];
}


/**
 *  银行名称列表查询
 *
 *  @param custId
 *  @param custMobile
 *  @param bankProId  省ID
 *  @param bankCityId 市ID
 *  @param complete
 */
+(void)requestGetBankNamecustId:(NSString *)custId custMobile:(NSString *)custMobile bankProId:(NSString *)bankProId bankCityId:(NSString *)bankCityId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSArray * bankList))complete{
    
    
    if (![TDHttpManager requestCanContinuationWith:4 andParams:custId,custMobile,bankProId,bankCityId, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile,bankProId,bankCityId] forKeys:@[@"custId",@"custMobile",@"bankProId", @"bankCityId"]];

    NSLog(@"%@",dataDic);
    [TDHttpManager requestWithParams:dataDic tradeCode:BANKNAME complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (complete) {
            NSMutableArray * bankArray = [NSMutableArray arrayWithCapacity:0];
            for (NSString *bank in dictionary[@"bankCardList"]) {
                [bankArray addObject:bank];
            }
            NSLog(@"%@",bankArray);
            complete(succeed, msg, cod ,bankArray);
        }
        
    }];
}

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
+(void)requestGetBankListNameCustId:(NSString *)custId custMobile:(NSString *)custMobile bankProId:(NSString *)bankProId bankCityId:(NSString *)bankCityId bankName:(NSString *)bankName categories:(NSString *)categories complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSArray * bankList))complete{
    
    if (![TDHttpManager requestCanContinuationWith:6 andParams:custId,custMobile,bankProId,bankCityId,bankName,categories, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile,bankProId,bankCityId,bankName,categories] forKeys:@[@"custId", @"custMobile", @"bankProId", @"bankCityId", @"bankName",@"categories"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:BANKLISTNAME complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        
        

        if (succeed) {
           
            NSArray *dataArray = [dictionary valueForKey:@"bankCardList"];
            
//            NSArray *dataArray = [dictionary objectForKey:@"bankCardList"];
            NSMutableArray * tempArray = [NSMutableArray  arrayWithCapacity:0];
            for (int i = 0; i < dataArray.count; i++) {
                TDbankListName *bankListName = [[TDbankListName alloc] initWithDictionary:dataArray[i]];
                
                [tempArray addObject:bankListName];
            }
//            NSDictionary *listDic = dictionary[@"bankCardList"];
//            
//            
//            for (NSString *str in listDic[@"subBranch"]) {
//                NSLog(@"%@",listDic[@"subBranch"]);
//    
//                [tempAArray addObject:str];
//            }
            
            if (complete) {
                complete(succeed, msg, cod ,tempArray);
            }
        
        }
    }];
    
}

/**
 *  商户信息查询
 *
 *  @param custMobile 手机号
 *  @param custId     商户id
 *  @param complete   block回传
 */
+ (void)requestForGetCustInfWithCustMobile:(NSString *)custMobile custId:(NSString *)custId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, TDUser *user))complete
{
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custMobile,custId, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId, custMobile] forKeys:@[@"custId", @"custMobile"]];
    
    NSLog(@"====> %@",[TDHttpManager jsonWithDic:dataDic]);
    
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETCUSTINF complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {

        NSLog(@"%@",dictionary);
        TDUser * user = [TDUser defaultUser];
        if (succeed) {
            user.custId = [dictionary objectForKey:@"custId"];
            user.custLogin = [dictionary objectForKey:@"custLogin"];
            user.custStatus = [dictionary objectForKey:@"custStatus"];
            user.cardNum = [dictionary objectForKey:@"cardNum"];
            user.termNum = [dictionary objectForKey:@"termNum"];
            user.custName = [dictionary objectForKey:@"custName"];
            user.cardBundingStatus = [dictionary objectForKey:@"cardBundingStatus"];
            user.ideCardAuthError = [dictionary objectForKey:@"ideCardAuthError"];
            user.bankCardAuthError = [dictionary objectForKey:@"bankCardAuthError"];
            user.redDot = [dictionary objectForKey:@"redDot"];
            user.custLoginStar = [TDUser moblieStarWithMoblie:user.custLogin];
        }
        if (complete) {
            complete(succeed, msg, cod,user);
        }
        
    }];
}


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
+ (void)requestForUpdatePwdWithPwdType:(NSString *)pwdType updateType:(NSString *)updateType value:(NSString *)value newPwd:(NSString *)newPwd custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:5 andParams:pwdType,updateType,value,newPwd,custMobile, nil]) {
        return;
    }
    
    NSString *pwdMD5 = [newPwd MD5];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[pwdType, updateType, value, pwdMD5, custMobile] forKeys:@[@"pwdType", @"updateType", @"value", @"newPwd", @"custMobile"]];

    [TDHttpManager requestWithParams:dataDic tradeCode:UPDATAPWD complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod);
        }
        
    }];
    
}

/**
 *  公告查询
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param start      开始的行数
 *  @param pageSize   每次刷新条数
 *  @param lastId     上次加载完成后最后一条公告的Id
 *  @param complete   block回传
 */
+ (void)requestForNoticeWithCustId:(NSString *)custId custMobile:(NSString *)custMobile start:(NSString *)start pageSize:(NSString *)pageSize noticeStatus:(NSString *)noticeStatus lastId:(NSString *)lastId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *noticeArray))complete
{
    if (![TDHttpManager requestCanContinuationWith:6 andParams:custId,custMobile,start,pageSize,noticeStatus,lastId, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, pageSize, noticeStatus,lastId,start] forKeys:@[@"custId", @"custMobile", @"pageSize",@"noticeStatus", @"lastId",@"start"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:NOTICE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSMutableArray *tempArray;
        if (succeed) {
            NSLog(@"%@",dictionary);
            NSArray *dataArray = [dictionary objectForKey:@"noticeList"];
            NSLog(@"%@",dataArray);
                    tempArray = [NSMutableArray arrayWithCapacity:0];
            if (dataArray != nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count != 0) {
                for (int i = 0; i < dataArray.count; i++) {
                    TDNoticeInfo *notice = [[TDNoticeInfo alloc] initWithDictionary:dataArray[i]];
                    [tempArray addObject:notice];
                }
            }
            
                }
        
        if (complete) {
            complete(succeed, msg, cod,tempArray);
        }
        
    }];
    
}
/**
 *  商户实名认证     
 *
 *  @param cardHandheld 手持身份证照片	N
 *  @param cardFront    身份证正面照片	N
 *  @param cardBack     身份证背面照片	N
 *  @param custId       商户编号	N
 *  @param complete     block回传
 */
+ (void)requestForCertificationWithCardHandheld:(NSString *)cardHandheld cardFront:(NSString *)cardFront cardBack:(NSString *)cardBack custId:(NSString *)custId custMobile:(NSString *)custMobile custName:(NSString *)custName certificateType:(NSString *)certificateType certificateNo:(NSString *)certificateNo userEmail:(NSString *)userEmail provinceId:(NSString *)provinceId cityId:(NSString *)cityId payPwd:(NSString *)payPwd complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:12 andParams:cardHandheld,cardFront,cardBack,custId,custMobile,custName,certificateType,certificateNo,userEmail,provinceId,cityId,payPwd, nil]) {
        return;
    }
    
    NSString * pwdMD5 = [payPwd MD5];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, custName, certificateType, certificateNo, userEmail, provinceId, cityId, pwdMD5] forKeys:@[@"custId", @"custMobile", @"custName", @"certificateType", @"certificateNo", @"userEmail", @"provinceId", @"cityId", @"payPwd"]];
    MKNetworkEngine *netWorkEngine = [[MKNetworkEngine alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@.json", HOST, CERTIFICATION];
    MKNetworkOperation *operation = [netWorkEngine operationWithURLString:url params:[TDHttpManager jsonWithDic:dataDic] httpMethod:@"POST"];
    [operation addFile:cardHandheld forKey:@"cardHandheld"];
    [operation addFile:cardFront forKey:@"cardFront"];
    [operation addFile:cardBack forKey:@"cardBack"];
    __weak MKNetworkOperation *weakOperation = operation;
    [weakOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString:RSPCOD_SUCCEED]) {
            if (complete) {
                
                complete(YES, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        else {
            if (complete) {
                complete(NO, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (complete) {
            complete(NO, @"未能连接到服务器", nil);
        }
    }];
    [netWorkEngine enqueueOperation:operation];
    
}


/**
 *  银行卡修改与绑定
 *
 *  @param operType   operType	操作类型	N   1-银行卡绑定；2-银行卡信息修改；3-设为默认银行卡，4-解绑(删除)
 *  @param oldCardNo  oldCardNo	原银行卡号	Y	当操作类型为银行卡号修改时，该字段必须为改变前的银行卡号
 *  @param cardNo     cardNo	银行卡号	N		需要绑定的银行卡号或需要变更的新卡号
 *  @param cardFront  cardFront	银行卡正面照片	Y		商户绑定或更改的银行卡正面照片
 *  @param cardBack   cardFront	银行卡正面照片	Y		商户绑定或更改的银行卡正面照片
 *  @param provinceId provinceId	银行卡所属省份Id	Y		省份来源：服务器省市列表获取接口
 *  @param cityId     cityId	银行卡开户城市Id	Y		城市来源：服务器省市列表获取接口
 *  @param cnapsCode  cnapsCode	联行号	Y		当用户可以选择到对应的联行号时上传
 *  @param complete     block回传
 */
+ (void)requestForUpBankCardWithCustId:(NSString *)custId custMobile:(NSString *)custMobile OperType:(NSString *)operType oldCardNo:(NSString *)oldCardNo cardNo:(NSString *)cardNo cardFront:(NSString *)cardFront cardBack:(NSString *)cardBack provinceId:(NSString *)provinceId cityId:(NSString *)cityId cnapsCode:(NSString *)cnapsCode subBranch:(NSString *)subBranch   certificateNo:(NSString *)certificateNo complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:12 andParams:custId, custMobile, operType, oldCardNo ,cardNo ,cardFront ,cardBack ,provinceId ,cityId ,cnapsCode ,subBranch ,certificateNo , nil]) {
        return;
    }
    
    //
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, operType, oldCardNo ,cardNo ,provinceId ,cityId ,cnapsCode,subBranch,certificateNo] forKeys:@[@"custId", @"custMobile", @"operType", @"oldCardNo", @"cardNo", @"provinceId", @"cityId", @"cnapsCode",@"subBranch",@"certificateNo"]];
    MKNetworkEngine *netWorkEngine = [[MKNetworkEngine alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@.json", HOST, UPBANKCARD];
    MKNetworkOperation *operation = [netWorkEngine operationWithURLString:url params:[TDHttpManager jsonWithDic:dataDic] httpMethod:@"POST"];
    [operation addFile:cardFront forKey:@"cardFront"];
    [operation addFile:cardBack forKey:@"cardBack"];
    __weak MKNetworkOperation *weakOperation = operation;
    [weakOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dictionary);
        if ([[[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString:RSPCOD_SUCCEED]) {
            if (complete) {
                
                complete(YES, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        else {
            if (complete) {
                complete(NO, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (complete) {
            complete(NO, [error description], nil);
        }
    }];
    [netWorkEngine enqueueOperation:operation];
}


/**
 *  获取省列表
 *
 *  @param custId       商户id    Y
 *  @param complete     block回传
 */
+ (void)requestForGetProvinceWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *array))complete;
{
    
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custId, custMobile, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile] forKeys:@[@"custId", @"custMobile"]];
   
    [TDHttpManager requestWithParams:dataDic tradeCode:GETPROVINCE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSMutableArray *tempArray;
        if (succeed) {
            NSArray *dataArray = [dictionary objectForKey:@"province"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:CITIYLIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            tempArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < dataArray.count; i++) {
                
                TDProvince *province = [[TDProvince alloc] initWithDictionary:dataArray[i]];
                [tempArray addObject:province];
            }
        }
    
        if (complete) {
            complete(succeed, msg, cod,tempArray);
        }
        
    }];
}

/**
 *  绑定终端
 *
 *  @param custId   商户id
 *  @param termNo   终端序列号
 *  @param complete block回传
 */
+ (void)requestForBDZDWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:3 andParams:custId, custMobile,termNo, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile,termNo] forKeys:@[@"custId", @"custMobile", @"termNo"]];

    [TDHttpManager requestWithParams:dataDic tradeCode:TERMBIND complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod);
        }
        
    }];
    
    
}


/**
 *  获取轮播图
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForDynamicImgWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *imageArray))complete
{
    
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custId, custMobile, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile] forKeys:@[@"custId", @"custMobile"]];
   
    [TDHttpManager requestWithParams:dataDic tradeCode:DYNAMICIMG complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSMutableArray *tempArray;
        if (succeed) {
            NSArray *dataArray = [dictionary objectForKey:@"imgList"];
            tempArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < dataArray.count; i ++) {
                
                TDDynamicImg *dynamicImg = [[TDDynamicImg alloc] initWithDictionary:dataArray[i]];
                [tempArray addObject:dynamicImg];
                
            }
        }
        
        if (complete) {
            complete(succeed, msg, cod,tempArray);
        }
        
    }];
    
}


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
+ (void)requestForPrdOrderWithCustId:(NSString *)custId custMobile:(NSString *)custMobile prdordType:(NSString *)prdordType bizType:(NSString *)bizType prdordAmt:(NSString *)prdordAmt prdName:(NSString *)prdName price:(NSString *)price  complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic))complete
{
    
    if (![TDHttpManager requestCanContinuationWith:7 andParams:custId, custMobile, prdordType, bizType, prdordAmt,prdName,price, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, prdordType, bizType, prdordAmt,prdName,price] forKeys:@[@"custId", @"custMobile", @"prdordType", @"bizType", @"prdordAmt",@"prdName",@"price"]];
  
    [TDHttpManager requestWithParams:dataDic tradeCode:PARORDER complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod,dictionary);
        }
    
    }];
}


/**
 *  获取终端列表
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForGetTermListWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *termArray))complete
{
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custId, custMobile, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile] forKeys:@[@"custId", @"custMobile"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETTERMLIST complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        NSMutableArray *tempArray;
        if (succeed) {
            NSArray *dataArray = [dictionary objectForKey:@"termList"];
            tempArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < dataArray.count; i++) {
                TDTerm * term = [[TDTerm alloc]initWithDictionary:[dataArray objectAtIndex:i]];
                [tempArray addObject:term];
            }
        }
        
        if (complete) {
            complete(succeed, msg, cod,tempArray);
        }
    }];
    
}

+ (void)requestForGetTermRateListWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *rateArray))complete {
    
    if (![TDHttpManager requestCanContinuationWith:3 andParams:custId, custMobile, termNo, nil]) {
        return;
    }
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, termNo] forKeys:@[@"custId", @"custMobile", @"termNo"]];
    [TDHttpManager requestWithParams:dataDic tradeCode:GETTERMRATE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        NSMutableArray *rareArray;
        if (succeed) {
            NSArray *dataArray = [dictionary objectForKey:@"rateList"];
            rareArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < dataArray.count; i++) {
                TDRate * rate = [[TDRate alloc]initWithDictionary:[dataArray objectAtIndex:i]];
                
                [rareArray addObject:rate];
            }
        }
        
        if (complete) {
            complete(succeed, msg, cod,rareArray);
        }
    }];
    
}

/**
 *  设备签到，获取秘钥
 *
 *  @param custMobile 手机号
 *  @param termNo     设备号
 *  @param termType   设备类型
 *  @param custId     商户id
 *  @param complete   block回传
 */
+ (void)requestForGetMiYaoWithCustMobile:(NSString *)custMobile termNo:(NSString *)termNo termType:(NSString *)termType custId:(NSString *)custId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, TDPinKeyInfo *pinkey))complete
{
    if (![TDHttpManager requestCanContinuationWith:4 andParams:custId, custMobile, termNo, termType, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId, custMobile, termNo, termType] forKeys:@[@"custId", @"custMobile", @"termNo", @"termType"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETMIYAO complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        TDPinKeyInfo * pinkey = [TDPinKeyInfo pinKeyDefault];
        if (succeed) {
            
            pinkey.zmakcv = [dictionary objectForKey:@"zmakcv"];
            pinkey.zmakkey = [dictionary objectForKey:@"zmakkey"];
            pinkey.zpincv = [dictionary objectForKey:@"zpincv"];
            pinkey.zpinkey = [dictionary objectForKey:@"zpinkey"];
            pinkey.termTdk = [dictionary objectForKey:@"termTdk"];
            pinkey.termTdkCv = [dictionary objectForKey:@"termTdkCv"];

        }
        
        if (complete) {
            complete(succeed, msg, cod, pinkey);
        }
    }];
    
}




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
+ (void)requestForGetTranSerialListWithCustId:(NSString *)custId custMobile:(NSString *)custMobile busType:(NSString *)busType payWay:(NSString *)payWay tranState:(NSString *)tranState startTime:(NSString *)startTime endTime:(NSString *)endTime startLineNum:(NSString *)start pageSize:(NSString *)pageSize recordType:(NSString *)recordType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray))complete
{
    
    if (![TDHttpManager requestCanContinuationWith:10 andParams:custId, custMobile, busType, payWay, tranState, startTime, endTime, start, pageSize, recordType,  nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, busType, payWay, tranState, startTime, endTime, start, pageSize ,recordType] forKeys:@[@"custId", @"custMobile", @"busType", @"payWay", @"tranState", @"startTime", @"endTime", @"start", @"pageSize", @"recordType"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETTRANSERIALIST complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {

        NSMutableArray *tempArray;
        if (succeed) {
            
            NSArray *dataArray = [dictionary objectForKey:@"tranList"];
            NSLog(@"--> %@",dataArray);
            tempArray = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < dataArray.count; i++) {
                TDTranSerial *tranSerial = [[TDTranSerial alloc] initWithDictionary:dataArray[i]];
                [tempArray addObject:tranSerial];
            }
        }
        
        if (complete) {
            complete(succeed, msg, cod, tempArray);
        }
    }];
    
}

/**
 *  获取已绑定的银行卡列表
 *
 *  @param custMobile 手机号
 *  @param custId     商户id
 *  @param complete   block回调
 */
+(void)requestForGetBankCardInfoWithMobile:(NSString *)custMobile WithCustId:(NSString *)custId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *temArray))complete
{
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custId,custMobile, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile] forKeys:@[@"custId", @"custMobile"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:BANKBINDINGLIST complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSMutableArray *tempArray;
        if (succeed) {
            
            NSArray *dataArray = [dictionary objectForKey:@"bankCardList"];
            tempArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < dataArray.count; i++) {
                TDBankCardInfo *bankCardInfo = [[TDBankCardInfo alloc] initWithDictionary:dataArray[i]];
                bankCardInfo.cerStatus = @"审核已通过";
                [tempArray addObject:bankCardInfo];
            }
            
            NSArray *audDataArray = [dictionary objectForKey:@"bankCardUnAuditList"];
            
            for (int i = 0; i < audDataArray.count; i++) {
                TDBankCardInfo *bankCardInfo = [[TDBankCardInfo alloc] initWithDictionary:audDataArray[i]];
                bankCardInfo.cerStatus = @"正在审核中";
                [tempArray addObject:bankCardInfo];
            }

        }
        
        if (complete) {
            complete(succeed, msg, cod, tempArray);
        }
    }];
}
/**
 *  提现接口
 *
 *  @param custId     商户id
 *  @param custMobile 手机号码
 *  @param txamt      提现金额
 *  @param casType    提现类型  (01：T0提现 02：T1提现)
 *  @param cardNo     结算银行卡卡号
 *  @param payPwd     支付密码
 *  @param complete   block回调
 */
+(void)requestFortxTranWithCustId:(NSString *)custId Mobile:(NSString *)custMobile txamt:(NSString *)txamt casType:(NSString *)casType cardNo:(NSString *)cardNo payPwd:(NSString *)payPwd complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete{
   
    if (![TDHttpManager requestCanContinuationWith:6 andParams:custId,custMobile,txamt,casType,cardNo,payPwd, nil]) {
        return;
    }
    
    
    NSString * pwdMD5 = [payPwd MD5];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile,txamt,casType,cardNo,pwdMD5] forKeys:@[@"custId", @"custMobile",@"txamt",@"casType",@"cardNo",@"payPwd"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:DEAWINGCASH complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        

        if (complete) {
            complete(succeed, msg, cod);
        }
    }];
    
}
//账户余额
+ (void)requestForgetBalanceWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, TDBalanceInfo *info))complete{
   
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custId,custMobile, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile] forKeys:@[@"custId", @"custMobile"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETBALANCE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        TDBalanceInfo * bInfo = (TDBalanceInfo *)[TDBalanceInfo balanceDefault];
        if (succeed) {
            
            [ bInfo dataWithDictionary:dictionary];
        }
        
        if (complete) {
            complete(succeed, msg, cod,bInfo);
        }
    }];

}

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
 *  @param ctype      到帐类型        TO   T1
 *  @param complete   block回传
 */
+ (void)requestForPayWithCustId:(NSString *)custId custMobile:(NSString *)custMobile prdordNo:(NSString *)prdordNo payType:(NSString *)payType rate:(NSString *)rate termNo:(NSString *)termNo termType:(NSString *)termType payAmt:(NSString *)payAmt track:(NSString *)track pinblk:(NSString *)pinblk random:(NSString *)random mediaType:(NSString *)mediaType period:(NSString *)period icdata:(NSString *)icdata crdnum:(NSString *)crdnum mac:(NSString *)mac ctype:(NSString *)ctype scancardnum:(NSString *)scancardnum scanornot:(NSString *)scanornot address:(NSString *)address complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    
    if (![TDHttpManager requestCanContinuationWith:20 andParams:custId, custMobile, prdordNo, payType, rate, termNo, termType, payAmt, track, pinblk, random, mediaType, period, icdata, crdnum, mac,ctype, scancardnum, scanornot, address, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, prdordNo, payType, rate, termNo, termType, payAmt, track, pinblk, random, mediaType, period, icdata, crdnum, mac,ctype,scancardnum, scanornot ,address] forKeys:@[@"custId", @"custMobile", @"prdordNo", @"payType", @"rateType", @"termNo", @"termType", @"payAmt", @"track", @"pinblk", @"random", @"mediaType", @"period", @"icdata", @"crdnum", @"mac",@"ctype",@"scancardnum",@"scanornot",@"address"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:PAYMENT complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSLog(@"pay-----%@",dictionary);
        if (complete) {
            complete(succeed, msg, cod);
        }
    }];
}
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
+ (void)requestForUpScanBankCardWithCustId:(NSString *)custId custMobile:(NSString *)custMobile prdordNo:(NSString *)prdordNo bankcard:(NSString *)bankcard cardnum:(NSString *)cardnum complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
  
    if (![TDHttpManager requestCanContinuationWith:5 andParams:custId, custMobile, prdordNo, bankcard, cardnum, nil]) {
        return;
    }
   
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, prdordNo, cardnum] forKeys:@[@"custId", @"custMobile", @"prdordNo" ,@"cardnum"]];
    MKNetworkEngine *networkEngine = [[MKNetworkEngine alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", HOST, UPSCANBANKCARD, @".json"];
    MKNetworkOperation *operation = [networkEngine operationWithURLString:url params:[TDHttpManager jsonWithDic:dataDic] httpMethod:@"POST"];
    [operation addFile:bankcard forKey:@"bankcard"];
    __weak MKNetworkOperation *weakOperation = operation;
    [weakOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@", weakOperation.responseString);
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString:RSPCOD_SUCCEED]) {
            if (complete) {
                
                complete(YES, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        else {
            if (complete) {
                complete(NO, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (complete) {
            complete(NO, [error description], nil);
        }
    }];
        [networkEngine enqueueOperation:operation];
//    [TDHttpManager requestWithParams:dataDic tradeCode:UPSCANBANKCARD complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
//        
//        if (complete) {
//            complete(succeed, msg, cod);
//        }
//    }];
}
/**
 *  获取注册协议
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForgetAgreementWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSString *urlPath))complete
{
    
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custId, custMobile, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile] forKeys:@[@"custId", @"custMobile"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETAGREEMENT complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (complete) {
            complete(succeed, msg, cod,[dictionary objectForKey:@"fileUrl"]);
        }
    }];
}
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

+ (void)requestForBankCardBalanceWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo termType:(NSString *)termType track:(NSString *)track pinblk:(NSString *)pinblk random:(NSString *)random mediaType:(NSString *)mediaType period:(NSString *)period icdata:(NSString *)icdata crdnum:(NSString *)crdnum mac:(NSString *)mac complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod , NSString * balance))complete{
    
    if (![TDHttpManager requestCanContinuationWith:12 andParams:custId, custMobile, termNo, termType, track, pinblk, random, mediaType, period, icdata, crdnum, mac, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile, termNo, termType, track, pinblk, random, mediaType, period, icdata, crdnum, mac] forKeys:@[@"custId", @"custMobile", @"termNo", @"termType", @"track", @"pinblk", @"random", @"mediaType", @"period", @"icdata", @"crdnum", @"mac"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:CARDINQUIRYBALANCE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod,[dictionary objectForKey:@"balance"]);
        }
    }];
    
}
/**
 *  手续费计算
 *
 *  @param custId       商户id
 *  @param custMobile   手机号
 *  @param txamt        金额
 *  @param casType      提现类型
 *  @param complete   block回传
 */
+ (void)requestGetFeeWithCustId:(NSString *)custId custMobile:(NSString *)custMobile andTxamt:(NSString *)txamt andCasType:(NSString *)casType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod , NSString * fee))complete{

    if (![TDHttpManager requestCanContinuationWith:4 andParams:custId, custMobile,txamt,casType, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile,txamt,casType] forKeys:@[@"custId", @"custMobile", @"txamt", @"casType"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:FEE complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            
            NSString * string = [NSString stringWithFormat:@"%.2f",[[dictionary objectForKey:@"fee"] floatValue]/100+[[dictionary objectForKey:@"serviceFee"] floatValue]/100];
            complete(succeed, msg, cod,string);
        }
    }];
 
}

/**
 *  用户退出
 *
 *  @param custId     商户id
 *  @param custMobile 手机号
 *  @param complete   block回传
 */
+ (void)requestForLogoutWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete
{
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custMobile, custId, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custMobile, custId] forKeys:@[@"custMobile", @"custId"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:LOGOUT complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod);
        }
    }];
}

//电子签名
+ (void)requestForupOrderSignWithCustId:(NSString *)custId custMobile:(NSString *)custMobile andPrdordNo:(NSString *)PrdordNo andImageString:(NSString * )string complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod))complete{
    
    if (![TDHttpManager requestCanContinuationWith:4 andParams:custId,custMobile,PrdordNo,string, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile,PrdordNo] forKeys:@[@"custId", @"custMobile",@"prdordNo"]];
    MKNetworkEngine *netWorkEngine = [[MKNetworkEngine alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@.json", HOST, UPORDERSIGN];
    MKNetworkOperation *operation = [netWorkEngine operationWithURLString:url params:[TDHttpManager jsonWithDic:dataDic] httpMethod:@"POST"];
    [operation addFile:string forKey:@"content"];
    __weak MKNetworkOperation *weakOperation = operation;
    [weakOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString:RSPCOD_SUCCEED]) {
            if (complete) {
                
                complete(YES, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        else {
            if (complete) {
                complete(NO, [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[dictionary objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"]);
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (complete) {
            complete(NO, [error description], nil);
        }
    }];
    [netWorkEngine enqueueOperation:operation];
    
}
//分润查询
+(void)requestGetProfitInfoWithCustId:(NSString *)custId custMobile:(NSString *)custMobile andStart:(NSString *)start andPageSize:(NSString *)pageSize profitStartDate:(NSString *)profitStartDate profitEndDate:(NSString *)profitEndDate complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray * tempArray))complete{
    
    if (![TDHttpManager requestCanContinuationWith:6 andParams:custId,custMobile,start,pageSize,profitStartDate,profitEndDate, nil]) {
        return;
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile,start,pageSize,profitStartDate,profitEndDate] forKeys:@[@"custId", @"custMobile",@"start",@"pageSize",@"profitStartDate",@"profitEndDate"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETPROFITINFO complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSMutableArray *tempArray;
        if (succeed) {
            
            NSArray *dataArray = [dictionary objectForKey:@"profitList"];
            tempArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < dataArray.count; i++) {
                TDFenRunInfo *info = [[TDFenRunInfo alloc] initWithDictionary:dataArray[i]];
                
                [tempArray addObject:info];
            }
        }
        
        if (complete) {
            complete(succeed, msg, cod,tempArray);
        }
    }];
    
    
}
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
+ (void)requestGetTranDetailWithCustId:(NSString *)custId custMobile:(NSString *)custMobile busType:(NSString *)busType bizType:(NSString *)bizType ordno:(NSString *)ordno complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, id  serialInfo))complete{

    
    if (![TDHttpManager requestCanContinuationWith:5 andParams:custId,custMobile,busType,bizType,ordno, nil]) {
        return;
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithObjects:@[custId,custMobile,busType,bizType,ordno] forKeys:@[@"custId", @"custMobile",@"busType",@"bizType",@"ordno"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:GETTRANDETAIL complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        NSLog(@"%@",dictionary);
        if (succeed) {
            if([dictionary objectForKey:@"casType"]){  //提现参数
                TDTiXianDetailedSerial * tixianSer = nil;
                tixianSer = [[TDTiXianDetailedSerial alloc]initWithDictionary:dictionary];
                if (complete) {
                    complete(succeed, msg, cod,tixianSer);
                }
            }else{
                TDTranDetailedSerial * serial = nil;
                serial = [[TDTranDetailedSerial alloc]initWithDictionary:dictionary];
                if (complete) {
                    complete(succeed, msg, cod,serial);
                }
            }
        }else{
            if (complete) {
                complete(succeed, msg, cod,nil);
            }
        }
        
    }];
}

/**
 *  自动更新接口
 *
 *  @param custId     custId
 *  @param custMobile custMobile
 *  @param complete   block回传
 */
+ (void)requestForUpDataAppWithCustId:(NSString *)custId custMobile:(NSString *)custMobile complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSDictionary * dic))complete{
    
    if (![TDHttpManager requestCanContinuationWith:2 andParams:custMobile, custId, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custMobile, custId] forKeys:@[@"custMobile", @"custId"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:UPDATA_APP complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod,dictionary);
        }
    }];

}
/**
 *  记录已阅公告
 *
 *  @param custId   商户id
 *  @param custMobile  商户手机
 *  @param noticeId 公告id
 *  @param complete block回传
 */
+ (void)requestForNoticeQueryWithCustId:(NSString *)custId custMobile:(NSString *)custMobile noticeId:(NSString *)noticeId complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod,NSDictionary * dic))complete{
    
    if (![TDHttpManager requestCanContinuationWith:3 andParams:noticeId, custMobile, custId, nil]) {
        return;
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[noticeId, custMobile, custId] forKeys:@[@"noticeId",@"custMobile", @"custId"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:NOTICEQUERY complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod,dictionary);
        }
    }];
    
}
/**
 *  4.2.4	终端签到
 *
 *  @param custId   商户id
 *  @param custId   手机号
 *  @param termNo   终端序列号
 termType   终端类型  01 蓝牙 02 音频
 *  @param complete block回传
 */
+ (void)requestForSignTDKWithCustId:(NSString *)custId custMobile:(NSString *)custMobile termNo:(NSString *)termNo termType:(NSString *)termType complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *infoDic))complete {
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:@[custId, custMobile,termNo, termType] forKeys:@[@"custId", @"custMobile", @"termNo", @"termType"]];
    
    [TDHttpManager requestWithParams:dataDic tradeCode:SIGNTDK complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dictionary) {
        
        if (complete) {
            complete(succeed, msg, cod, dictionary);
        }
        
    }];
}








#pragma mark - 下载轮播图
///**
// *  下载轮播图
// *
// *  @param path     图片所存放的文件夹路径
// *  @param file     图片下载路径
// *  @param name     图片命名
// *  @param complete 回调
// */
//+(void)downLoadImageWithPath:(NSString *)path andImageFile:(NSString *)file andImageName:(NSString *)name complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSArray *imageArray))complete{
//   
//    NSString * downloadPath = [NSString stringWithFormat:@"%@/%@",path,name];
//    MKNetworkEngine *netWorkEngine = [[MKNetworkEngine alloc]initWithHostName:file customHeaderFields:nil];
//    MKNetworkOperation * downloadOperation = [netWorkEngine operationWithPath:file params:nil httpMethod:@"POST"];
//    [downloadOperation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:path append:YES]];
//    [downloadOperation onDownloadProgressChanged:^(double progress) {
//        //下载进度
//    }];
//     [downloadOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//         
//         NSData * = []
//         
//         NSLog(@"下载成功");
//         
//         
//     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//         
//     }];
//    
//    [netWorkEngine enqueueOperation:operation];
//    
//    
//
//}


@end
