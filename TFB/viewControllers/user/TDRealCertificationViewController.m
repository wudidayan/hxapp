//
//  TDRealCertificationViewController.m
//  TFB
//
//  Created by 德古拉丶 on 15/4/15.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDRealCertificationViewController.h"
#import "TSLocateView.h"
#import "NSString+Regex.h"
#import "TDBindBankCardViewController.h"

//#import "TDProvince.h"
#define HANDHELD 100
#define FRONT    101
#define BACK     102
#define VIEW_HIGHT 260

@interface TDRealCertificationViewController ()
{
    NSInteger _takeImgTag;
    
    NSString *_sendHandheldImage;
    NSString *_sendFrontImage;
    NSString *_sendBackImage;
    TSLocateView * _loactionView;
    float _BGCSizeY;
    UIActionSheet * _actionSheet;
}
@property (nonatomic,strong) NSArray * citiyArr;
@end

@implementation TDRealCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self backButton];
    
    self.title = @"实名认证";
    
    UIView * bgView = [_cardHandheldImageView superview];
    [self creatLayerWithView:bgView];
    
    UIView * contextView = [_CerTextField superview];
    [self creatLayerWithView:contextView];
    
   self.BGScrollView.contentSize = CGSizeMake(0, self.BGScrollView.frame.size.height+200);
    _BGCSizeY = self.BGScrollView.frame.size.height;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:CITIYLIST/* 城市列表保存 */]) {
        
        self.citiyArr = [TDProvince userDefaultObjectWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CITIYLIST]];
    }else{
        
        __weak typeof(self) weakSelf = self;
        [TDHttpEngine requestForGetProvinceWithCustId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin complete:^(BOOL succeed, NSString *msg, NSString *cod, NSArray *array) {
            
            weakSelf.citiyArr = array;
        }];
    }
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)keyboardHide:(NSNotification *)notif {
    [self hidenBGscrollViewFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    /*
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CGSize imagesize = image.size;
    imagesize.height = 968;
    imagesize.width = self.view.bounds.size.height/self.view.bounds.size.height * imagesize.height;
    NSData *imageData = UIImageJPEGRepresentation([self imageWithImage:image scaledToSize:imagesize], 0.1);
    
    switch (_takeImgTag) {
        case HANDHELD:{
            [self.cardHandheldImageView setImage:image];
            _sendHandheldImage = [imageData base64EncodedString];
        }
            break;
        case FRONT:{
            [self.cardFrontImageView setImage:image];
            _sendFrontImage = [imageData base64EncodedString];
        }
            break;
        case BACK:{
            [self.cardBackImageView setImage:image];
            _sendBackImage = [imageData base64EncodedString];
        }
            break;
            
        default:
            break;
    }
     */
    
    
    NSLog(@"照片信息  %@", info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    
    switch (_takeImgTag) {
        case HANDHELD:{
            [self.cardHandheldImageView setImage:image];
            [self saveImage:[self imageWithImage:image scaledToSize:CGSizeMake(1296, 968)] WithName:@"idCardHandhelImage.jpg"];
        }
            break;
        case FRONT:{
            [self.cardFrontImageView setImage:image];
            [self saveImage:[self imageWithImage:image scaledToSize:CGSizeMake(1296, 968)] WithName:@"idCardFrontImage.jpg"];
        }
            break;
        case BACK:{
            [self.cardBackImageView setImage:image];
            [self saveImage:[self imageWithImage:image scaledToSize:CGSizeMake(1296, 968)] WithName:@"idCardBackImage.jpg"];
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
    return newImage;
}

//保存图片到本地
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
    
    BOOL handheldImageIsHave = [fileManager fileExistsAtPath:_sendHandheldImage];
    if (!handheldImageIsHave) {
        return;
    }
    else {
        [fileManager removeItemAtPath:_sendHandheldImage error:nil];
    }
    
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


- (IBAction)commit:(id)sender {

    _sendHandheldImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/idCardHandhelImage.jpg"];
    _sendFrontImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/idCardFrontImage.jpg"];
    _sendBackImage = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/idCardBackImage.jpg"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_sendFrontImage]) {
        [self.view makeToast:@"请上传身份证正面图" duration:2.0f position:@"center"];
        return;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:_sendBackImage]) {
        [self.view makeToast:@"请上传身份证反面图" duration:2.0f position:@"center"];
        return;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:_sendHandheldImage]) {
        [self.view makeToast:@"请上传手持身份证照片" duration:2.0f position:@"center"];
        return;
    }
    

//    if(!_loactionView){
//        
//        [self.view makeToast:@"请选择省/市" duration:2.0f position:@"center"];
//        return;
//    
//    }
    NSString *cer = [self.CerTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (cer.length == 0) {
        
         [self.view makeToast:@"请输入证件号码" duration:2.0f position:@"center"];
        return;
    }
    if (![NSString validateIdentityCard:cer]) {
        
        [self.view makeToast:@"身份证号码格式不正确" duration:2.0f position:@"center"];
        return;
    }
    if(_custNameText.text.length == 0){

        [self.view makeToast:@"请输入证件姓名" duration:2.0f position:@"center"];
        return;
    }

//    
//    if (_EmailTextField.text.length == 0) {
//        [self.view makeToast:@"请输入邮箱" duration:2.0f position:@"center"];
//        return;
//    }
//    if (![NSString validateEmail:_EmailTextField.text]) {
//        [self.view makeToast:@"邮箱格式不正确" duration:2.0f position:@"center"];
//        return;
//    }
     NSString *pass = [self.PassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (NO == [NSString checkPasswordLength:pass]) {
        [self.view makeToast:@"密码长度为6-20位字母或有效数字组成" duration:2.0f position:@"center"];
        return;
    }
    if (![pass validateCaseInsensitive:PASSWORD_KEY]) {
        [self.view makeToast:@"密码过于简单" duration:2.0f position:@"center"];
        return;
    }
    
    /* 01  身份证  */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TDHttpEngine requestForCertificationWithCardHandheld:_sendHandheldImage cardFront:_sendFrontImage cardBack:_sendBackImage custId:[TDUser defaultUser].custId custMobile:[TDUser defaultUser].custLogin custName:_custNameText.text certificateType:@"01" certificateNo:_CerTextField.text userEmail:@"" provinceId:@"" cityId:@"" payPwd:_PassTextField.text complete:^(BOOL succeed, NSString *msg, NSString *cod) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:msg duration:2.0f position:@"center"];
        if (succeed) {
            [self deleteBankCardImage];
//            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@YES afterDelay:2.f];
            TDBindBankCardViewController *bankCardListVC = [[TDBindBankCardViewController alloc] init];
            bankCardListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bankCardListVC animated:YES];
        }
        else {
            
        }
        
    }];

}
- (IBAction)ClickCerButton:(UIButton *)sender {
    //暂时不用  先用身份证
}
- (IBAction)clickAreaButton:(UIButton *)sender {
    
    [self.view endEditing:YES];

    if (!_loactionView) {
        _loactionView  = [[TSLocateView alloc]initWithTitle:@"选择省/市" delegate:self];
        _loactionView.viewType = kCERVIEW;
        [_loactionView updataWithArray:self.citiyArr];
    }
    if (_loactionView.isCanShow) {
          [_loactionView showInView:self.view];
    }
    [self showBGscrollViewFrame];
    _CerTypeImageV.highlighted = NO;
    _CerNameImageV.highlighted = NO;
//    _emailImageV.highlighted = NO;
//    _AreaImageV.highlighted = YES;
    _payImageV.highlighted = NO;
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet == _actionSheet) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        if (1 == buttonIndex) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                imagePicker.sourceType =UIImagePickerControllerSourceTypeCamera;
                
            }else{
                [self.view makeToast:@"该设备无摄像头" duration:2.0f position:@"center"];
                return;
            }
        }
        
        if (0 == buttonIndex) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        return;
    }
    
    
    _CerTypeImageV.highlighted = NO;
    _CerNameImageV.highlighted = NO;
//    _emailImageV.highlighted = NO;
//    _AreaImageV.highlighted = NO;
    _payImageV.highlighted = NO;
    //[_PassTextField becomeFirstResponder];
    if(buttonIndex == 1) {
//      [_AreaButton setTitle:[NSString stringWithFormat:@"%@   /  %@",_loactionView.province,_loactionView.citie] forState:0];
      
    }
}

- (IBAction)ClickTap:(UITapGestureRecognizer *)sender {
    
    _actionSheet = [[UIActionSheet alloc]initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [_actionSheet showInView:self.view];
    
    _takeImgTag = [[sender view] tag];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [_loactionView cancelWithView];
    [self showBGscrollViewFrame];
    if (textField == _CerTextField) {

        _CerTypeImageV.highlighted = YES;
        _CerNameImageV.highlighted = NO;
//        _emailImageV.highlighted = NO;
//        _AreaImageV.highlighted = NO;
        _payImageV.highlighted = NO;
    }else if (textField == _custNameText){

        _CerTypeImageV.highlighted = NO;
        _CerNameImageV.highlighted = YES;
//        _emailImageV.highlighted = NO;
//        _AreaImageV.highlighted = NO;
        _payImageV.highlighted = NO;
    }
//    else if(textField == _EmailTextField){
//
//        _CerTypeImageV.highlighted = NO;
//        _CerNameImageV.highlighted = NO;
//        _emailImageV.highlighted = YES;
//        _AreaImageV.highlighted = NO;
//        _payImageV.highlighted = NO;
//    }
    else if (textField == _PassTextField){

        _CerTypeImageV.highlighted = NO;
        _CerNameImageV.highlighted = NO;
//        _emailImageV.highlighted = NO;
//        _AreaImageV.highlighted = NO;
        _payImageV.highlighted = YES;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    _CerTypeImageV.highlighted = NO;
    _CerNameImageV.highlighted = NO;
//    _emailImageV.highlighted = NO;
//    _AreaImageV.highlighted = NO;
    _payImageV.highlighted = NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hidenBGscrollViewFrame];
    [textField resignFirstResponder];
    
    return YES;
}
-(void)showBGscrollViewFrame{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.BGScrollView.frame = CGRectMake(self.BGScrollView.frame.origin.x,
                                             self.BGScrollView.frame.origin.y,
                                             self.BGScrollView.frame.size.width,
                                             self.view.bounds.size.height-256);
    }completion:^(BOOL finished) {
        [self.BGScrollView setContentOffset:CGPointMake(0, VIEW_HIGHT) animated:YES];
    }];

}
-(void)hidenBGscrollViewFrame{
  
    [UIView animateWithDuration:0.5 animations:^{
        self.BGScrollView.frame = CGRectMake(self.BGScrollView.frame.origin.x,
                                             self.BGScrollView.frame.origin.y,
                                             self.BGScrollView.frame.size.width,
                                             _BGCSizeY + 256);
    }completion:^(BOOL finished) {
        [self.BGScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.BGScrollView.contentSize = CGSizeMake(0, self.BGScrollView.frame.size.height+120);
    }];
}
@end
