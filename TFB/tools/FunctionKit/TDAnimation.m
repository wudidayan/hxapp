//
//  TDAnimation.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/18.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDAnimation.h"

@implementation TDAnimation


/**
 *	@brief	postion动画  来回晃动
 *
 *	@param 	lbl 	cclayer
 */
+(void)postionAnimation:(CALayer*)lbl
{
    
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-20, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+20, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.2];
    [animation setRepeatCount:300];
    [lbl addAnimation:animation forKey:nil];
}
/**
 *	@brief	 transform.scale动画  动态缩放（按比例缩放）
 *
 *	@param 	lbl 	CClayer
 */
+(void)transformScaleAnmation:(CALayer*)lbl
{
    
    CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //    pulse.duration = 1.5+(rand()%10) * 0.05;
    pulse.duration = 2;
    pulse.repeatCount = 2;
    
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.1];
    pulse.toValue = [NSNumber numberWithFloat:2];
    pulse.byValue = [NSNumber numberWithFloat:1.0f];
    [lbl addAnimation:pulse forKey:nil];
    
}
/**
 *	@brief	bounds动画  (按rect缩放)
 *
 *	@param 	lbl 	CAlayer
 */
+(void)boundsAnimation:(CALayer*)lbl
{
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    anim.duration = 1.0f;
    anim.fromValue =  [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(10, 10, 200, 100)];
//    anim.byValue = [NSValue valueWithCGRect:self.image.bounds];
    
    //    anim.toValue = (id)[UIColor redColor].CGColor;
    //    anim.fromValue = (id)[UIColor blackColor].CGColor;
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    [lbl addAnimation:anim forKey:nil];
}
/**
 *	@brief	cornerRadius动画  动态倒原脚动画
 *
 *	@param 	lbl 	CAlayer
 */
+(void)cornerRadiusAnimation:(CALayer*)lbl
{
    
    CABasicAnimation * anim2 =[CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    anim2.duration = 2.0f;
    anim2.fromValue = [NSNumber numberWithFloat:0.0f];
    anim2.toValue = [NSNumber numberWithFloat:60.0f];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim2.repeatCount = CGFLOAT_MAX;
    anim2.autoreverses = YES;
    [lbl addAnimation:anim2 forKey:nil];
}
/**
 *	@brief	contents动画  （渐隐动画）
 *
 *	@param 	lbl 	CAlayer
 */
+(void)contentsAnimation:(CALayer*)lbl
{
    
    CABasicAnimation * contents = [CABasicAnimation animationWithKeyPath:@"contents"];
    contents.duration = 1.f;
    contents.fromValue = (id)[UIImage imageNamed:@"Icon"].CGImage;
    contents.toValue = (id)[UIImage imageNamed:@"tokenHighlighted"].CGImage;
    //        contents.toValue = (id)[UIColor redColor].CGColor;
    //        contents.fromValue = (id)[UIColor blackColor].CGColor;
    
    contents.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    contents.repeatCount = 1;
    contents.autoreverses = NO;
    //    self.image.image = [UIImage imageNamed:@"tokenHighlighted"];
    [lbl addAnimation:contents forKey:nil];
    
}
/**
 *	@brief  shadowColor动画  背景变色 动画    －－>   还有背景偏移动画shadowOffset    背景圆角修改动画shadowRadius
 *
 *	@param 	lbl 	Calayer
 */
+(void)shadowColorAnimation:(CALayer*)lbl
{
    
    
    CABasicAnimation * shadowColor = [CABasicAnimation animationWithKeyPath:@"shadowColor"];
    shadowColor.duration = 1.f;
    shadowColor.fromValue = (id)[UIColor greenColor].CGColor;
    shadowColor.toValue = (id)[UIColor purpleColor].CGColor;
    
    
    shadowColor.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    shadowColor.repeatCount = CGFLOAT_MAX;
    
    shadowColor.autoreverses = YES;
    [lbl addAnimation:shadowColor forKey:nil];
    
}

#pragma mark -几个可以用来实现热门APP应用PATH中menu效果的几个方法

+(CABasicAnimation *)opacityForever_Animation:(float)time //永久闪烁的动画

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    
    animation.toValue=[NSNumber numberWithFloat:0.0];
    
    animation.autoreverses=YES;
    
    animation.duration=time;
    
    animation.repeatCount=FLT_MAX;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes durTimes:(float)time //有闪烁次数的动画

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    
    animation.toValue=[NSNumber numberWithFloat:0.4];
    
    animation.repeatCount=repeatTimes;
    
    animation.duration=time;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.autoreverses=YES;
    
    return  animation;
    
}



+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x //横向移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.toValue=x;
    
    animation.duration=time;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y //纵向移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animation.toValue=y;
    
    animation.duration=time;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes //缩放

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue=orginMultiple;
    
    animation.toValue=Multiple;
    
    animation.duration=time;
    
    animation.autoreverses=YES;
    
    animation.repeatCount=repeatTimes;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}

+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes //组合动画

{
    
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    
    animation.animations=animationAry;
    
    animation.duration=time;
    
    animation.repeatCount=repeatTimes;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes //路径动画

{
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.path=path;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animation.autoreverses=NO;
    
    animation.duration=time;
    
    animation.repeatCount=repeatTimes;
    
    return animation;
    
}



+(CABasicAnimation *)movepoint:(CGPoint )point //点移动

{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
    animation.toValue=[NSValue valueWithCGPoint:point];
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}



+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount //旋转

{
    
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    
    CABasicAnimation* animation;
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    
    animation.duration= dur;
    
    animation.autoreverses= NO;
    
    animation.cumulative= YES;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    animation.repeatCount= repeatCount;
    
    animation.delegate= self;
    
    
    
    return animation;
    
}

@end
