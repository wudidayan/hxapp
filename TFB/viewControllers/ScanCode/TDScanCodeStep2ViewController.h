#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"
#import "TDScanCode.h"

@interface TDScanCodeStep2ViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *localScanBtn;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *txnAmtVal;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImgView;

- (IBAction)scanBtnClick:(id)sender;

@property (nonatomic,strong) TDScanCode *scanCodeContext;

@end
