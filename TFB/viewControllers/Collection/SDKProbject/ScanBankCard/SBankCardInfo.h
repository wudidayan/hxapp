//
//  SBankCardInfo.h
//  SBankCardInfo
//
//  Created by etop on 16/5/12.
//  Copyright © 2016年 etop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBankCardInfo : NSObject
//识别结果
@property(copy, nonatomic) NSString *nsBankName; //开户行名称
@property(copy, nonatomic) NSString *nsCardName; //卡名称
@property(copy, nonatomic) NSString *nsBankCode; //银行代码
@property(copy, nonatomic) NSString *nsCardType; //卡类型



//初始化核心
-(int) initSBankCardInfo;
//获取卡号信息
-(int) getSBankCardInfo:(NSString *)nsBankCardNo;
//释放核心
-(void) freeSBankCardInfo;
@end
