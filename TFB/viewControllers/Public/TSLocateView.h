//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "TDProvince.h"
#import "TDTerm.h"
typedef NS_ENUM(NSInteger, ViewType)
{
    kPAYVIEW = 0,  //支付界面
    kCERVIEW,      //使命认证界面

};

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSArray * _provinces;
    NSArray	*_cities;
//    NSArray *_banks;
//    NSArray *_subBranches;
//    NSArray *_snapsCodes;
    
    
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;

@property (nonatomic,assign) ViewType viewType;

//如餐 
@property (strong, nonatomic) NSArray * dataSourceArr;
/*   实名认证界面参数   */
//出参
@property (nonatomic,strong) NSString * province;
@property (nonatomic,strong) NSString * provinceID;
@property (nonatomic,strong) NSString * citie;
@property (nonatomic,strong) NSString * citieID;
//@property (nonatomic,strong) NSString * bankNames;
//@property (nonatomic,strong) NSString * subBranch;
//@property (nonatomic,strong) NSString * snapsCode;


@property (nonatomic, assign) BOOL isCanShow;

/*  支付界面参数  */
@property (nonatomic,strong) TDTerm * term;
@property (nonatomic,strong) TDRate * rate;

//@property (nonatomic,strong) NSString * resultTermString;
//@property (nonatomic,strong) NSString * resultRateString;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;
-(void)updataWithArray:(NSArray *)array;
- (void)showInView:(UIView *)view;
-(void)cancelWithView;
@end
