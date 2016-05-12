//
//  TDHttpManager.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/9.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDHttpManager.h"
#import "GTMBase64.h"
#import "NSString+MD5Addition.h"
#import "NSString+MD5.h"
#import "JSONKit.h"
#import "CJCommon.h"
#import "TDControllerManager.h"
#import "MBProgressHUD.h"

#define SUFFIX @".json"
#define RSPCOD_SUCCEED      @"000000"   //成功响应码
#define RSPCOD_TIMEOUE      @"888888"   //在线超时，要求重新登录
#define RSPCOD_DERVICE      @"888889"   //其他设备登陆

@implementation TDHttpManager


/**
 *  把需要的参数转换为后台可以读得数据类型
 *
 *  @param sender 需要传得参数
 *
 *  @return 后台可以读的数据
 */
+ (NSDictionary *)jsonWithDic:(id)sender
{
    //固定参数
    [self addFixedValueWithDic:sender];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setObject:sender forKey:@"REQ_BODY"];
    
    NSString *md5Str = [[NSString stringWithFormat:@"%@%@",[sender JSONString],ZMK]  MD5];
    NSMutableDictionary *headDic = [[NSMutableDictionary alloc] init];
    [headDic setObject:md5Str forKey:@"SIGN"];
    [jsonDic setObject:headDic forKey:@"REQ_HEAD"];
    
    
    [dataDic setObject:[jsonDic JSONString] forKey:@"REQ_MESSAGE"];
    NSLog(@"请求报文：%@", dataDic);
    return dataDic;
    
}

+ (void)addFixedValueWithDic:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeStr = [timeFormatter stringFromDate:[NSDate date]];
    
    NSString *udidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    [sender setObject:@"2" forKey:@"sysType"]; //iOS
    [sender setObject:[[UIDevice currentDevice] systemVersion] forKey:@"sysVersion"];//系统版本
    [sender setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];//APP版本
    [sender setObject:udidStr forKey:@"sysTerNo"];//设备uuid
    [sender setObject:dateStr forKey:@"txnDate"];
    [sender setObject:timeStr forKey:@"txnTime"];
}

/**
 *  网路层
 *
 *  @param params    传参数据
 *  @param tradeCode 交易码
 *  @param complete  block回传
 */
+ (void)requestWithParams:(NSDictionary *)params tradeCode:(NSString *)tradeCode complete:(void(^)(BOOL succeed, NSString *msg, NSString *cod, NSDictionary * dictionary))complete
{
    MKNetworkEngine *networkEngine = [[MKNetworkEngine alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", HOST, tradeCode, SUFFIX];
    NSLog(@"交易码: %@", tradeCode);
    MKNetworkOperation *operation = [networkEngine operationWithURLString:url params:[self jsonWithDic:params] httpMethod:@"POST"];
    __weak MKNetworkOperation *weakOperation = operation;
    [weakOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@", weakOperation.responseString);
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString: RSPCOD_SUCCEED]) {
            if (complete) {
                
                complete(YES, [[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"],[diction objectForKey:@"REP_BODY"]);
            }
            
            return;
        }
        
        
        if ([[[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString: RSPCOD_TIMEOUE]){
            [MBProgressHUD hideAllHUDsForView:[self getCurrentVC].view animated:YES];
            [[self getCurrentVC].view makeToast:[[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"] duration:2.f position:@"center"];
            [[TDControllerManager sharedInstance] performSelector:@selector(popToLogin) withObject:nil afterDelay:2.5f];
            
            return;
            
        }else if ([[[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"] isEqualToString: RSPCOD_DERVICE]){
            [MBProgressHUD hideAllHUDsForView:[self getCurrentVC].view animated:YES];
            [[self getCurrentVC].view makeToast:[[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"] duration:2.f position:@"center"];
            [[TDControllerManager sharedInstance] performSelector:@selector(popToLogin) withObject:nil afterDelay:2.5f];
            
            return;
        }
        
        else {
            if (complete) {
                complete(NO, [[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPMSG"], [[diction objectForKey:@"REP_BODY"] objectForKey:@"RSPCOD"],nil);
            }
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error---> %@\r errmasage--->%@", error, [error localizedDescription]);
        
        [[TDControllerManager sharedInstance]creatServierMessageView];
        
        if (complete) {
            complete(NO, @"网络异常", nil,nil);
        }
        
    }];
    [networkEngine enqueueOperation:operation];
}
//参数异常捕获

+(BOOL)requestCanContinuationWith:(NSInteger)index andParams:(NSString *)params,...{

    va_list regs;
    va_start(regs, params);
    NSString * nilString = nil;
    NSInteger ind = 0;
    for (NSString * string=params; string != nil; string = va_arg(regs, NSString *)) {
    
        ind++;
        nilString = string;
        
    }
    va_end(regs);
   
    if (ind == index) { //YES为参数没问题
        return YES;
    }else{
        NSLog(@"--------> %@",nilString);
        return NO; //NO 参数有问题
    }
}


+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
