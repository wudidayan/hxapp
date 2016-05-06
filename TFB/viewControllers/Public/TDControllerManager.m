//
//  TDControllerManager.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDControllerManager.h"
#import "TDLoginViewController.h"
#import "TDAPPCenterViewController.h"
#import "TDFinanceViewController.h"
#import "TDBusinessViewController.h"
#import "TDAppDelegate.h"
#import "TDViewController.h"
#import <UIKit/UIKit.h>

@interface TDControllerManager ()

@property (nonatomic,strong) UINavigationController * loginNav;
@property (nonatomic,strong) UITabBarController * tabar;
@property (nonatomic,assign) BOOL isCreatView;

@end

@implementation TDControllerManager

SYNTHESIZE_SINGLETON_FOR_CLASS(TDControllerManager)


- (void)setUpTabBarControllers{
   
    TDViewController * launchVC = [[TDViewController alloc]init];
    [TDAppDelegate sharedAppDelegate].window.rootViewController = launchVC;
    
    TDLoginViewController *loginVC = [[TDLoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [loginNav.navigationBar setBarStyle:UIBarStyleBlack];

    _loginNav = loginNav;

    [self performSelector:@selector(toLoginWithLaunchVC:) withObject:launchVC afterDelay:LAUNCH_TIME_CODE];
    
}
-(void)toLoginWithLaunchVC:(UIViewController *)launch{
  
   [launch presentViewController:_loginNav animated:YES completion:^{
       
   }];
}
- (void)popToLogin
{
    TDLoginViewController *loginVC = [[TDLoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [loginNav.navigationBar setBarStyle:UIBarStyleBlack];
    [TDAppDelegate sharedAppDelegate].window.rootViewController = loginNav;
    
//   [TDAppDelegate sharedAppDelegate].window.rootViewController = _loginNav;
}
- (void)totabber{
    
    [TDAppDelegate sharedAppDelegate].window.rootViewController = _tabar;
}
- (void)createTabbarController
{
    
    TDAPPCenterViewController *convenientVC = [[TDAPPCenterViewController alloc] init];
    convenientVC.title = @"首页";
    convenientVC.tabBarItem.image = [UIImage imageNamed:@"app"];
    convenientVC.tabBarItem.selectedImage = [UIImage imageNamed:@"app_blue"];
    convenientVC.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
    UINavigationController *convenientNav = [[UINavigationController alloc] initWithRootViewController:convenientVC];
    
    [convenientNav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    TDFinanceViewController *finaceVC = [[TDFinanceViewController alloc] init];
    finaceVC.title = @"更多";
    finaceVC.tabBarItem.image = [UIImage imageNamed:@"more"];
    finaceVC.tabBarItem.selectedImage = [UIImage imageNamed:@"more_blue"];
    finaceVC.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
    UINavigationController *finaceNav = [[UINavigationController alloc] initWithRootViewController:finaceVC];
    [finaceNav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    TDBusinessViewController *businessVC = [[TDBusinessViewController alloc] init];
    businessVC.tabBarItem.image = [UIImage imageNamed:@"pe"];
    businessVC.title = @"我的";
    businessVC.tabBarItem.selectedImage = [UIImage imageNamed:@"pe_blue"];
    businessVC.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
    UINavigationController *businessNav = [[UINavigationController alloc] initWithRootViewController:businessVC];
    [businessNav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    
    UITabBarController *mainTBC = [[UITabBarController alloc] init];
    _tabar = mainTBC;
    mainTBC.viewControllers = @[convenientNav, businessNav, finaceNav];
    

    [self customizeTabBarAppearance];
    [TDAppDelegate sharedAppDelegate].window.rootViewController = mainTBC;
    
}
- (void)customizeTabBarAppearance{

//    _tabar.tabBar.barTintColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
//    _tabar.tabBar.tintColor = [UIColor orangeColor];

}

-(void)creatServierMessageView{
    

    if (NO == _isCreatView) {
        _isCreatView = YES;
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(15, -45, [UIScreen mainScreen].bounds.size.width - 30, 40)];
        [[TDAppDelegate sharedAppDelegate].window addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.cornerRadius = 5.0f;
        bgView.alpha = 0.3f;
        
        UILabel * label = [[UILabel alloc]init];
        label.text = TITTLE_MESSAGE_TEXT;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        [bgView addSubview:label];
        [label sizeToFit];
        label.center = CGPointMake(bgView.bounds.size.width/2, bgView.bounds.size.height/2 + 2);
        
        [UIView animateWithDuration:0.5 animations:^{
            bgView.center = CGPointMake(bgView.center.x, bgView.center.y + 110);
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(endAnimationWithView:) withObject:bgView afterDelay:4];
        }];
    }
    

}
-(void)endAnimationWithView:(UIView *)view{
   
  [UIView animateWithDuration:0.5 animations:^{
     view.center = CGPointMake(view.center.x, view.center.y -110);
  } completion:^(BOOL finished) {
      _isCreatView = NO;
      [view removeFromSuperview];
  }];
}
@end
