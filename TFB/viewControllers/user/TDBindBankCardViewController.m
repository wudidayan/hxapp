//
//  TDBindBankCardViewController.m
//  TFB
//
//  Created by Nothing on 15/4/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDBindBankCardViewController.h"
#import "TSLocateView.h"
#import "ZSYPopoverListView.h"
#import "TDBankCardInfo.h"
#import "TDbankListName.h"
#import "TDBankListViewController.h"
#import "TDzhihangViewController.h"

#define FRONTIMAGEVIEW_TAG  100
#define BACKIMAGEVIEW_TAG   101
#define PROVINCEVIEW_TAG    102
#define CITYVIEW_TAG        103

@interface TDBindBankCardViewController ()
{
    NSInteger _takeImgTag;
    
    NSString *_sendFrontImage;
    NSString *_sendBackImage;
    TSLocateView * _loactionView;
    UIActionSheet * _sheet;
    TDBankCardInfo *_info;
    BOOL keyboardIsShown;
    UITextField * currentTextfield;
    BOOL isClickZhihang;
}
@property (nonatomic,strong) NSArray * citiyArr;
@property (nonatomic,strong) NSMutableArray * bankArr;
@property (nonatomic, strong) NSMutableArray * bankNameListArr;
@property (nonatomic,strong) NSString * subBranch;
@property (nonatomic,strong) NSString * cnapsCode;
@property (nonatomic,strong) UIPickerView *pickerBank;
@property (nonatomic,strong) UIPickerView *pickerBankList;
@property (nonatomic,strong) UILabel *labCell;
@end


@implementation TDBindBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    if (![[TDUser defaultUser].custStatus isEqualToString:@"2"]) {
//        [self.view makeToast:@"尚未完成实名认证，请前往认证" duration:2.0f position:@"center"];
//    }
    isClickZhihang = NO;
    
    self.categories.delegate = self;
    self.idNumText.delegate = self;
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    recognizer.numberOfTapsRequired = 1;
    [self.categories addGestureRecognizer:recognizer];
    
    self.categories.textAlignment = NSTextAlignmentCenter;
    if (!self.categories.text) {
        self.categories.text = @"";
    }
    self.bankNameListArr = [NSMutableArray array];
    self.bankArr = [NSMutableArray array];
    self.bank = [[TDBankListViewController alloc]init];
    if (kBandingBankCard == _state) {
        self.title = @"绑定银行卡";
        [self.idNum setHidden:YES];
        [self.idNumView setHidden:YES];
        [self.idNumText setHidden:YES];
    }else if (kModificationBankCard == _state){
        self.title = @"修改银行卡";
        [_commitBtn setTitle:@"确认修改" forState:0];
    }
    
    [self backButton];
    [self creatLayerWithView:_cardNumTF.superview];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self creatUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:CITIYLIST]) {
        
        self.citiyArr = [TDProvince userDefaultObjectWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CITIYLIST]];
    }else{
        
        __weak typeof(self) weakSelf = self;
        [TDHttpEngine requestForGetProvinceWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *array) {
            
            weakSelf.citiyArr = array;
        }];
    }

    [_bank returnText:^(NSString *showText) {
        [self.bankNameButtom setTitle:showText forState:0];
        
    }];
    self.bankNameButtom.titleLabel.textAlignment = NSTextAlignmentCenter;
    


   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatUI
{    
    self.cardFrontImageView.userInteractionEnabled = YES;
    self.cardFrontImageView.tag = FRONTIMAGEVIEW_TAG;
    UITapGestureRecognizer *frontTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    frontTap.numberOfTapsRequired = 1;
    frontTap.numberOfTouchesRequired = 1;
    frontTap.delegate = self;
    [self.cardFrontImageView addGestureRecognizer:frontTap];
    
    self.cardBackImageView.userInteractionEnabled = YES;
    self.cardBackImageView.tag = BACKIMAGEVIEW_TAG;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    backTap.numberOfTapsRequired = 1;
    backTap.numberOfTouchesRequired = 1;
    backTap.delegate = self;
    [self.cardBackImageView addGestureRecognizer:backTap];
    
//    if (kModificationBankCard == _state) {
//        self.cardNumTF.text = self.bankCardInfo.cardNo;
//        self.lineNumTF.text = self.bankCardInfo.issno;
//    }
    
}


- (void)takePhoto:(UITapGestureRecognizer *)tapGesture
{
    _takeImgTag = [[tapGesture view] tag];
    
    _sheet = [[UIActionSheet alloc]initWithTitle:@"获取图片方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [_sheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"照片信息--%@", info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    switch (_takeImgTag) {
            
        case FRONTIMAGEVIEW_TAG:{
            [self.cardFrontImageView setImage:image];
            [self saveImage:[self imageWithImage:image scaledToSize:CGSizeMake(1296, 968)] WithName:@"frontImage.jpg"];
            //[self saveImage:image WithName:@"frontImage.jpg"];
            //_sendFrontImage = [imageData base64EncodedString];
        }
            break;
        case BACKIMAGEVIEW_TAG:{
            [self.cardBackImageView setImage:image];
            [self saveImage:[self imageWithImage:image scaledToSize:CGSizeMake(1296, 968)] WithName:@"backImage.jpg"];
            //[self saveImage:image WithName:@"backImage.jpg"];
            //_sendBackImage = [imageData base64EncodedString];
        }
            break;
            
        default:
            break;
    }
}

//重新绘制图片的尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
    UIImage *needImage = [[UIImage alloc] initWithData:imageData];
    
    return needImage;
}


- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"路径---%@", paths);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *temPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
    NSString *fullPathToFile = [temPath stringByAppendingPathComponent:imageName];
    NSLog(@"picPath--%@", fullPathToFile);
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}

//删除保存的银行卡照片
- (void)deleteBankCardImage {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL frontImageIsHave = [fileManager fileExistsAtPath:_sendFrontImage];
    if (!frontImageIsHave) {
        return;
    }
    else {
        [fileManager removeItemAtPath:_sendFrontImage error:nil];
    }
    
    BOOL backImageIsHave = [fileManager fileExistsAtPath:_sendBackImage];
    if (!backImageIsHave) {
        return;
    }
    else {
        [fileManager removeItemAtPath:_sendBackImage error:nil];
    }
}

- (void)getArea:(UITapGestureRecognizer *)tapGesture
{
    
}

- (IBAction)commitBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    _sendFrontImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/frontImage.jpg"];
    _sendBackImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/backImage.jpg"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_sendFrontImage]) {
        [self.view makeToast:@"请上传银行卡正面图" duration:2.0f position:@"center"];
        return;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:_sendBackImage]) {
        [self.view makeToast:@"请上传银行卡反面图" duration:2.0f position:@"center"];
        return;
    }
    
    if (_cardNumTF.text.length <= 0) {
        [self.view makeToast:@"请输入银行卡号" duration:2.0f position:@"center"];
        return;
    }
    if (_categories.text.length <= 0) {
        [self.view makeToast:@"请输入支行名称" duration:2.0f position:@"center"];
        return;
    }
    if (_bankNameButtom.titleLabel.text.length <= 0) {
        [self.view makeToast:@"请选择银行名称" duration:2.0f position:@"center"];
        return;
    }
    if (isClickZhihang == NO) {
        [self.view makeToast:@"请选择支行信息" duration:2.0f position:@"center"];
        return;
    }
    if (_loactionView.citieID.length <= 0 ||_loactionView.provinceID.length <= 0) {
        [self.view makeToast:@"请选择省/市" duration:2.0f position:@"center"];
        return;
    }
    
    
    NSString * operType = nil;
    NSString * oldCard = nil;
    if (kBandingBankCard == _state) {
        operType = @"1";
        oldCard = _cardNumTF.text;
    }else{
        operType = @"2";
        oldCard = _bankCardInfo.cardNo;
        
    }
   
    if (kBandingBankCard == _state) {
        self.idNumText.text = @"";
    }else
    {
        if ([self.idNumText.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入身份证号" duration:2.0f position:@"center"];
            return;
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestForUpBankCardWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin OperType:operType oldCardNo:oldCard cardNo:self.cardNumTF.text cardFront:_sendFrontImage cardBack:_sendBackImage provinceId:_loactionView.provinceID cityId:_loactionView.citieID cnapsCode:self.cnapsCode subBranch:self.subBranch certificateNo:self.idNumText.text complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            [self deleteBankCardImage];
            [self performSelector:@selector(popToRoot) withObject:self afterDelay:2.5f];
        }
        else{
            
        }
    }];
}

- (void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//选择省市
- (IBAction)clickTRButton:(UIButton *)sender {
    [self.cardNumTF resignFirstResponder];
    [self.view endEditing:YES];
//    if (!self.BGScrollView.contentOffset.y) {
//        [self.BGScrollView setContentOffset:CGPointMake(0, 120) animated:YES];
//    }
    if (!_loactionView) {
        _loactionView  = [[TSLocateView alloc]initWithTitle:@"选择省/市" delegate:self];
        _loactionView.tag = 10;
        _loactionView.viewType = kCERVIEW;
        [_loactionView updataWithArray:self.citiyArr];
    }
    if (_loactionView.isCanShow) {
        [_loactionView showInView:self.view];
    }

}
//选择银行
- (IBAction)clickBankButton:(UIButton *)sender {
    //输入框的关键字
    self.categories.text = @"";
    [self.cardNumTF resignFirstResponder];
    //放银行名称的数组
    [self.bankArr removeAllObjects];
    if (_loactionView.citieID.length <= 0 ||_loactionView.provinceID.length <= 0) {
        [self.view makeToast:@"请选择省/市" duration:2.0f position:@"center"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestGetBankNamecustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin bankProId:_loactionView.provinceID bankCityId:_loactionView.citieID complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *bankList) {
        NSLog(@"%@",bankList);
        if (succeed) {

            self.bankArr = [NSMutableArray arrayWithArray:bankList];
            
            NSLog(@"%@",self.bankArr);
     
            _bank.bankArr = self.bankArr;
            
            [_bank returnText:^(NSString *showText) {

                [self.bankNameButtom setTitle:showText forState:0];
                
            }];

            [self presentViewController:_bank animated:YES completion:nil];
        }
        
    }];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    
    
}
//选择支行
- (IBAction)clickZhihangButton:(UIButton *)sender {
    isClickZhihang = YES;
    [self.cardNumTF resignFirstResponder];
    [self.bankNameListArr removeAllObjects];
    if (_loactionView.citieID.length <= 0 ||_loactionView.provinceID.length <= 0) {
        [self.view makeToast:@"请选择省/市" duration:2.0f position:@"center"];
        return;
    }
    if (_bankNameButtom.titleLabel.text.length <= 0) {
        [self.view makeToast:@"请选择银行名称" duration:2.0f position:@"center"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TDHttpEngine requestGetBankListNameCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin bankProId:_loactionView.provinceID bankCityId:_loactionView.citieID bankName:self.bankNameButtom.titleLabel.text categories:self.categories.text complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *bankList) {
        if (succeed) {

            for (TDbankListName *bankListName in bankList) {
                NSLog(@"%@",bankListName);
                [self.bankNameListArr addObject:bankListName];
            }
            self.bankList = [[TDzhihangViewController alloc]init];
            _bankList.bankNameListArr = self.bankNameListArr;
            [_bankList returnZhihang:^(NSString *subBranch, NSString *cnapsCode) {
                self.subBranch = subBranch;
                self.cnapsCode = cnapsCode;
                self.categories.text = subBranch;
            }];
            [self presentViewController:_bankList animated:YES completion:nil];
        }
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_sheet == actionSheet) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else{
                [self.view makeToast:@"该设备没有摄像头" duration:2.0f position:@"center"];
                return;
            }
        }else if (buttonIndex == 0){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
        
        return;
    }
    _bankNumImageV.highlighted = NO;
    _lineNumImageV.highlighted = NO;
    _AreaImageV.highlighted = NO;
    if (self.BGScrollView.contentOffset.y) {
        [self.BGScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if(buttonIndex == 0) {
        
        
    }else {
        
        [_TRButton setTitle:[NSString stringWithFormat:@"%@ / %@",_loactionView.province,_loactionView.citie] forState:0];
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_loactionView cancelWithView];

        [self.BGScrollView setContentOffset:CGPointMake(0, 120) animated:YES];

    currentTextfield = textField;

    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

//    [self.view endEditing:YES];
    [self.cardNumTF resignFirstResponder];
    [self.categories resignFirstResponder];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.BGScrollView.contentOffset.y) {
        [self.BGScrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    _bankNumImageV.highlighted = NO;
    _lineNumImageV.highlighted = NO;
    _AreaImageV.highlighted = NO;
    [self.categories resignFirstResponder];
    [self.idNumText resignFirstResponder];
//    [textField resignFirstResponder];
    return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    currentTextfield = nil;
}
-(void)clickbackButton{

    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)move:(id)sender
{
        [self.BGScrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    
}
#pragma 输入框弹出键盘偏移
-(void) viewWillAppear:(BOOL)animated{
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:self.view.window];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
}
//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardDidShow:(NSNotification *)notification{
    if (keyboardIsShown) {
        return;
    }
    NSDictionary * info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.BGScrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    self.BGScrollView.frame = viewFrame;
    CGRect textFieldRect = [currentTextfield frame];
    [self.BGScrollView scrollRectToVisible:textFieldRect animated:YES];
    keyboardIsShown = YES;
}
//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardDidHide:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.BGScrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    self.BGScrollView.frame = viewFrame;

    keyboardIsShown = NO;
}
//页面消失前取消通知
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidHideNotification
     object:nil];

}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self.cardNumTF resignFirstResponder];
    [self.idNumText resignFirstResponder];
    [self.categories resignFirstResponder];
}

@end
