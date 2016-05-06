//
//  YuMeiPaxMpos.h
//  YuMeiPaxMpos
//
//  Created by admin on 15-5-5.
//  Copyright (c) 2015年 pax. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TPK,
    TDK,
    TAK
}KeyType;

typedef enum {
    MAGNETIC_CARD,     // – 磁条卡
    IC_CARD,           // – IC卡
    MAGNETIC_IC_CARD   // – IC或磁条卡
}CardType;

typedef enum {
    APPROVED, //脱机批准
    DENIAL,   //交易拒绝
    FALLBACK, //fallback
    ONLINE    //请求联机
}StartPBOCResultOption;


@interface MposDeviceInfo : NSObject

@property NSString *model;  //设备类型
@property NSString *vendor; //设备厂商
@property NSString *productSN; //设备SN
@property NSString *customerSN; //客户定制SN
@property NSString *appVersion; //app版本号

@end

@interface MagProcessResult : NSObject

@property NSData *track2Cipher; //track2密文
@property NSData *track3Cipher; //track3密文
@property NSString *pan; //卡号明文
@property NSData *pinblock; //联机PIN

@end

@interface StartPBOCParam : NSObject

@property UInt8 transType; //交易类型
@property NSString *authAmount; //授权金额. 12个数字, 如 “000000001234”表示12.34元
@property NSString *otherAmount; //其他金额.
@property NSString *dateTime; //交易日期时间”YYMMDDhhmmss”

@end

@interface StartPBOCResult : NSObject

@property StartPBOCResultOption option; //交易结果,

@property NSData *track2Cipher; //2磁道密文
@property NSString *pan; //主账号明文
@property NSString *cardSeq; //卡片序列号
@property NSString *expiry; //卡片有效期
@property NSData *pinBlock; //联机PIN
@property NSData *iccData; //IC卡联机数据

@end

@interface PBOCOnlineData : NSObject

@property NSString *authRespCode; //授权返回码即8A标签, 2字节, 如交易成功 “00”.
@property NSData *onlineData;   //联机返回数据

@end

@interface OnlineDataProcessResult : NSObject

@property NSData *iccData; //IC卡 TC数据/脚本处理结果

@end

@interface YuMeiPaxMpos : NSObject

typedef void (^errorBlock)(UInt16 errCode, NSString *errDesc);
typedef void (^voidBlock)();

typedef void (^didDiscoveredOneDeviceBlock)(NSString *name, NSString *identifier);
typedef void (^getDeviceInfoSuccBlock)(MposDeviceInfo *devInfo);
typedef void (^loadWorkKeySuccBlock)(KeyType keyType);
typedef void (^checkCardSuccBlock)(CardType cardType);
typedef void (^magProcessSuccBlock)(MagProcessResult *result);
typedef void (^startPBOCSuccBlock)(StartPBOCResult *result);
typedef void (^onlineDataProcessBlock)(OnlineDataProcessResult *result);



+(id)sharedInstance;

-(void) startSearchDevWithTimeout:(NSInteger) timeout
           didDiscoveredOneDevice:(didDiscoveredOneDeviceBlock)didDiscoveredOneDevice
                      didFinished:(voidBlock)didFinished;

-(void) connectBluetoothId:(NSString *)bluetoothId
                   success:(voidBlock)success
                    failed:(errorBlock)failed;

-(void) disconnect;

-(void) getDeviceInfoSuccess:(getDeviceInfoSuccBlock)success
                      failed:(errorBlock)failed;

-(void) loadMasterKey:(NSData *) masterKey
              success:(voidBlock)success
               ailed:(errorBlock)failed;

-(void) loadWorkKeyWithKeyType:(KeyType) keyType
                       workKey:(NSData *) workKey
                       success:(loadWorkKeySuccBlock)success
                        failed:(errorBlock)failed;

-(void) checkCardWithCardType:(CardType) type
                      timeout:(NSInteger) timeout
                      success:(checkCardSuccBlock)success
                       failed:(errorBlock)failed;

-(void) magProcessWithAmount:(NSString *)amount
                     timeout:(NSInteger) timeout
                     success:(magProcessSuccBlock)success
                      failed:(errorBlock)failed;

-(void) startPBOCWithParam:(StartPBOCParam *)param
                   success:(startPBOCSuccBlock)success
                    failed:(errorBlock)failed;

-(void) onlineDataProcessWithData:(PBOCOnlineData *)onlineData
                          success:(onlineDataProcessBlock)success
                           failed:(errorBlock)failed;

@end
