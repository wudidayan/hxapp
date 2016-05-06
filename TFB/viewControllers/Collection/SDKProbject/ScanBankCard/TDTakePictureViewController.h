//
//  TDTakePictureViewController.h
//  TFB
//
//  Created by YangTao on 16/3/25.
//  Copyright © 2016年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "TDPayInfo.h"
@interface TDTakePictureViewController : TDBaseViewController

@property (nonatomic,strong) TDPayInfo * payInfo;

@property (copy, nonatomic) NSString *only;
@property (copy, nonatomic) NSString *prdordno;

@end
