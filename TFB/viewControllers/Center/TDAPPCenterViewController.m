//
//  TDAPPCenterViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDAPPCenterViewController.h"
#import "TDCollectionMoneyViewController.h"
#import "UIImageView+WebCache.h"
#import "TDDynamicImg.h"
#import "TDNoticeTableViewController.h"
#import "TDAppDelegate.h"
#import "HFBSwipeViewController.h"
#import "TDSearchNewLandBlueTViewController.h"
#import "TDRealCertificationViewController.h"
#import "TDBalanceViewController.h"
#import "TDDrawingCashViewController.h"
#define kDuration 1.0f
#define CHOOSETERMSHEETTAG 131
@interface TDAPPCenterViewController (){

    int index;
    NSString * _lastId;
    NSString * _noticeQuery;


}

@property (nonatomic,strong) NSMutableArray * ImageDataArr;
@property (nonatomic,strong) NSString * updataUrl;

@end



@implementation TDAPPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"msg"] style:UIBarButtonItemStylePlain target:self action:@selector(clickNoctiveButton)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        
        self.contentScroll.contentSize = CGSizeMake(0, self.contentScroll.bounds.size.height+50);
    
    }
    index = 0;
    _ImageDataArr = [NSMutableArray arrayWithCapacity:0];
  
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [TDHttpEngine requestForDynamicImgWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *imageArray) {
        if (succeed) {
            
            for (int i = 0; i < imageArray.count; i++) {
                
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:_tittleScroll.bounds];
                [_tittleScroll addSubview:imageV];
                [_ImageDataArr addObject:imageV];
                TDDynamicImg * img = imageArray[i];
                NSString * url = [NSString stringWithFormat:@"%@%@",HOST,img.fileUrl];
                [imageV setImageWithURL:[NSURL URLWithString:url]];
            }
            [self showWarningMessage];
        }
    }];
    
    
    NSArray * array = @[kCATransitionFade,kCATransitionPush,kCATransitionReveal,kCATransitionMoveIn,@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl"];
    _tittleScroll.clipsToBounds = YES;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(createAnmationWithImageView:) userInfo:array repeats:YES];
    
#if APPSTORE_VER
    // AppStore版本不检查更新
#else
    [self upDataApp];
#endif
    
    if ([[TDUser defaultUser].custStatus isEqualToString:@"0"] ||[[TDUser defaultUser].custStatus isEqualToString:@"3"]) {
        UIAlertView * AL = [[UIAlertView alloc]initWithTitle:nil message:@"尚未实名认证，请认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去认证", nil];
        AL.tag = 5;
        [AL show];
    }
    else {
//        if (![[TDUser defaultUser].cardBundingStatus isEqualToString:@"2"]) {
//            [self.view makeToast:@"尚未绑定银行卡，请前往绑定" duration:2.0f position:@"center"];
//        }
    }
}
- (void)showWarningMessage
{
    _lastId  = @"";
    [TDHttpEngine requestForNoticeWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin start:@"0" pageSize:@"15" noticeStatus:@"1" lastId:_lastId complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *noticeArray) {
        if (succeed) {
            NSLog(@"shuju: %@", noticeArray);
            if (noticeArray) {
//                if (noticeArray.count == 0) {
//                    [self.view makeToast:@"暂无公告" duration:2.0f position:@"center"];
//                    return;
//                }
                
                for (int i = 0; i < noticeArray.count; i++) {
                    
                    self.noticeInfo = noticeArray[i];
                    NSLog(@"%@",self.noticeInfo.noticeType);
                    if (self.noticeInfo.noticeType) {
                        if ([self.noticeInfo.noticeType isEqualToString:@"1"]) {
                            _noticeQuery = self.noticeInfo.noticeId;
                            UIAlertView *bindCardAlert = [[UIAlertView alloc] initWithTitle:self.noticeInfo.noticeTitle message:self.noticeInfo.noticeBody delegate:self cancelButtonTitle:@"不再提示" otherButtonTitles:@"去公告中心", nil];
                            bindCardAlert.tag = 4;
                            [bindCardAlert show];
                        }
                    }
            }
        }

        }
        else{
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
    }];
    
}


-(void)clickNoctiveButton{
    
    TDNoticeTableViewController *noticeVC = [[TDNoticeTableViewController alloc] init];
    noticeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeVC animated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Core Animation

-(void)createAnmationWithImageView:(NSTimer *)time{
    
    
    NSArray * arr = [time userInfo];
    
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type  = [arr objectAtIndex:arc4random()%(arr.count)];
    
    static int  typeID = 0;

    switch (typeID) {
        case 0:
            animation.subtype = kCATransitionFromLeft;
            break;
        case 1:
            animation.subtype = kCATransitionFromBottom;
            break;
        case 2:
            animation.subtype = kCATransitionFromRight;
            break;
        case 3:
            animation.subtype = kCATransitionFromTop;
            break;
        default:
            break;
    }

    if (_ImageDataArr.count <= 1) {
        return;
    }
    if (index == 0) {
        [_tittleScroll exchangeSubviewAtIndex:[self indexWithImage:_ImageDataArr.count-1] withSubviewAtIndex:[self indexWithImage:_ImageDataArr.count-2]];
    }else if(index == _ImageDataArr.count-1){
        [_tittleScroll exchangeSubviewAtIndex:[self indexWithImage:_ImageDataArr.count-1] withSubviewAtIndex:[self indexWithImage:0]];
    }else{
        [_tittleScroll exchangeSubviewAtIndex:[self indexWithImage:_ImageDataArr.count-index-1] withSubviewAtIndex:[self indexWithImage:_ImageDataArr.count-index-2]];
    }
    
    
    index += 1;
    if (index > _ImageDataArr.count-1) {
        index = 0;
    }
    
    [[_tittleScroll layer] addAnimation:animation forKey:@"animation"];
    
    typeID += 1;
    
    if (typeID > 3) {
        typeID = 0;
    }
}
-(NSInteger)indexWithImage:(int)index{
    return [_tittleScroll.subviews indexOfObject:[_ImageDataArr objectAtIndex:index]];
}


-(void)upDataApp{


    //版本更新
    [TDHttpEngine requestForUpDataAppWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dic) {
        
        NSLog(@"---> %@",dic);
        
        if (succeed) {
            
            _updataUrl = [dic objectForKey:@"fileUrl"];
            
            //2 已经最新  1 需要更新  3 强制更新
            if (3 == [[dic objectForKey:@"checkState"] integerValue]) {
                
                UIAlertView * AL = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"亲,有新版本需要更新喔" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                AL.tag = 3;
                [AL show];
                
                
            }else if (2 == [[dic objectForKey:@"checkState"] integerValue]){
                
//                UIAlertView * AL = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"亲,已经是最新版本了喔" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//                [AL show];
                
            }else if (1 == [[dic objectForKey:@"checkState"] integerValue]){
                
                UIAlertView * AL = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"亲,有新版本需要更新喔" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [AL show];
                AL.tag = 1;
            }
        }else{
            
            [self.view makeToast:msg duration:2.0f position:@"center"];
        }
        
        
    }];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == 3){
        
        if (0 == buttonIndex) {
            [[TDAppDelegate sharedAppDelegate] exitApplication];
            
        }else {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_updataUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updataUrl]];
            }
        }
    }else if (alertView.tag == 1){
        
        if (0 == buttonIndex) {
            
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_updataUrl]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updataUrl]];
            }
        }
    }else if (alertView.tag == 4)
    {
        if (1 == buttonIndex) {
            [self clickNoctiveButton];
        }else{
            [TDHttpEngine requestForNoticeQueryWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin noticeId:_noticeQuery complete:^(BOOL succeed, NSString *msg, NSString *cod, NSDictionary *dic) {
                NSLog(@"---> %@",dic);
                
                if (succeed) {
                    
                    
                }else{
                    
                    [self.view makeToast:msg duration:2.0f position:@"center"];
                }
            }];
                
            

        }
    }else if (alertView.tag == 5)
    {
        if (0 == buttonIndex) {
            TDRealCertificationViewController *realNameCerVC = [[TDRealCertificationViewController alloc] init];
            realNameCerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realNameCerVC animated:YES];

        }
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickmainButton:(UIButton *)sender {
    
    NSLog(@"---> %d",sender.tag);
        TDUser * user = [TDUser defaultUser];
    switch (sender.tag) {
        
        case 0:
        {
            NSLog(@"%@",[TDUser defaultUser].termNum);

            if ([[TDUser defaultUser].termNum intValue] == 0) {
                [self.view makeToast:@"请前往绑定刷卡器" duration:2.0f position:@"center"];
            }else{
                if (![user.custStatus isEqualToString:@"2"]) {
                    [self.view makeToast:@"尚未完成实名认证" duration:2.0f position:@"center"];
                }else{
                    if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"2"]) {
                       TDCollectionMoneyViewController * collectController = [[TDCollectionMoneyViewController alloc]init];
                        collectController.payment = kPaymentT1;
                        collectController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:collectController animated:YES];
                    }else
                    {
                        [self.view makeToast:@"绑定银行卡尚未通过" duration:2.0f position:@"center"];
                    }
                }
            }
            }
            break;
        case 1:
        {
            //提现
            if (![user.custStatus isEqualToString:@"2"]) {
                [self.view makeToast:@"尚未完成实名认证" duration:2.0f position:@"center"];
            }else{
                if ([[TDUser defaultUser].cardBundingStatus isEqualToString:@"2"]) {
                    TDDrawingCashViewController * cashViewController = [[TDDrawingCashViewController alloc]init];
                    cashViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cashViewController animated:YES];
                }else
                {
                    [self.view makeToast:@"绑定银行卡尚未通过" duration:2.0f position:@"center"];
                }
            }
        }
            break;
        case 2:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
            
        }
            break;
        case 3:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 4:
        {
            if (![user.custStatus isEqualToString:@"2"]) {
                [self.view makeToast:@"尚未完成实名认证" duration:2.0f position:@"center"];
            }else{
                
                UIActionSheet *chooseTermSheet = [[UIActionSheet alloc] initWithTitle:@"选择终端" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新大陆音频", @"新大陆蓝牙",@"天瑜蓝牙",nil];
                chooseTermSheet.tag = CHOOSETERMSHEETTAG;
                [chooseTermSheet showInView:self.view];
                
                
            }
        }
            break;
        case 5:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 6:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 7:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 8:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 9:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 10:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
        case 11:
        {
            [self.view makeToast:@"暂未开通" duration:2.0f position:@"center"];
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)clickTap:(UITapGestureRecognizer *)sender {
    
    NSInteger  index = [_tapArray indexOfObject:sender];
    UIButton * button = (UIButton *)[_contentScroll viewWithTag:index];
    [self clickmainButton:button];
//    if (index != 0 &&index != 2) {
//        [self.view makeToast:@"尚未开通" duration:2.0f position:@"center"];
//    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == CHOOSETERMSHEETTAG) {
        
        if (buttonIndex == 0) {
            
            HFBSwipeViewController *hfbSwipeVC = [[HFBSwipeViewController alloc] init];
            hfbSwipeVC.hfbNewLandPayType = HFBkNewLandBankInquiry;
            hfbSwipeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hfbSwipeVC animated:YES];
        }
        else if (buttonIndex == 1) {
            
            TDSearchNewLandBlueTViewController *searchNLBlueVC = [[TDSearchNewLandBlueTViewController alloc] init];
            searchNLBlueVC.hidesBottomBarWhenPushed = YES;
            searchNLBlueVC.pushVCType = SwipeCard;
            searchNLBlueVC.payMoney = @"0.00";
            [self.navigationController pushViewController:searchNLBlueVC animated:YES];
        }
        else if(buttonIndex == 2)
        {
            TDBalanceViewController *balanceVC = [[TDBalanceViewController alloc]init];
            balanceVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:balanceVC animated:YES];
        }
    }
}
@end
