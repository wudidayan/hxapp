//
//  TDBaseViewController.m
//  TFB
//
//  Created by Nothing on 15/4/10.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDLoginViewController.h"
@interface TDBaseViewController (){


    UIMotionEffectGroup *_motionEffectGroup;

}



@end

@implementation TDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self applyMotionEffects];
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
  
}
-(void)backButton{

    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickbackButton)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;

}
-(void)clickbackButton{

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)creatLayerWithView:(UIView *)view{

    view.layer.cornerRadius = 5.0f;
    view.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    view.layer.shadowOffset = CGSizeMake(2, 2);//偏移距离
    view.layer.shadowOpacity = 1;//不透明度
    view.layer.shadowRadius = 5.0;//半径
    view.layer.shadowPath =[UIBezierPath bezierPathWithRect:view.bounds].CGPath;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//晃动动画  7  才有效
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_7_0) {
       
        
        UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                        type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalEffect.minimumRelativeValue = @( 20);
        horizontalEffect.maximumRelativeValue = @(-20);
        
        UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                      type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalEffect.minimumRelativeValue = @( 20);
        verticalEffect.maximumRelativeValue = @(-20);
        
        UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
        _motionEffectGroup = motionEffectGroup;
        motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
        
        [self.view addMotionEffect:motionEffectGroup];
    }

}

-(void)dealloc{
    
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_7_0) {
        //[self.view removeMotionEffect:_motionEffectGroup];
    }

}

@end
