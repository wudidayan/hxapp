//
//  UUDatePicker.m
//  1111
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUDatePicker.h"
#import "UUDatePicker_DateModel.h"
#import "Config.h"
//#import "ColorNew.h"
#import "UIView+CBFrameHelpers.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>

#define UUPICKER_MAXDATE 2050
#define UUPICKER_MINDATE 1970

#define UUPICKER_MONTH 12
#define UUPICKER_HOUR 24
#define UUPICKER_MINUTE 60
#define UUPICKER_SECOND 60

#define UU_GRAY [UIColor redColor];
#define UU_BLACK [UIColor blackColor];

#ifndef isIOS7
#define isIOS7  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#endif

@interface UUDatePicker ()
{
    UIPickerView *myPickerView;
    
    //日期存储数组
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    NSMutableArray *secondArray;
    
    //限制model
    UUDatePicker_DateModel *maxDateModel;
    UUDatePicker_DateModel *minDateModel;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    NSInteger secondIndex;
	
}
@property (nonatomic, copy) FinishBlock finishBlock;

@end

@implementation UUDatePicker

-(id)initWithframe:(CGRect)frame Delegate:(id<UUDatePickerDelegate>)delegate PickerStyle:(DateStyle)uuDateStyle
{
    self.datePickerStyle = uuDateStyle;
    self.delegate = delegate;
    return [self initWithFrame:frame];
}

- (id)initWithframe:(CGRect)frame PickerStyle:(DateStyle)uuDateStyle didSelected:(FinishBlock)finishBlock
{
    self.datePickerStyle = uuDateStyle;
    self.finishBlock = finishBlock;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UIView *baseFrame = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width/2-150, kScreen_Height/2-120, 300, 200)];
        baseFrame.backgroundColor = [UIColor whiteColor];
        [self addSubview:baseFrame];
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 300, 2)];
//        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"birthday_icon"]];
//        [icon setFrame:CGRectMake(10, 10, 25, 25)];
//        [baseFrame addSubview:icon];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 46)];

        line.backgroundColor = HexRGB(colorA6);
        [baseFrame addSubview:line];
        UILabel *baseTitle = [UILabel new];
        [baseTitle setFrame:CGRectMake(100, 15, 100, 14)];
//        [baseTitle setFrame:CGRectMake(50, 15, 30, 14)];
//        baseTitle.textColor = HexRGB(colorA1);
        baseTitle.font = [UIFont systemFontOfSize:16];
        baseTitle.textColor = [UIColor whiteColor];
        baseTitle.text = @"日期选择";
        baseTitle.textAlignment = NSTextAlignmentCenter;
        [baseFrame addSubview:baseTitle];
        
        UIView *toolbar = [[UIView alloc]initWithFrame:CGRectMake(kScreen_Width/2-150, kScreen_Height/2+80, 300, 40)];
        toolbar.backgroundColor = HexRGB(colorA6);
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancelBtn setTitleColor:HexRGB(colorA1) forState:UIControlStateNormal];
		[cancelBtn setTitleColor:HexRGB(colorA1) forState:UIControlStateNormal];
        [cancelBtn setX:150 andY:1];
        [cancelBtn setW:150 andH:39];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.backgroundColor = [UIColor whiteColor];
//        WS(weakSelf);
//        cancelBtn.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//            [weakSelf removeFromSuperview];
//            return [RACSignal empty];
//        }];
		cancelBtn.tag = 111;
		[cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        [toolbar addSubview:cancelBtn];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:HexRGB(colorA1) forState:UIControlStateNormal];
        [confirmBtn setX:0 andY:1];
        [confirmBtn setW:149 andH:39];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        confirmBtn.backgroundColor = [UIColor whiteColor];
//        confirmBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
//            [weakSelf playTheDelegate];
//            [weakSelf removeFromSuperview];
//            return [RACSignal empty];
//        }];

		confirmBtn.tag = 222;
		[confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


        [toolbar addSubview:confirmBtn];
        [self addSubview:toolbar];
    }
    return self;
}

- (void)btnClick:(UIButton *)Btn{

	if (Btn.tag ==111) {
		[self removeFromSuperview];

	}else if (Btn.tag == 222){
		[self playTheDelegate];
		[self removeFromSuperview];
	}

}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}

#pragma mark - 初始化赋值操作
- (NSMutableArray *)ishave:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

//进行初始化
- (void)drawRect:(CGRect)rect
{
    if (self.frame.size.height<216 || self.frame.size.width<320)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, 216);

    yearArray   = [self ishave:yearArray];
    monthArray  = [self ishave:monthArray];
    dayArray    = [self ishave:dayArray];
    hourArray   = [self ishave:hourArray];
    minuteArray = [self ishave:minuteArray];
    secondArray = [self ishave:secondArray];
    
    //赋值
    for (int i = 0; i < UUPICKER_SECOND; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
//        for (int i=0; i<UUPICKER_MINUTE; i++) {
        
            if (0<i && i<=UUPICKER_MONTH)
                [monthArray addObject:num];
            if (i<UUPICKER_HOUR)
                [hourArray addObject:num];
        [minuteArray addObject:num];
//        }
        [secondArray addObject:num];
    }
    
    for (int i=UUPICKER_MINDATE; i<UUPICKER_MAXDATE; i++) {
        NSString *num = [NSString stringWithFormat:@"%d",i];
        [yearArray addObject:num];
    }
    
    //最大最小限制
    if (self.maxLimitDate) {
        maxDateModel = [[UUDatePicker_DateModel alloc]initWithDate:self.maxLimitDate];
    }else{
        self.maxLimitDate = [self dateFromString:@"20491231235959" withFormat:@"yyyyMMddHHmmss"];
        maxDateModel = [[UUDatePicker_DateModel alloc]initWithDate:self.maxLimitDate];
    }
    //最小限制
    if (self.minLimitDate) {
        minDateModel = [[UUDatePicker_DateModel alloc]initWithDate:self.minLimitDate];
    }else{
        self.minLimitDate = [self dateFromString:@"19700101000000" withFormat:@"yyyyMMddHHmmss"];
        minDateModel = [[UUDatePicker_DateModel alloc]initWithDate:self.minLimitDate];
    }
    
    //获取当前日期，储存当前时间位置
    NSArray *indexArray = [self getNowDate:self.ScrollToDate];
    
    if (!myPickerView) {
//        myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30)];
        myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(kScreen_Width/2-150, kScreen_Height/2-75, 300, 150)];
        myPickerView.showsSelectionIndicator = YES;
        myPickerView.backgroundColor = [UIColor clearColor];
        myPickerView.delegate = self;
        myPickerView.dataSource = self;
        [self addSubview:myPickerView];
    }
    //调整为现在的时间
    for (int i=0; i<indexArray.count; i++) {
        [myPickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:NO];
    }
}
#pragma mark - 调整颜色
//获取当前时间解析及位置
- (NSArray *)getNowDate:(NSDate *)date
{
    NSDate *dateShow;
    if (date) {
        dateShow = date;
    }else{
        dateShow = [NSDate date];
    }
    
    UUDatePicker_DateModel *model = [[UUDatePicker_DateModel alloc]initWithDate:dateShow];
    
    [self DaysfromYear:[model.year integerValue] andMonth:[model.month integerValue]];
    
    yearIndex = [model.year intValue]-UUPICKER_MINDATE;
    monthIndex = [model.month intValue]-1;
    dayIndex = [model.day intValue]-1;
    hourIndex = [model.hour intValue]-0;
    minuteIndex = [model.minute intValue]-0;
    secondIndex = [model.second intValue]-0;
    
    NSNumber *year   = [NSNumber numberWithInteger:yearIndex];
    NSNumber *month  = [NSNumber numberWithInteger:monthIndex];
    NSNumber *day    = [NSNumber numberWithInteger:dayIndex];
    NSNumber *hour   = [NSNumber numberWithInteger:hourIndex];
    NSNumber *minute = [NSNumber numberWithInteger:minuteIndex];
    NSNumber *second = [NSNumber numberWithInteger:secondIndex];

    if (self.datePickerStyle == UUDateStyle_YearMonthDayHourMinuteSecond)
        return @[year,month,day,hour,minute,second];
    if (self.datePickerStyle == UUDateStyle_YearMonthDay)
        return @[year,month,day];
    if (self.datePickerStyle == UUDateStyle_MonthDayHourMinute)
        return @[month,day,hour,minute];
    if (self.datePickerStyle == UUDateStyle_HourMinute)
        return @[hour,minute];
    if (self.datePickerStyle == UUDateStyle_YearMonthDayHour)
        return @[year,month,day,hour];
    return nil;
}

- (void)creatValuePointXs:(NSArray *)xArr withNames:(NSArray *)names
{
    for (int i=0; i<xArr.count; i++) {
        [self addLabelWithNames:names[i] withPointX:[xArr[i] intValue]];
    }
}
- (void)addLabelWithNames:(NSString *)name withPointX:(NSInteger)point_x
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/2-190 + point_x, kScreen_Height/2-10, 20, 20)];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor redColor];
    label.layer.shadowColor = [[UIColor whiteColor] CGColor];
    label.layer.shadowOpacity = 0.5;
    label.layer.shadowRadius = 5;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.datePickerStyle == UUDateStyle_YearMonthDayHourMinuteSecond){
//        if (isIOS7) {
//            [self creatValuePointXs:@[@"80",@"135",@"190",@"245",@"300",@"200"]
//                          withNames:@[@"年",@"月",@"日",@"时",@"分",@"秒"]];
//        }
        return 6;
    }
    if (self.datePickerStyle == UUDateStyle_YearMonthDay){
        [self creatValuePointXs:@[@"140",@"220",@"300"]
                      withNames:@[@"年",@"月",@"日"]];
        return 3;
    }
    if (self.datePickerStyle == UUDateStyle_MonthDayHourMinute){
        [self creatValuePointXs:@[@"115",@"185",@"250",@"315"]
                      withNames:@[@"月",@"日",@"时",@"分"]];
        return 4;
    }
    if (self.datePickerStyle == UUDateStyle_HourMinute){
//        if (isIOS7) {
//        [self creatValuePointXs:@[@"140",@"245"]
//                      withNames:@[@"时",@"分"]];
//            }
        return 2;
    }
    if (self.datePickerStyle == UUDateStyle_YearMonthDayHour){
        //        if (isIOS7) {
        //            [self creatValuePointXs:@[@"80",@"135",@"190",@"245"]
        //                          withNames:@[@"年",@"月",@"日",@"时"]];
        //        }
        return 4;
    }
    
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.datePickerStyle == UUDateStyle_YearMonthDayHourMinuteSecond){
        if (component == 0) return UUPICKER_MAXDATE-UUPICKER_MINDATE;
        if (component == 1) return UUPICKER_MONTH;
        if (component == 2) {
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
        if (component == 3) return UUPICKER_HOUR;
        if (component == 4) return UUPICKER_MINUTE;
        if (component == 5) return UUPICKER_SECOND;
    }
    if (self.datePickerStyle == UUDateStyle_YearMonthDay)
    {
        if (component == 0) return UUPICKER_MAXDATE-UUPICKER_MINDATE;
        if (component == 1) return UUPICKER_MONTH;
        if (component == 2){
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
    }
    if (self.datePickerStyle == UUDateStyle_MonthDayHourMinute)
    {
        if (component == 0) return UUPICKER_MONTH;
        if (component == 1){
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
        if (component == 2) return UUPICKER_HOUR;
        if (component == 3) return UUPICKER_MINUTE;
    }
    if (self.datePickerStyle == UUDateStyle_HourMinute)
    {
        if (component == 0) return UUPICKER_HOUR;
        else                return UUPICKER_MINUTE;
    }
    if (self.datePickerStyle == UUDateStyle_YearMonthDayHour){
        if (component == 0) return UUPICKER_MAXDATE-UUPICKER_MINDATE;
        if (component == 1) return UUPICKER_MONTH;
        if (component == 2) {
            return [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
        }
        if (component == 3) return UUPICKER_HOUR;

    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (self.datePickerStyle) {
        case UUDateStyle_YearMonthDayHourMinuteSecond:{
            if (component==0) return 60;
            if (component==1) return 40;
            if (component==2) return 40;
            if (component==3) return 40;
            if (component==4) return 40;
            if (component==5) return 40;
        }
            break;
        case UUDateStyle_YearMonthDay:{
            if (component==0) return 70;
            if (component==1) return 100;
            if (component==2) return 50;
        }
            break;
        case UUDateStyle_MonthDayHourMinute:{
            if (component==0) return 70;
            if (component==1) return 60;
            if (component==2) return 60;
            if (component==3) return 60;
        }
            break;
        case UUDateStyle_HourMinute:{
            if (component==0) return 100;
            if (component==1) return 100;
        }
            break;
        case UUDateStyle_YearMonthDayHour:{
            if (component==0) return 70;
            if (component==1) return 50;
            if (component==2) return 50;
            if (component==3) return 50;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.datePickerStyle) {
        case UUDateStyle_YearMonthDayHourMinuteSecond:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 5 ) {
                secondIndex = row;
            }
            if (component == 0 || component == 1 || component == 2){
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
//                [pickerView reloadComponent:2];
                
            }
        }
            break;
            
            
        case UUDateStyle_YearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
//                [pickerView reloadComponent:2];
            }
        }
            break;
            
            
        case UUDateStyle_MonthDayHourMinute:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            if (component == 0) {
                monthIndex = row;
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
//                [pickerView reloadComponent:1];
            }
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];

        }
            break;
            
            
        case UUDateStyle_HourMinute:{
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
        }
            break;
        case UUDateStyle_YearMonthDayHour:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            
            if (component == 0 || component == 1 || component == 2){
                [self DaysfromYear:[yearArray[yearIndex] integerValue] andMonth:[monthArray[monthIndex] integerValue]];
                if (dayArray.count-1<dayIndex) {
                    dayIndex = dayArray.count-1;
                }
                //                [pickerView reloadComponent:2];
                
            }
        }
            break;
            
        default:
            break;
    }

    [pickerView reloadAllComponents];
    
//    [self playTheDelegate];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:18]];
    }
    UIColor *textColor = [UIColor blackColor];
    NSString *title;
    
    
    
    switch (self.datePickerStyle) {
        case UUDateStyle_YearMonthDayHourMinuteSecond:{
            if (component==0) {
                title = yearArray[row];
                textColor = [self returnYearColorRow:row];
            }
            if (component==1) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==2) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
            if (component==3) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
            if (component==4) {
                title = minuteArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
            if (component==5) {
                title = secondArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
        }
            break;
            
            
        case UUDateStyle_YearMonthDay:{
            if (component==0) {
                title = yearArray[row];
                textColor = [self returnYearColorRow:row];
            }
            if (component==1) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==2) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
        }
            break;
            
        case UUDateStyle_MonthDayHourMinute:{
            if (component==0) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==1) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
            if (component==2) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
            if (component==3) {
                title = minuteArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
        }
            break;
            
        case UUDateStyle_HourMinute:{
            if (component==0) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
            if (component==1) {
                title = minuteArray[row];
                textColor = [self returnMinuteColorRow:row];
            }
        }
            break;
        case UUDateStyle_YearMonthDayHour:{
            if (component==0) {
                title = yearArray[row];
                textColor = [self returnYearColorRow:row];
            }
            if (component==1) {
                title = monthArray[row];
                textColor = [self returnMonthColorRow:row];
            }
            if (component==2) {
                title = dayArray[row];
                textColor = [self returnDayColorRow:row];
            }
            if (component==3) {
                title = hourArray[row];
                textColor = [self returnHourColorRow:row];
            }
        }
            break;

        default:
            break;
    }
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;
}

#pragma mark - 代理回调方法
- (void)playTheDelegate
{
    NSDate *date = [self dateFromString:[NSString stringWithFormat:@"%@%@%@%@%@%@",yearArray[yearIndex],monthArray[monthIndex],dayArray[dayIndex],hourArray[hourIndex],minuteArray[minuteIndex],secondArray[secondIndex]] withFormat:@"yyyyMMddHHmmss"];
    if ([date compare:self.minLimitDate] == NSOrderedAscending) {
        NSArray *array = [self getNowDate:self.minLimitDate];
        for (int i=0; i<array.count; i++) {
            [myPickerView selectRow:[array[i] integerValue] inComponent:i animated:YES];
        }
    }else if ([date compare:self.maxLimitDate] == NSOrderedDescending){
        NSArray *array = [self getNowDate:self.maxLimitDate];
        for (int i=0; i<array.count; i++) {
            [myPickerView selectRow:[array[i] integerValue] inComponent:i animated:YES];
        }
    }
    
    NSString *strWeekDay = [self getWeekDayWithYear:yearArray[yearIndex] month:monthArray[monthIndex] day:dayArray[dayIndex]];
    
    //block 回调
    if (self.finishBlock) {
        self.finishBlock(yearArray[yearIndex],
                         monthArray[monthIndex],
                         dayArray[dayIndex],
                         hourArray[hourIndex],
                         minuteArray[minuteIndex],
                         secondArray[secondIndex],
                         strWeekDay);
    }
    //代理回调
    [self.delegate uuDatePicker:self
                           year:yearArray[yearIndex]
                          month:monthArray[monthIndex]
                            day:dayArray[dayIndex]
                           hour:hourArray[hourIndex]
                         minute:minuteArray[minuteIndex]
                         second:secondArray[secondIndex]
                        weekDay:strWeekDay];
}


#pragma mark - 数据处理
//通过日期求星期
- (NSString*)getWeekDayWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day
{
    NSInteger yearInt   = [year integerValue];
    NSInteger monthInt  = [month integerValue];
    NSInteger dayInt    = [day integerValue];
    int c = 20;//世纪
    int y = (int)yearInt -1;//年
    int d = (int)dayInt;
    int m = (int)monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0: weekDay = @"周日";    break;
        case 1: weekDay = @"周一";    break;
        case 2: weekDay = @"周二";    break;
        case 3: weekDay = @"周三";    break;
        case 4: weekDay = @"周四";    break;
        case 5: weekDay = @"周五";    break;
        case 6: weekDay = @"周六";    break;
        default:break;
    }
    return weekDay;
}

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
   
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:{
            [self setdayArray:31];
            return 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:{
            [self setdayArray:30];
            return 30;
        }
            break;
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

- (UIColor *)returnYearColorRow:(NSInteger)row
{
    if ([yearArray[row] intValue] < [minDateModel.year intValue] || [yearArray[row] intValue] > [maxDateModel.year intValue]) {
        return UU_GRAY;
    }else{
        return UU_BLACK;
    }
}
- (UIColor *)returnMonthColorRow:(NSInteger)row
{
    
    if ([yearArray[yearIndex] intValue] < [minDateModel.year intValue] || [yearArray[yearIndex] intValue] > [maxDateModel.year intValue]) {
        return UU_GRAY;
    }else if([yearArray[yearIndex] intValue] > [minDateModel.year intValue] && [yearArray[yearIndex] intValue] < [maxDateModel.year intValue]){
        return UU_BLACK;
    }else if ([minDateModel.year intValue]==[maxDateModel.year intValue]){
        if ([monthArray[row] intValue] >= [minDateModel.month intValue] && [monthArray[row] intValue] <= [maxDateModel.month intValue]) {
            return UU_BLACK;
        }else {
            return UU_GRAY;
        }
    }else if ([yearArray[yearIndex] intValue] == [minDateModel.year intValue]){
        if ([monthArray[row] intValue] >= [minDateModel.month intValue]) {
            return UU_BLACK;
        }else{
            return UU_GRAY;
        }
    }else {
        if ([monthArray[row] intValue] > [maxDateModel.month intValue]) {
            return UU_GRAY;
        }else{
            return UU_BLACK;
        }
    }
}
- (UIColor *)returnDayColorRow:(NSInteger)row
{
    if ([yearArray[yearIndex] intValue] < [minDateModel.year intValue] || [yearArray[yearIndex] intValue] > [maxDateModel.year intValue]) {
        return UU_GRAY;
    }else if([yearArray[yearIndex] intValue] > [minDateModel.year intValue] && [yearArray[yearIndex] intValue] < [maxDateModel.year intValue]){
        return UU_BLACK;
    }else if ([minDateModel.year intValue]==[maxDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] > [minDateModel.month intValue] && [monthArray[monthIndex] intValue] < [maxDateModel.month intValue]) {
            return UU_BLACK;
        }else if ([minDateModel.month intValue]==[maxDateModel.month intValue]){
            if ([dayArray[row] intValue] >= [minDateModel.day intValue] && [dayArray[row] intValue] <= [maxDateModel.day intValue]) {
                return UU_BLACK;
            }else{
                return UU_GRAY;
            }
        }else {
            return UU_GRAY;
        }
    }else if ([yearArray[yearIndex] intValue] == [minDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] < [minDateModel.month intValue]) {
            return UU_GRAY;
        }else if([monthArray[monthIndex] intValue] == [minDateModel.month intValue]){
            if ([dayArray[row] intValue] >= [minDateModel.day intValue]) {
                return UU_BLACK;
            }else {
                return UU_GRAY;
            }
        }else{
            return UU_BLACK;
        }
    }else {
        if ([monthArray[monthIndex] intValue] > [maxDateModel.month intValue]) {
            return UU_GRAY;
        }else if([monthArray[monthIndex] intValue] == [maxDateModel.month intValue]){
            if ([dayArray[row] intValue] <= [maxDateModel.day intValue]) {
                return UU_BLACK;
            }else{
                return UU_GRAY;
            }
        }else{
            return UU_BLACK;
        }
    }
}
- (UIColor *)returnHourColorRow:(NSInteger)row
{
    if ([yearArray[yearIndex] intValue] < [minDateModel.year intValue] || [yearArray[yearIndex] intValue] > [maxDateModel.year intValue]) {
        return UU_GRAY;
    }else if([yearArray[yearIndex] intValue] > [minDateModel.year intValue] && [yearArray[yearIndex] intValue] < [maxDateModel.year intValue]){
        return UU_BLACK;
    }else if ([minDateModel.year intValue]==[maxDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] > [minDateModel.month intValue] && [monthArray[monthIndex] intValue] < [maxDateModel.month intValue]) {
            return UU_BLACK;
        }else if ([minDateModel.month intValue]==[maxDateModel.month intValue]){
            if ([dayArray[dayIndex] intValue] > [minDateModel.day intValue] && [dayArray[dayIndex] intValue] < [maxDateModel.day intValue]) {
                return UU_BLACK;
            }else if ([minDateModel.day intValue]==[maxDateModel.day intValue]){
                if ([hourArray[row] intValue] >= [minDateModel.hour intValue] && [hourArray[row] intValue] <= [maxDateModel.hour intValue]) {
                    return UU_BLACK;
                }else {
                    return UU_GRAY;
                }
            }else{
                return UU_GRAY;
            }
        }else {
            return UU_GRAY;
        }
    }else if ([yearArray[yearIndex] intValue] == [minDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] < [minDateModel.month intValue]) {
            return UU_GRAY;
        }else if([monthArray[monthIndex] intValue] == [minDateModel.month intValue]){
            if ([dayArray[dayIndex] intValue] < [minDateModel.day intValue]) {
                return UU_GRAY;
            }else if ([dayArray[dayIndex] intValue] == [minDateModel.day intValue]){
                if ([hourArray[row] intValue] < [minDateModel.hour intValue]) {
                    return UU_GRAY;
                }else{
                    return UU_BLACK;
                }
            }else{
                return UU_BLACK;
            }
        }else{
            return UU_BLACK;
        }
    }else {
        if ([monthArray[monthIndex] intValue] > [maxDateModel.month intValue]) {
            return UU_GRAY;
        }else if([monthArray[monthIndex] intValue] == [maxDateModel.month intValue]){
            if ([dayArray[dayIndex] intValue] < [maxDateModel.day intValue]) {
                return UU_BLACK;
            }else if ([dayArray[dayIndex] intValue] == [maxDateModel.day intValue]){
                if ([hourArray[row] intValue] > [maxDateModel.hour intValue]) {
                    return UU_GRAY;
                }else{
                    return UU_BLACK;
                }
            }else{
                return UU_BLACK;
            }
        }else{
            return UU_BLACK;
        }
    }
}
- (UIColor *)returnMinuteColorRow:(NSInteger)row
{
    
    if ([yearArray[yearIndex] intValue] < [minDateModel.year intValue] || [yearArray[yearIndex] intValue] > [maxDateModel.year intValue]) {
        return UU_GRAY;
    }else if([yearArray[yearIndex] intValue] > [minDateModel.year intValue] && [yearArray[yearIndex] intValue] < [maxDateModel.year intValue]){
        return UU_BLACK;
    }else if ([minDateModel.year intValue]==[maxDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] > [minDateModel.month intValue] && [monthArray[monthIndex] intValue] < [maxDateModel.month intValue]) {
            return UU_BLACK;
        }else if ([minDateModel.month intValue]==[maxDateModel.month intValue]){
            if ([dayArray[dayIndex] intValue] > [minDateModel.day intValue] && [dayArray[dayIndex] intValue] < [maxDateModel.day intValue]) {
                return UU_BLACK;
            }else if ([minDateModel.day intValue]==[maxDateModel.day intValue]){
                if ([hourArray[hourIndex] intValue] > [minDateModel.hour intValue] && [hourArray[hourIndex] intValue] < [maxDateModel.hour intValue]) {
                    return UU_BLACK;
                }else if ([minDateModel.hour intValue]==[maxDateModel.hour intValue]){
                    if ([minuteArray[row] intValue] <= [maxDateModel.minute intValue] &&[minuteArray[row] intValue] >= [minDateModel.minute intValue]) {
                        return UU_BLACK;
                    }else{
                        return UU_GRAY;
                    }
                }else{
                    return UU_GRAY;
                }
            }else{
                return UU_GRAY;
            }
        }else {
            return UU_GRAY;
        }
    }else if ([yearArray[yearIndex] intValue] == [minDateModel.year intValue]){
        if ([monthArray[monthIndex] intValue] < [minDateModel.month intValue]) {
            return UU_GRAY;
        }else if([monthArray[monthIndex] intValue] == [minDateModel.month intValue]){
            if ([dayArray[dayIndex] intValue] < [minDateModel.day intValue]) {
                return UU_GRAY;
            }else if ([dayArray[dayIndex] intValue] == [minDateModel.day intValue]){
                if ([hourArray[hourIndex] intValue] < [minDateModel.hour intValue]) {
                    return UU_GRAY;
                }else if ([hourArray[hourIndex] intValue] == [minDateModel.hour intValue]){
                    if ([minuteArray[row] intValue] < [minDateModel.minute intValue]) {
                        return UU_GRAY;
                    }else{
                        return UU_BLACK;
                    }
                }else{
                    return UU_BLACK;
                }
            }else{
                return UU_BLACK;
            }
        }else{
            return UU_BLACK;
        }
    }else{
        if ([monthArray[monthIndex] intValue] > [maxDateModel.month intValue]) {
            return UU_GRAY;
        }else if([monthArray[monthIndex] intValue] == [maxDateModel.month intValue]){
            if ([dayArray[dayIndex] intValue] < [maxDateModel.day intValue]) {
                return UU_BLACK;
            }else if ([dayArray[dayIndex] intValue] == [maxDateModel.day intValue]){
                if ([hourArray[hourIndex] intValue] > [maxDateModel.hour intValue]) {
                    return UU_GRAY;
                }else if([hourArray[hourIndex] intValue] == [maxDateModel.hour intValue]){
                    if ([minuteArray[row] intValue] <= [maxDateModel.minute intValue]) {
                        return UU_BLACK;
                    }else{
                        return UU_GRAY;
                    }
                }else{
                    return UU_BLACK;
                }
                
                
            }else{
                return UU_BLACK;
            }
        }else{
            return UU_BLACK;
        }
    }
}
@end
