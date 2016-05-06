//
//  TDDatePickerView.m
//  TFB
//
//  Created by 德古拉丶 on 15/5/13.
//  Copyright (c) 2015年 TD. All rights reserved.
//

#import "TDDatePickerView.h"
#define TIME 0.5

@implementation TDDatePickerView

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        self.center =  CGPointMake(size.width/2, size.height+self.bounds.size.height/2);
        [self pickerAnimationWithBandE:YES];
        self.isRemove = NO;
        
    }
    return self;
}

//YES  出现  NO  消失
-(void)pickerAnimationWithBandE:(BOOL)be{

   [UIView animateWithDuration:TIME animations:^{
       if (be) {
          self.center  =(CGPoint){
               self.center.x,self.center.y - self.bounds.size.height
          };
       }else{
           self.center  =(CGPoint){
               self.center.x,self.center.y + self.bounds.size.height
           };
       }
   }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickActionButton:(UIButton *)sender {
    self.tittleContextLabel.text = @"结束时间";
    NSDate *select = [self.myDatePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
   
    if (self.startDateString.length > 0) {

        if (NSOrderedDescending ==[self.startDate compare:select]) {
            
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"结束时间需要大于开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [al show];
            [self pickerAnimationWithBandE:NO];
            [self performSelector:@selector(pickerAnimationWithBandE:) withObject:@YES afterDelay:TIME];
            
        }else{
            self.endDataString = dateAndTime;
            [self pickerAnimationWithBandE:NO];
            [self.cv clickPicker:self];
          
        }
    }else{
        self.startDateString = dateAndTime;
         self.startDate = select;
        [self pickerAnimationWithBandE:NO];
        [self performSelector:@selector(pickerAnimationWithBandE:) withObject:@YES afterDelay:TIME];
        
    }
}

- (IBAction)clickBackButton:(UIButton *)sender {
    
    [self pickerAnimationWithBandE:NO];
    [self.cv clickPicker:nil];
    
}
@end
