#import "TDBaseViewController.h"

@interface TDQrcodeViewController : TDBaseViewController

@property (nonatomic, strong) NSString *resultState;
@property (nonatomic, assign) BOOL isSuccess;

@property (weak, nonatomic) IBOutlet UIImageView *statesImageView;
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;

@end
