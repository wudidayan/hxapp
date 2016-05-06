//
//  TDControllerManager.h
//  TFB
//
//  Created by 德古拉丶 on 15/5/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDControllerManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(TDControllerManager)

- (void)setUpTabBarControllers;
- (void)createTabbarController;

- (void)popToLogin;
- (void)totabber;

-(void)creatServierMessageView;
@end
