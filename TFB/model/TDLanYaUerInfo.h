//
//  TDLanYaUerInfo.h
//  TFB
//
//  Created by qq on 15/7/21.
//  Copyright (c) 2015年 TD. All rights reserved.
//


#import "TDBaseModel.h"
#import "TDTerm.h"
@interface TDLanYaUerInfo : TDBaseModel
//刷卡的时候的数据
//PAN = 6214831214565555;
//encTrack1 = "";
//encTrack2 = 58F3162F56ABBA6533CD6FDBE78032CF6952F17DA1BC9AEC;
//encTrack3 = "";
//expiryDate = 2406;
//formatID = 64;
//iccNo = 00000000;
//maskedPAN = 621483XXXXXX5555;
//psamNo = 88883333666601E0;
//randomNumber = 19782667471E4D0F;
//serviceCode = 220;
//terminalNo = 00000000;
//track2Length = 37;
//track3Length = 0;



@property (nonatomic, strong) NSString* PAN;//银行卡号不加x
@property (nonatomic, strong) NSString* expiryDate;//有限期
@property (nonatomic, strong) NSString* formatID;
@property (nonatomic, strong) NSString* iccNo;
@property (nonatomic,strong)  TDTerm  * termInfo;
@property (nonatomic, strong) NSString* maskedPAN;//银行卡号
@property (nonatomic, strong) NSString* psamNo;
@property (nonatomic, strong) NSString* randomNumber;//随机数
@property (nonatomic, strong) NSString* serviceCode;
@property (nonatomic, strong) NSString* terminalNo;
@property (nonatomic, strong) NSString* track3Length;
@property (nonatomic, strong) NSString* track2Length;
@property (nonatomic, strong) NSString* encTrack1;//磁道
@property (nonatomic, strong) NSString* encTrack2;//磁道
@property (nonatomic, strong) NSString* encTrack3;//磁道
@property (nonatomic,strong)  NSString* payType;//状态，刷卡还是插卡
@property (nonatomic,strong)  NSString* payAmt;//交易金额
@property (nonatomic,strong)  NSString* epb;//密码块
@property (nonatomic,strong)  NSString* randomNumberMiMa;//密码随机数
@property (nonatomic,strong)  NSString* prdordNo;//订单号
@property(nonatomic,strong)   NSString* type;
@property(nonatomic,strong)   NSString* fiftyFiveYu;
@property(nonatomic,strong)   NSString* ksn;
@property(nonatomic,strong)   NSString* iccKaType;
@property(nonatomic ,strong)  NSString* crdnum;
@property (nonatomic,strong) NSString *pinblk;
//@property (nonatomic, strong)  NSString *randomNumber; // 随机数

//PAN = 6212261001021045379;
//encTrack2 = D69C6E4E331D2EFEC7F94801C004CFC5911ACEA0538F5D98;
//encTrack3 = DB797D1994E06B0D8EFEB2C0D599E7043DBC60341391188D3597CA97FBE5A757B2F778EAAAD3B95EE8DF7B36FA2E8E12F1E15765F0433054;
//expiryDate = 2404;
//formatID = 65;
//ksn = 63150700000002;
//serviceCode = 220;

//    {
//        4F = A000000333010101;
//        5F20 = 2020202020202020202020202020202020202020;
//        5F24 = 240430;
//        5F30 = 0220;
//        5F34 = 01;
//        95 = 00A0048800;
//        99 = 41C468DE71935FCC;
//        9A = 000000;
//        9B = E800;
//        9C = 00;
//        9F02 = 000000000500;
//        9F12 = 494342432050626F6343617264;
//        9F1A = 0156;
//        9F1C = 3131323233333434;
//        9F26 = 935DF414AE870380;
//        9F27 = 80;
//        C0 = 63150700000002;
//        C1 = 00000000000000000000;
//        C2 = E58491F42A43259433DAD7174A949E9093033F6540F429EE311370A1532623A3574875227E7FB0DBF1778D833D4882253CDA34C9311E34257AC6EDAF37EC4A11206F042D1E77579F2C7C42EC5F884681661FA6844ECDC370FE0CC13F5DDE040E6EC804D604A7725ECC0C82A0BC4EF72F94CA3E6220200FA21D1C1B8D6763B45A921451A4B4376106AEB2B59AACD06FF241EC68A1353C0795;
//        C4 = 6212261001021045379F;
//        C8 = 849611E99A10CA3E39A38FDC4228F5AA8341250AE38B9F3A;
//        encOnlineMessage = E58491F42A43259433DAD7174A949E9093033F6540F429EE311370A1532623A3574875227E7FB0DBF1778D833D4882253CDA34C9311E34257AC6EDAF37EC4A11206F042D1E77579F2C7C42EC5F884681661FA6844ECDC370FE0CC13F5DDE040E6EC804D604A7725ECC0C82A0BC4EF72F94CA3E6220200FA21D1C1B8D6763B45A921451A4B4376106AEB2B59AACD06FF241EC68A1353C0795;
//        encTrack2Eq = 849611E99A10CA3E39A38FDC4228F5AA8341250AE38B9F3A;
//        maskedPAN = 6212261001021045379;
//        onlineMessageKsn = 63150700000002;
//        onlinePinKsn = 00000000000000000000;
//    }



+ (TDLanYaUerInfo *)sharePayDefault;
- (void)initWithDictionary:(NSDictionary *)dic withMiMa:(NSDictionary *)mDic;
- (void)setMdic:(NSDictionary *)mDic;
- (void)setIcccDic:(NSDictionary *)iccDic;
@end
