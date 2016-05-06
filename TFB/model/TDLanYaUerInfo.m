//
//  TDLanYaUerInfo.m
//  TFB
//
//  Created by qq on 15/7/21.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDLanYaUerInfo.h"

@implementation TDLanYaUerInfo

+(TDLanYaUerInfo *)sharePayDefault{
    
    static TDLanYaUerInfo * payInfo;
    if (!payInfo) {
        payInfo = [[TDLanYaUerInfo alloc]init];
    }
    return payInfo;
}

- (void)initWithDictionary:(NSDictionary *)dic withMiMa:(NSDictionary *)mDic{
    
//    self = [super init];
//    if ( self) {
    
        
        NSLog(@"mDic:=000000000000----------%@",dic);
        if (dic) {
            self.encTrack1  =  [dic objectForKey:@"encTrack1"];
            self.PAN        = [dic objectForKey:@"PAN"] ;
            self.expiryDate = [dic objectForKey:@"expiryDate"];
            self.encTrack2  = [dic objectForKey:@"encTrack2"];
            self.encTrack3  = [dic objectForKey:@"encTrack3"];
            self.formatID   = [dic objectForKey:@"formatID"];
            self.iccNo      = [dic objectForKey:@"iccNo"] ;
            self.psamNo         = [[dic objectForKey:@"psamNo"]substringToIndex:POSSDK_KSN_NUM_CODE];
            self.randomNumber   = [dic objectForKey:@"randomNumber"] ;
            self.serviceCode    = [dic objectForKey:@"serviceCode"] ;
            self.terminalNo     = [dic objectForKey:@"terminalNo"] ;
            self.track3Length   = [dic objectForKey:@"track3Length"] ;
            self.track2Length   = [dic objectForKey:@"track2Length"] ;
            self.maskedPAN      = [dic objectForKey:@"maskedPAN"];
            self.iccKaType=@"01";
            self.fiftyFiveYu=@"";
            self.crdnum=@"";
            if (self.encTrack2) {
                if (self.encTrack3!=nil) {
                 self.encTrack2=[NSString stringWithFormat:@"%@|%@",self.encTrack2,self.encTrack3];
                }else{
                     self.encTrack2=[NSString stringWithFormat:@"%@|",self.encTrack2];
                }
                
            }
        }
    
}
-(void)setIcccDic:(NSDictionary *)iccDic
{
    self.epb         =      iccDic[@"99"];
    self.encTrack2   =      [NSString stringWithFormat:@"%@|",iccDic[@"encTrack2Eq"]];
    self.PAN         =      [iccDic objectForKey:@"maskedPAN"] ;
    self.fiftyFiveYu =      iccDic [@"encOnlineMessage"];
    self.ksn         =      iccDic[@"onlineMessageKsn"];
    self.expiryDate  =      [iccDic objectForKey:@"5F24"];
    self.randomNumber   =   [iccDic objectForKey:@"encTrack2EqRandomNumber"] ;

    NSMutableString *strPan = [NSMutableString stringWithFormat:@"%@",self.PAN];
   [strPan replaceCharactersInRange:NSMakeRange(6, strPan.length-11) withString:@"*****"];
    self.maskedPAN   =      (NSString *)strPan;
    self.crdnum     =      iccDic[@"5F34"];
    if (self.fiftyFiveYu) {
        self.iccKaType=@"02";
    }
    
}
-(void)setMdic:(NSDictionary *)mDic
{
    if (mDic) {
        self.epb=[mDic objectForKey:@"epb"];
    
    }
}
@end
