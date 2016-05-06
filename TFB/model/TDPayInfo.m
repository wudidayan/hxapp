//
//  TDPayInfo.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDPayInfo.h"

@implementation TDPayInfo

-(TDPayInfo *)sharePayDefault{

    static TDPayInfo * payInfo;
    if (!payInfo) {
        payInfo = [[TDPayInfo alloc]init];
    }
    return payInfo;
}

-(void)SwipeWithDictionary:(NSDictionary *)dic{
    
    
    if ([[dic objectForKey:@"ICNumber"] isEqualToString:@""] || ![dic objectForKey:@"ICNumber"]) {
        
        self.mediaType = @"01";
    }else{
        
        self.mediaType = @"02";
    }
    /* 这里每换一个接口都需要修改 */
    //    if ([_mediaType isEqualToString:@"01"]) {//磁条卡刷卡
    //        if ([dic objectForKey:@"ksn"]) {
    //            self.termNO = [dic objectForKey:@"ksn"];
    //        }else{
    //           self.termNO = @"";
    //        }
    if ([dic objectForKey:@"encTrankSecond"]) {
        
        //NSString *track = [[NSString alloc] initWithData:[dic objectForKey:@"encTrankSecond"] encoding:NSUTF8StringEncoding];
        self.track = [NSString stringWithFormat:@"%@|",[dic objectForKey:@"encTrankSecond"]];
    }else{
        self.track = @"";
    }
    if ([dic objectForKey:@"randomNumber"]) {
        _random = [dic objectForKey:@"randomNumber"];
    }else{
        _random = @"";
    }
    if ([dic objectForKey:@"expiryDate"]) {
        _period = [dic objectForKey:@"expiryDate"];
    }else{
        _period = @"";
    }
    if ([dic objectForKey:@"DcData"]) {
        _icdata = [dic objectForKey:@"DcData"];
    }else{
        _icdata = @"";
    }
    if ([dic objectForKey:@"ICNumber"]) {
        _crdnum = [dic objectForKey:@"ICNumber"];
    }else{
        _crdnum = @"";
    }
    if ([_mediaType isEqualToString:@"02"]){  //icc卡插卡
        
        if ([dic objectForKey:@"expiryDate"]) {
            _period = [dic objectForKey:@"expiryDate"];
        }else{
            _period = @"";
        }
        
        
    }
    
    if ([dic objectForKey:@"mac"]) {
        _mac = [dic objectForKey:@"mac"];
    }else{
        _mac = @"";
    }
    


}
/*
DcData = "";
ICNumber = "";
cardHolderName = "";
encData = "";
encTracks = 137A32F9BDDE3EC881C7500545224706A3465FE493CE6A51FEE68F963CC60411260EB135F1BAAFFAEAE8C5328C5D71E01AB99CBDA8D3C7809E15354413E85A9262D080395284E86D184FE6A3BEA4A954;
expiryDate = 2304;
formatID = 64;
ksn = CF0300000206;
maskedPAN = 622848XXXXXXXXX8873;
nDate = 2304;
randomNumber = 7C4912B24E6788BE;
*/
/*
 *  @param payType    支付方式
 *  @param rate       费率类型
 *  @param termNo     终端号
 *  @param termType   终端类型
 *  @param payAmt     交易金额
 *  @param track      磁道信息
 *  @param pinblk     密码密文
 *  @param random     随机数     C		音频设备时使用
 *  @param mediaType  介质类型	C		01 磁条卡 02 IC卡
 *  @param period     有效期     C		mediaType 02时必填
 *  @param icdata     55域      C		mediaType 02时必填
 *  @param crdnum     卡片序列号	C		mediaType 02时必填
 *  @param mac        Mac       C		设备计算的mac
 *  @param complete   block回传
 */
@end
