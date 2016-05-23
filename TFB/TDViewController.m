//
//  TDViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/14.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDViewController.h"
#import "TDAnimation.h"
#import "UIImage+Reflection.h"
#define IMAGE_HIGHT_R   0.5

@interface TDViewController ()

@end

@implementation TDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage * image = [UIImage imageNamed:@"td_app_logo"];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:(CGRect){{0,0},image.size}];
    imageV.image = image;
    [self.view addSubview:imageV];
    imageV.center = CGPointMake(self.view.bounds.size.width/2, -image.size.height);
    [UIView animateWithDuration:1.0f animations:^{
        imageV.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-60);
    } completion:^(BOOL finished) {
       
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(imageV.frame.origin.x,
                                                                           CGRectGetMaxY(imageV.frame)+2,
                                                                           imageV.frame.size.width,
                                                                           imageV.frame.size.height * IMAGE_HIGHT_R)];
        [self.view addSubview:image];
        /*
        [image setImage:[[imageV image] reflectionWithAlpha:0.3]];
        [image setImage:[[imageV image] reflectionRotatedWithAlpha:0.05]];
        [image setImage:[[imageV image] reflectionWithHeight:imageV.frame.size.height]];
        */
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
