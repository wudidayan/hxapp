//
//  SBankCard.h
//  SBankCard
//
//  Created by etop on 15/11/5.
//  Copyright © 2015年 etop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SBankCard : NSObject

//识别结果
@property(copy, nonatomic) NSString *nsNo; //银行卡号

@property(strong, nonatomic) UIImage *resultImg;//银行卡号区域图像（400*70）

//初始化核心
-(int)initSBankCard:(NSString *)nsUserID nsReserve:(NSString *) nsReserve;
//设置银行卡的检测区域
-(void)setRegionWithLeft:(int)left Top:(int)top Right:(int)right Bottom:(int)bottom;
//识别
- (int) recognizeSBankCard:(UInt8 *)buffer Width:(int)width Height:(int)height;
//释放核心
- (void) freeSBankCard;
@end
