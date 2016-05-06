//
//  音频通信sdk接口
//  Created by hxtech  on 13-7-11.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MediaPlayer.h>
//#include "rmPrint.h"
//#include "oppara.h"
//@class PrintTemplate;
//@class PrintLines;

#define CHECKMAC

//大数据发送状态定义
enum
{
    BIG_DATA_SENDOK=0,//发送成功
    BIG_DATA_SENDING=1,//正在发送
    BIG_DATA_SENDFAIL=2//发送失败
};

//返回数据
typedef struct{
    char cmdType;//指令类型
    char result;//指令结果
    char cd2[100];//磁道2数据
    int cd2len;
    char cd3[100];//磁道3数据
    int cd3len;
    char cardMingWen[50];//卡号明文
    int cardMingWenLen;
    char cardValidDate[6];//卡有效期
    int cardValidDateLen;
    char random[9];//随机数
    int randomLen;
    char pin[9];   //密码密文
    int pinLen;
    char userInput[50]; //用户输入
    int userInputLen;
    char hardNo[100]; //硬件编号
    int hardNoLen;
    char psamNo[20]; //psam卡编号
    int psamNoLen;
    char money[20];
    int moneyLen;
    char mac[10];  //mac值
    int macLen;
    char  fkey;    //快捷键
    char termNo[9];//终端号码
    char merchNo[16];//商户号码
    
    char icReturnData[255];//ic指令返回数据
    int icReturnDataLen;
    
    char mac2[8]; // 单独计算mac得到的mac值
    int mac2Len;
    
    char updateTMK_Random[4];
    
    char generateAcRetData[255];
    int generateAcRetDataLen;
    
    char field55[255]; // /ic卡的55域数据
    int field55Len;
    
    char gen_ac2_retData[255];
    int gen_ac2_retDataLen;
    
    char pan[12];
    int panLen;
    char tradeType;
    char cardType;
    char pak8583[512];
    int pak8583Len;
    
    char mac8583[8];// 8583报文的mac值
    char posPara[512];
    int posParaLen;
    
    char memory[4];
    
    char merchNo2[15];
    char termNo2[9];
    
    char MissPakNo[50];
    char bigDataId[9];
    char bigDataCRC[8];
    
    char batLeft[10];
    int  batLeftLen;
    
    char userPDNo[40];
    int userPDNoLen;
    
    char pboc_9f1e[40];
    int pboc_9f1eLen;
    
    char pboc_9f4e[40];
    int pboc_9f4eLen;
    
    char aids[200];
    int aidsLen;
    
    char t5f34[4];
    int t5f34Len;
}Result;

//pboc参数更新回调接口
@protocol OnUpdatePBOCParaListener <NSObject>
-(void)onFinish:(int)resCode;
@end

//大数据传输回调接口
@protocol BigDataListener <NSObject>
-(void)onProgress:(int)curPakNo totalPakNo:(int)_total;
-(void)onFinish:(int)resCode;
@end

//通用f2f数据返回回调接口
@protocol OnRecvDelegate <NSObject>
@required
//data-去掉2字节长度，1字节方向，1字节类型，1字节采样频率的数据指针
//_len-去掉5字节头+1字节crc校验位后的数据长度
//res-0 接收ok  1-mac错误
- (void) OnRecvCallback:(int) res  bufAddr:(char*) data Len:(int)_len;
@end


//刷卡器拨出回调接口
@protocol MicOutDelegate <NSObject>
@required
- (void) micOutCallback;
@end

//刷卡器插入回调接口
@protocol MicInDelegate <NSObject>
@required
- (void) micInCallback;
@end

//获取PSAM卡信息回调接口
@protocol BootDelegate <NSObject>
@required
- (void) bootCallback : (unsigned char)status psamNo:(unsigned char*)psamNo battery:(unsigned char)battery softVersion:(unsigned char)softVersion;
@end

//刷卡并将卡号返回回调接口
@protocol GetPanDelegate <NSObject>
@required
- (void) getPanCallback : (unsigned char)status pan:(unsigned char*)pan panLen:(unsigned char)panLen;
@end

//加密磁道信息回调接口
//data-4字节随机数+磁道2加密数据+4字节随机数+3磁道加密数据
@protocol DesMsrDelegate <NSObject>
@required
- (void) desMsrCallback : (unsigned char)status data:(unsigned char*)data dataLen:(unsigned char)dataLen;
@end

//取消刷卡回调接口
@protocol CancelCmdDelegate <NSObject>
@required
- (void) cancelCmdCallback : (unsigned char)status;
@end

//加密PIN回调接口
@protocol DesPinDelegate <NSObject>
@required
- (void) desPinCallback : (unsigned char)status data:(unsigned char*)data dataLen:(unsigned char)dataLen;
@end

//计算MAC回调接口
@protocol CalMacDelegate <NSObject>
@required
- (void) calMacCallback : (unsigned char)status data:(unsigned char*)mac dataLen:(unsigned char)macLen;
@end

//关机回调接口
@protocol PowerOffDelegate <NSObject>
@required
- (void) powerOffCallback : (unsigned char)status;
@end


#define NOTIFY_RECORDDATA @"NOTIFY_RECORDDATA"

extern bool recflag;

//通信模式定义
enum{
    COMM_MODE_VOC,//音频通信
    COMM_MODE_BLUE//蓝牙通信
};
@interface hxpos:NSObject
{
    //发送音频数据采样点缓冲地址
    short* mbuf;
    //发送数据音频采样点数量
    int mbuflen;
    
    //通信模式
    int commMode;
    
    id<OnRecvDelegate> onRecvDelegate;
    
    /*fuyou接口*/
    id<BootDelegate> bootDelegate;
    id<GetPanDelegate> getPanDelegate;
    id<DesMsrDelegate> desMsrDelegate;
    id<CancelCmdDelegate> cancelCmdDelegate;
    id<DesPinDelegate> desPinDelegate;
    id<CalMacDelegate> calMacDelegate;
    id<PowerOffDelegate> powerOffDelegate;
    id<MicOutDelegate> micOutDelegate;
    id<MicInDelegate> micInDelegate;
    id<BigDataListener> bigDataDelegate;
    id<OnUpdatePBOCParaListener> updatePbocParaDelegeta;
}
@property(assign,readwrite) int commMode;
@property(retain,nonatomic) NSTimer *itTimer;
@property(nonatomic,retain) id<OnRecvDelegate> onRecvDelegate;

//得到音频对象的全局变量
+(hxpos*)getInstance;

-(void)setMode:(int) mode;
-(int)getMode;
-(void)setDelegate:(id) delegate;
//打开音频/蓝牙收发数据功能
-(void)open;
//关闭音频收发数据功能
-(void)close;
//初始化,一般在viewDidLoad函数中创建对象后调用一次，
- (id)init;
- (int)hasHeadset;
//工具函数，打印二进制缓冲区内容
//-(void)HexPrint:(char*)data Len:(int)_len;

//放音音量控制,该函数暂时没有用处，100最大，0最小
-(void)setVloumn:(NSInteger )vol;

//启动录音，启动数据接收
-(void) StartRec;

//停止录音，停止数据接收
-(void)StopRec;


//发送指令数据
//cmd-从协议版本字段到数据的十六进制值
//0-ok -1 失败
-(int) playCmd2:(unsigned char*)cmd len:(int)_len;


#pragma mark-
#pragma mark 蓝牙相关函数
//发送蓝牙数据
//返回：
//0-发送成功 -1-发送失败
-(int) sendBLEData:(unsigned char*)data head2:(char*)_herd2 Len:(int)_len;
//蓝牙pos是否保持连接
-(bool) isBLEPOSConneted;
#pragma mark-


/*fuyou接口*/
@property (retain) id<BootDelegate> bootDelegate;
@property (retain) id<GetPanDelegate> getPanDelegate;
@property (retain) id<DesMsrDelegate> desMsrDelegate;
@property (retain) id<CancelCmdDelegate> cancelCmdDelegate;
@property (retain) id<DesPinDelegate> desPinDelegate;
@property (retain) id<CalMacDelegate> calMacDelegate;
@property (retain) id<PowerOffDelegate> powerOffDelegate;
@property (retain) id<MicOutDelegate> micOutDelegate;
@property (retain) id<MicInDelegate> micInDelegate;
@property (retain) id<BigDataListener> bigDataDelegate;
@property (retain) id<OnUpdatePBOCParaListener> updatePbocParaDelegeta;

//@property (assign) int recvAutoAdapterVolumeIndex;


-(int) getRecvSeqNO;
-(int) getSendSeqNo;
-(int) GetVer;


//保存通用数据
-(int)SendSaveGeneralData:(int)dataName data:(char*)_data datalen:(int)_datalen;

//读取通用数据
-(int)SendReadGeneralData:(int) dataName;


//发送原始指令
-(int)SendRawCmd:(char*)cmd len:(int)_len;

//读取商户号码和终端号码
-(int)SendReadTermAndMerchNo;

//保存终端号码和商户号码
//termNo-终端号码
//_merchNo-商户号码，0结尾字符串
-(int)SendSaveTermAndMerchNo:(char*) termNo MerchNO:(char*)_merchNO;


//更新主密钥
//tmk-主密钥
//_tmkLen-主密钥长度
//_tmkIndex-主密钥索引 0,1
-(int)SendSaveTMKInPos:(unsigned char*)tmk tmkLen:(int)_tmkLen tmkIndex:(int)_tmkIndex;


//更新密钥
//keyType-密钥类型 数字212表示密钥长度为16，8，16字节；111表示密钥长度为8，8，8字节
//_keys-密钥
-(int)SendUpdateKey:(int) keyType
               Keys:(unsigned char*)_keys Len:(int)_len
              icsrc:(int)_icsrc adf:(int)_adf startKeyIndex:(int)_startKeyIndex;


-(int) SendSwipeCard2:(unsigned char) timeoutSec
         cardKeyIndex:(unsigned char )_cardKeyIndex
                money:(char*)_money moneyLen:(unsigned char)_moneyLen
            appendata:(unsigned char*)_append appenddata_len:(int)_appenddata_len;

// 加密刷卡指令
// timeoutSec-超时的秒数 0-设备默认
// cardKeyIndex-加密密钥索引
// random-加密用随机数,不需要填写null
// needCardMingWen-是否需要卡号明文 1-需要 0-不需要
// needValidDate-是否需要卡有效期 1-需要 0-不需要
// needConfirKey-是否需要刷卡确认 1-需要 0-不需要
// money-ic卡交易的金额.
// desmode-0-不加密;1-加密后8字节;2-全加密
// appenddata-附加数据,目前是pboc的9c交易参数，十六进制表示
//
-(int) SendSwipeCard:(unsigned char) timeoutSec
        cardKeyIndex:(unsigned char )_cardKeyIndex
              random:(unsigned char*)_random randomLen:(unsigned char )_randomLen
     needCardMingWen:(unsigned char)_needCardMingWen
       needValidDate:(unsigned char)_needValidDate
       needConfirKey:(unsigned char)_needConfirKey
               money:(char*)_money moneyLen:(unsigned char)_moneyLen
             desMode:(unsigned char)_desmode
           appendata:(unsigned char*)_append appenddata_len:(int)_appenddata_len;

// 输入密码指令
// 输入参数:
// timeoutSec-超时的秒数 0-设备默认
// pinKeyindex:加密密钥索引，从0开始
// random：加密用的随机数，null或3或8字节
// needPan:1-需要Pan码，从之前的刷卡指令得到; 0-不需要 ;2-用参数的pan
// money-输入密码时显示的金额
// pan-pan码
// 返回:0-成功;-1-失败
-(int) SendInputPass:(unsigned char)  timeoutSec
         pinKeyIndex:(unsigned char)_pinKeyIndex
              random:(char*)_random randomLen:(int)_randomLen
             needPan:(int)_needPan
               money:(char*)_money moneyLen:(int)_moneyLen
                 pan:(char*)_pan  panLen:(int)_panLen;
// 连续操作指令
// ops-组合指令
//_cmdcnt-组合指令个数
// 返回值： 0-发送ok
// 其他值-指令错误
-(int) SendZuHe:(void*)cmds  cmdCnt:(int)_cmdcnt;

// 输入金额
// 输入参数
// timeoutSec-指令超时时间
// country-货币类型
// 返回：
// 0-指令发送成功
// 1-指令错误
-(int )SendInputMoney:(unsigned char)  timeoutSec country:(unsigned char)_country;




// 用户输入指令
-(int) SendUserInput:(unsigned char) timeoutSec
           inputType:(int)_inputType
            LenLimit:(int)_LenLimit
         NeedReInput:(int)_NeedReInput
               gdLen:(int) _gdLen
           inputHint:(char*)_inputHint inputHintLen:(int)_inputHintLen;


// 读取编号指令
-(int) SendReadNo:(int) icsrc;


// 发送保存打印模板指令
-(int) SendSavePrintTemplate:(void*) vpt;

// 发送打印指令
// pt-打印模板
-(int)SendPrint:(void*) vpl pages:(int)_pages;
// 在屏幕显示信息，可以自动换行，从左上角开始显示。
// 汉字最多8列4行,英文最多16列4行。
// 输入参数：
// timeoutSec-显示的超时间隔秒数
// 返回:
// 0-正确
// 1-字符数超过限制
// 2-汉字编码转换错误
-(int) SendShowInfo:(unsigned char)timeoutSec str:(char*)_str;

//发送GenAc1指令
-(int) SendGenerateAC:(unsigned char*) cmd len:(int)_len;

//发送交易结束指令
-(int)SendPBOCEndDeal:(unsigned char*)field55 field55Len:(int)_f55len//银行返回的55域
                  f39:(unsigned char*)_f39;  //银行返回的39域
//ic卡复位指令
-(int)SendICReset;
//ic卡透传指令
-(int)SendICCmd:(int)cmdpara cmdbytes:(unsigned char*)_cmdbytes cmdLen:(int)_cmdlen;
//计算mac
-(int)SendCalMac:(unsigned char)keyPara data:(unsigned char*)_data  dataLen:(int)_datalen;

//更新开机界面
-(int) SendUpdateMainInterface:(unsigned char)ShowBG mstr:(char* )_mstr;

//单指令类型函数
-(int)SendCmd:(int)cmdType;

//发送8583返回包
-(int)Send8583Result:(char*)pak8583 len:(int)_len;

//读取pos数据
-(int)SendReadData:(char*)dataName Len:(int)_len;


//翻译返回数据为字符型数据
-(NSString*)getResultStr:(Result*)res;

//解析返回数据
-(int) ParseResult:(char*)data len:(int) dataLen res:(Result*)_res;


#pragma mark 辅助函数
-(char*) B2H:(char*)bin Len:(int)_len;
-(char) makeKeyIndex:(char) icsrc dfno:(char)_dfno keyIndex:(char)_kind;
-(char*) H2B:(char*)hval;
+(char*) UTF82Char:(NSString*) nstr;
+(void) recfile:(short*) buf  buflen:(int)_buflen;
//是否收到数据
-(bool)receivedData;

//获取接收数据
-(void)getRecvData:(char*)buf recvLen:(int*)_rlen;
//重置接收状态
-(void)resetRecv;

//清空列表
-(void)UpdatePBOCClear;

//添加参数到列表
//返回值：0成功，其他失败
-(int)UpdatePBOCAddPara:(char*) field62 len:(int)_field62len;

//上传PBOC参数
-(void)UploadPBOCPara;
//更新pboc参数
-(void)UpdatepbocPara:(int)type;

//发送大数据
//buf－大数据地址
//_buflen-大数据长度，不能超过50K字节
-(int)BigBufSend:(char*) buf buflen:(int)_buflen type:(int)_type;


-(void)play01;
-(void)stopPlay01;

//辅助函数
char* utf82Char(NSString* nstr);
void calMac(char* buf ,int buflen,char* mac);
char* HexToBin(char* hin);
char* b2hex(char* bin,int off,int len);
@end


