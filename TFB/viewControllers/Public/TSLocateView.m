//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3

@implementation TSLocateView

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate 
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        self.isCanShow = YES;

    }
    return self;
}
-(void)updataWithArray:(NSArray *)array{
    if (kCERVIEW ==  _viewType) {
        
        self.dataSourceArr = [NSArray arrayWithArray:array];
        _provinces = [NSArray arrayWithArray:self.dataSourceArr];
        _cities = [(TDProvince *)[_provinces objectAtIndex:0] cityDataSourceArr];
        _province = [[_provinces firstObject] provName];
        _provinceID = [[_provinces firstObject] provId];
        _citie = [[_cities firstObject] cityName];
        _citieID = [[_cities firstObject] cityId];

   }else if (kPAYVIEW == _viewType){
        
        if (array && array.count) {
            _dataSourceArr = [NSArray arrayWithArray:array];
            
            if ([[_dataSourceArr objectAtIndex:0] isKindOfClass:[TDTerm class]]) {
                _term = [_dataSourceArr objectAtIndex:0];
            }else if ([[_dataSourceArr objectAtIndex:0] isKindOfClass:[TDRate class]]){
                 _rate = [_dataSourceArr objectAtIndex:0];
            }
        }

    }
}
- (void)showInView:(UIView *) view
{
    _isCanShow = NO;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
//    view.frame.size.height - self.frame.size.height
    self.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height);
    
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (kPAYVIEW == _viewType) {
        return 1;
        
    }else if (kCERVIEW == _viewType){
//        switch (self.tag) {
//            case 10:
                return 2;
//                break;
//            case 11:
//                return 1;
//                break;
//            case 12:
//                return 1;
//                break;
//                
//            default:
//                break;
//        }
       
    }
        return 2;
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
//    switch (self.tag) {
//        case 10:
            switch (component) {
                case 0:
                    return [_provinces count]?[_provinces count]:[_dataSourceArr count];
                    break;
                case 1:
                    return [_cities count];
                    break;
                default:
                    break;
//            }
//            break;
//        case 11:
//            switch (component) {
//                case 0:
//                    return [_banks count];
//                    break;
//                default:
//                    break;
//            }
//            break;
//        case 12:
//            switch (component) {
//                case 0:
//                    return [_subBranches count];
//                    break;
//                default:
//                    break;
//            }
//            break;
//            
//        default:
//            break;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSString * string = nil;
            if ([[_dataSourceArr objectAtIndex:row] isKindOfClass:[TDTerm class]]) {
                string = [[_dataSourceArr objectAtIndex:row]termNo];
                _term = [_dataSourceArr objectAtIndex:row];
            }else if ([[_dataSourceArr objectAtIndex:row] isKindOfClass:[TDRate class]]){
                string = [[_dataSourceArr objectAtIndex:row]rateDesc];
            }else{
                
//                switch (self.tag) {
//                    case 10:
                        string = [(TDProvince *)[_provinces objectAtIndex:row] provName];
//                        break;
//                    case 11:
//                        string = [_banks objectAtIndex:row];
//                        break;
//                    case 12:
//                        string = [_subBranches objectAtIndex:row];
//                        break;
//                        
//                    default:
//                        break;
//                }
                
            }
            
            return string;
        }
            break;
        case 1:
            return [(TDCity *)[_cities objectAtIndex:row] cityName];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            if (kCERVIEW == _viewType) {
                _cities = [[_provinces objectAtIndex:row] cityDataSourceArr];
                [self.locatePicker selectRow:0 inComponent:1 animated:NO];
                self.province = [[_provinces objectAtIndex:row] provName];
                self.provinceID = [[_provinces objectAtIndex:row]provId];
                _cities = [(TDProvince *)[_provinces objectAtIndex:row] cityDataSourceArr];
                self.citie  = [(TDCity *)[_cities objectAtIndex:0] cityName];
                self.citieID = [(TDCity *)[_cities objectAtIndex:0] cityId];
//                self.bankNames = [[_banks objectAtIndex:row] bankNames];
//                self.subBranch = [[_subBranches objectAtIndex:row]subBranch];
//                self.snapsCode = [[_snapsCodes objectAtIndex:row]snapsCode];
                
                [self.locatePicker reloadComponent:1];
            }else if (kPAYVIEW == _viewType){
            
                if ([[_dataSourceArr objectAtIndex:row] isKindOfClass:[TDTerm class]]) {
                    _term = [_dataSourceArr objectAtIndex:row];
                }else if ([[_dataSourceArr objectAtIndex:row] isKindOfClass:[TDRate class]]){
                    _rate = [_dataSourceArr objectAtIndex:row];
                }else{
                   
                }
            
            }
            break;
        case 1:
            self.citie  = [[_cities objectAtIndex:row] cityName];
            self.citieID = [[_cities objectAtIndex:row] cityId];
            break;
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    _isCanShow = YES;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}
-(void)cancelWithView{

    _isCanShow = YES;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }

}
- (IBAction)locate:(id)sender {
      _isCanShow = YES;
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
