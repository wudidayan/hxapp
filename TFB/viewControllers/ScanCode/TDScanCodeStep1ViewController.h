#import "TDBaseViewController.h"
#import "ZSYPopoverListView.h"
#import "TDScanCode.h"

@interface TDScanCodeStep1ViewController : TDBaseViewController<UIGestureRecognizerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *txnAmt;

- (IBAction)commitBtnClick:(id)sender;

@property (nonatomic,strong) TDScanCode *scanCodeContext;

@end
