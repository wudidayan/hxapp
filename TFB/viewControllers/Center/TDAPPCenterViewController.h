//
//  TDAPPCenterViewController.h
//  TFB
//
//  Created by 德古拉丶 on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBaseViewController.h"
#import "SDWebImageManager.h"
#import "TDNoticeInfo.h"
#import "TDBankCardInfo.h"
@interface TDAPPCenterViewController : TDBaseViewController<UIGestureRecognizerDelegate,SDWebImageManagerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutletCollection(UITapGestureRecognizer) NSArray *tapArray;
- (IBAction)clickmainButton:(UIButton *)sender;
- (IBAction)clickTap:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *tittleScroll;
@property (strong,nonatomic) TDNoticeInfo * noticeInfo;

@end
