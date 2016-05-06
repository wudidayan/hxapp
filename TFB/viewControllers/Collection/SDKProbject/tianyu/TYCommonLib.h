//
//  TYSwiperController.h
//  TYSwiperController
//
//  Created by whty on 15/7/14.
//  Copyright (c) 2015年 whty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, DeviceStatusLib) {
    DEVICE_STATUS_NONE_LIB,
    AUDIO_DEVICE_IN_LIB,
    AUDIO_DEVICE_OUT_LIB,
    BLE_POWER_OFF_LIB,
    BLE_DEVICE_SCAN_LIB,
    BLE_DEVICE_CONNECT_LIB,
    BLE_DEVICE_DISCONNECT_LIB,
};

typedef NS_ENUM(NSInteger, ICommunication) {
    TY_AUDIO_DEVICE        =   0,     //音频设备
    TY_BLUETOOTH_DEVICE    =   1,     //蓝牙设备
};


@protocol TYSwiperControllerDelegate;

@interface TYSwiperController : NSObject

/**
 重要:默认采用异步方式,SET后变为同步。
 */
@property (assign, nonatomic) id <TYSwiperControllerDelegate> delegate;

#pragma mark - 通用方法

/**
 获取单例
 */
+ (TYSwiperController *)shareInstance;

/**
 音频：配置音频参数，开始监测拔插事件。
 蓝牙：配置蓝牙参数，开始扫描设备，将设备列表返回至回调onDiscoverDevice，停止扫描。
 @param type 类型 
 TY_AUDIO_DEVICE        =   0,     //音频设备
 TY_BLUETOOTH_DEVICE    =   1,     //蓝牙设备
 */
- (void)initdevice:(ICommunication)type;

/**
 连接设备
 @param device(蓝牙为设备名,其他为nil)
 @return BOOL 是否连接成功 回调onConnectDevice
 */
- (BOOL)connectDevice:(NSString *)device;

/**
 是否已连接设备
 @return NSUInteger 参考枚举DeviceStatusLib
 */
- (NSUInteger)isConnected;

/**
 断开设备
 */
- (void)disconnectDevice;

/**
 停止扫描设备
 */
- (void)stopScanDevice;

/**
 获取 API 版本信息
 @return API 版本信息
 */
- (NSString *)getVersion;

/**
 取消当前操作
 @return
 */
- (void)cancel;

#pragma mark - 通信方法

/**
 更新主密钥
 @param mainKey(16字节长度的主密钥 + 4字节长度的校验值)
 @return BOOL 回调onUpdateMainKey
 */
- (BOOL)updateMainKey:(NSString *)mainKey;

/** 
 更新工作密钥(磁道密钥、密码密钥、mac 密钥三组密钥)
 @param TDK:磁道工作密钥密文,20 字节(16+4),null 表示不用写入,当密钥 为单倍长 8+4 时,将前八个字节复制一遍拼 成 16,然后+4.
 @param PIK:PIN 工作密钥密文,20 字节,null 表示不用写入,当密钥为单倍长 8+4 时,将前八个字节复制一遍拼成 16,然后+4.
 @param MAK:MAC 工作密钥密文,20 字节,null 表示不用写入,当密钥为单 倍长 8+4 时,将前八个字节复制一遍拼成 16,然后+4.(mac 补 8 字节 0, 然后加 4 位校验码)
 @return 按参数顺序是否成功更新的数组 1表示成功 0表示不成功 回调onUpdateWorkingKey
 */
- (NSArray *)updateWorkingKey:(NSString *)TDK PIK:(NSString *)PIK MAK:(NSString *)MAK;

/**
 获取外部读卡器设备 SN 号
 @return SN号 回调onReceiveDeviceSN
 */
- (NSString *)getDeviceSN;

/**
 获取 psam 卡号/安全芯片卡号(PSAM 卡号)
 @return CSN号 回调onReceiveDeviceCSN
 */
- (NSString *)getDeviceCSN;

/**
 计算 mac
 @param MKIndex:密钥索引,保留,暂未使用
 @param message:用于计算mac的数据
 @return mac值以及随机数 回调onGetMacWithMKIndex
 */
- (NSDictionary *)getMacWithMKIndex:(int)MKIndex Message:(NSString *)message;

/**
 刷卡
 @param  amount 金额 注:传入金额的时候注意不要传小数点,如果想要传 1.50 则写入"150"
 @param  terminalTime 交易时间 例如 2014-12-03 16:20:55 则 terminalTime 传 入"141203162055"
 @param  tradeType 交易类型 (例如:0x00 代表消费,0x31 代表查询余额)
 @param  swipeTimeOut 交易超时时间
 @param  demote 降级操作 0表示支持 1表示不支持 无则传入nil
 @return 携带卡片信息的NSDictionary 回调onReadCard
 例如 磁条卡:
 * cardType:卡类型
 * cardNumber:卡号
 * expiryDate:有效期
 * serviceCode:服务代码
 * encTrack2Ex:二磁道信息
 * encTrack3Ex:三磁道信息
 * pin:密码
 ic 卡:
 * cardType:卡类型
 * masterSN:卡序号
 * cardNumber:卡号
 * icData: icData
 * encTrack2Ex: 二磁道信息
 * pin:密码
 */
- (NSDictionary *)readCard:(NSString *)amount
              TerminalTime:(NSString *)terminalTime
                 TradeType:(Byte)tradeType
                   timeout:(int)swipeTimeOut
                    Demote:(NSString*)demote;

/**
 无键盘蓝牙刷卡头计算PinBlock，并接收设备返回数据
 @param type         PIN Block格式(P1)
                       0 :请求带主账号的PIN Block
                       1 :请求不带主账号的PIN Block
                       2 :自定义 PIN Block格式
 @param random       0~16字节随机数，固件不支持随机数则传nil
 @param pinBlockStr 传入的密码
 @return 返回设备PINBlock结果，回调onPinBlock:Random:
 */
- (NSDictionary *)getEncPinblock:(NSInteger)type
                          Random:(NSString *)random
                      SourceData:(NSString *)pinBlockStr;

/**
 交易结果确认指令
 通知设备本次交易结束，可返回主界面，等待下一次交易
 @return 交易成功返回YES 回调onConfirmTransaction
 */
- (BOOL)confirmTransaction;

/**
 交易结果确认指令
 通知设备本次交易结束，可返回主界面，等待下一次交易
 @param msg 确认交易后显示在mpos上的字符串，如传入nil则显示默认字符串
 @return 交易成功返回YES 回调onConfirmTransaction
 */
- (BOOL)confirmTransaction:(NSString *)msg;


/**
 标准接触IC卡交易响应处理
 @param data 14字节长度的数组,“响应码” +“发卡行认证数据”
 @return 成功返回YES 回调onConfirmTransaction
 */
- (BOOL)confirmTradeResponse:(NSData *)data;

/**
 交易响应指令
 @param responseCode 银行的响应码
 @param TLVData      发卡行认证数据
 @return 55域数据
 */
- (NSData *)responseToTransaction:(NSString *)responseCode
                          TLVData:(NSString *)TLVData;


/**
 下载商户号终端号指令（商付通）
 回调  onDownloadBusinessIDTerminalID:
 @param  businessID:商户号  （15字节）
 @param  terminalID:终端号  （8字节）
 */
- (BOOL)downloadBusinessID:(NSString *)businessID
                TerminalID:(NSString *)terminalID;

/**
 获取mac地址
 */
- (NSString*)getMac;

/**
 更新AID参数指令
 @param AID AID数据内容
 @return 更新结果
 */
- (BOOL)updateAID:(NSString *)AID;

/**
 更新RID参数指令
 @param RID RID数据内容
 @return 更新结果
 */
- (BOOL)updateRID:(NSString *)RID;
@end

#pragma mark - 回调方法

@protocol TYSwiperControllerDelegate <NSObject>
@optional
/**
 设备已连接
 @param isSuccess 布尔值 YES表示已连接
 */
- (void)onConnectedDevice:(BOOL)isSuccess;

/**
 设备是否断开
 @param isSuccess 布尔值 YES表示已断开
 */
- (void)onDisConnectedDevice:(BOOL)isSuccess;

/**
 返回扫描到的蓝牙设备
 @param device 存储的是扫描到的蓝牙对象
 */
- (void)onDiscoverDevice:(CBPeripheral*)device;

/**
 *  返回设备ID
 *
 *  @param deviceID 设备ID
 */
- (void)onReceiveDeviceCSN:(NSString *)csn;

/**
 *  返回设备SN
 *
 *  @param deviceID 设备sn
 */
- (void)onReceiveDeviceSN:(NSString *)sn;

/**
 是否成功更新主密钥
 @param isSuccess 更新状态
 */
- (void)onUpdateMainKey:(BOOL)isSuccess;


/**
 *  是否成功更新密钥
 *
 *  @param isSuccess 成功/失败
 */
-(void)onUpdateWorkingKeyResult:(BOOL)TDK result:(BOOL)PIK result:(BOOL)MAK;

/**
 获取用 MACkey 加密后的数据
 @param mac 8字节的加密数据
 */
- (void)onGetMacWithMKIndex:(NSString *)mac;

/**
 获取mac地址
 */
- (void)onGetMac:(NSString *)mac;


/**
 获取刷卡后返回的数据
 @param  data 卡片数据
 磁条卡:
 cardType:卡类型
 cardNumber:卡号
 expiryDate:有效期
 serviceCode:服务代码
 encTrack2Ex:二磁道信息
 encTrack3Ex:三磁道信息
 pin:密码
 ic 卡:
 cardType:卡类型
 cardSeqNum:卡序号
 cardNumber:卡号
 icData: icData
 encTrack2Ex: 二磁道信息
 pin:密码
 */
- (void)onReadCard:(NSDictionary *)data;

/**
 获取返回的错误码
 @param errorCode    错误码
 @param tradeType    交易类型
 @param message      交易信息，如无可以为nil
 */
- (void)onReceiveError:(NSString *)errorCode TradeType:(int)tradeType ErrorMessage:(NSString *)message;

/**
 PINBlock返回
 @param PINBlock 返回的密码,随机数,错误码
 */
- (void)onPinBlock:(NSDictionary *)PINBlock;

/**
 确认交易回调
 @param isSuccess  成功/失败
 */
- (void)onConfirmTransaction:(BOOL)isSuccess;

/**
 交易响应返回
 @param data 55域数据
 */
- (void)onResponseToTransaction:(NSData *)data;

/**
 下载商户号终端号结果
 @param result 是否下载成功
 */
- (void)onDownloadBusinessIDTerminalID:(BOOL)result;

/**
 更新AID结果
 @param isSuccess  成功/失败
 */
- (void)onUpdateAID:(BOOL)isSuccess;

/**
 更新RID结果
 @param isSuccess  成功/失败
 */
- (void)onUpdateRID:(BOOL)isSuccess;

/**
 错误码
 @param code
 */
- (void)onErrorCode:(NSInteger)code AndInfo:(NSString *)str;

@end

