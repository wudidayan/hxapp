//
//  TDAnimation.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDAnimation : NSObject

/**
 *	@brief	postion动画  来回晃动
 *
 *	@param 	lbl 	cclayer
 */
+(void)postionAnimation:(CALayer*)lbl;

/**
 *	@brief	 transform.scale动画  动态缩放（按比例缩放）
 *
 *	@param 	lbl 	CClayer
 */
+(void)transformScaleAnmation:(CALayer*)lbl;

/**
 *	@brief	bounds动画  (按rect缩放)
 *
 *	@param 	lbl 	CAlayer
 */
+(void)boundsAnimation:(CALayer*)lbl;

/**
 *	@brief	cornerRadius动画  动态倒原脚动画
 *
 *	@param 	lbl 	CAlayer
 */
+(void)cornerRadiusAnimation:(CALayer*)lbl;

/**
 *	@brief	contents动画  （渐隐动画）
 *
 *	@param 	lbl 	CAlayer
 */
+(void)contentsAnimation:(CALayer*)lbl;

/**
 *	@brief  shadowColor动画  背景变色 动画    －－>   还有背景偏移动画shadowOffset    背景圆角修改动画shadowRadius
 *
 *	@param 	lbl 	Calayer
 */
+(void)shadowColorAnimation:(CALayer*)lbl;

+(CABasicAnimation *)opacityForever_Animation:(float)time; //永久闪烁的动画
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time; //有闪烁次数的动画
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x; //横向移动
+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y; //纵向移动
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes; //缩放
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes; //组合动画
+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes; //路径动画
+(CABasicAnimation *)movepoint:(CGPoint )point; //点移动
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount; //旋转


@end
