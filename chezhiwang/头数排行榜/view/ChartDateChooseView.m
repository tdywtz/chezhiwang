//
//  ChartDateChooseView.m
//  chezhiwang
//
//  Created by bangong on 16/11/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartDateChooseView.h"

@implementation ChartDateChooseView
{
    UIDatePicker *beginDatePicker;
    UIDatePicker *endDatePicker;

    UILabel *beginDateLabel;
    UILabel *endDateLabel;
}


- (instancetype)initWithFrame:(CGRect)frame chooseDeate:(void(^)(NSString *, NSString *))chooseDeate{
    self = [super initWithFrame:frame];
    if (self) {
        self.chooseDeate = chooseDeate;
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        self.alpha = 0;
        [self createDatePicker];
    }
    return self;
}

-(void)createDatePicker{

    CGFloat XS = HEIGHT/667.0;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];


    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitle:@"确认" forState:UIControlStateNormal];
    [finishButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel *beginlabel = [[UILabel alloc] init];
    beginlabel.text = @"开始日期";


    beginDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, WIDTH/2, 40)];
    beginDateLabel.font = [UIFont systemFontOfSize:17];
    beginDateLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text  = @"结束日期";

    endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 40, WIDTH/2, 40)];
    endDateLabel.font = [UIFont systemFontOfSize:17];
    endDateLabel.textAlignment = NSTextAlignmentCenter;

    beginDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 180)];
    beginDatePicker.transform = CGAffineTransformMakeScale(1, 1*XS);
    //最小时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    beginDatePicker.minimumDate = [formatter dateFromString:@"1919-10-10"];
    //最大时间
    beginDatePicker.maximumDate = [NSDate date];
    //设置时间模式为中文显示
    beginDatePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [beginDatePicker setLocale:locale];
    //添加事件
    [beginDatePicker addTarget:self action:@selector(beginDateClick) forControlEvents:UIControlEventValueChanged];
    CGRect rect = beginDatePicker.frame;
    rect.origin.x = 0;
    beginDatePicker.frame = rect;

    endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, WIDTH, 180)];
    endDatePicker.transform = CGAffineTransformMakeScale(1, 1*XS);
    //最小时间
    [formatter setDateFormat:@"yyyy-MM-dd"];
    endDatePicker.minimumDate = [formatter dateFromString:@"1980-10-10"];
    //最大时间
    endDatePicker.maximumDate = [NSDate date];
    //设置时间模式为中文显示
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker setLocale:locale];
    //添加事件
    [endDatePicker addTarget:self action:@selector(endDateClick) forControlEvents:UIControlEventValueChanged];

    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = RGB_color(240, 240, 240, 1);

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = RGB_color(240, 240, 240, 1);

    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = RGB_color(240, 240, 240, 1);

    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = RGB_color(240, 240, 240, 1);

    [self addSubview:cancelButton];
    [self addSubview:finishButton];
    [self addSubview:beginDateLabel];
    [self addSubview:endDateLabel];
    [self addSubview:beginlabel];
    [self addSubview:endLabel];
    [self addSubview:beginDatePicker];
    [self addSubview:endDatePicker];
    [self addSubview:lineView1];
    [self addSubview:lineView2];
    [self addSubview:lineView3];
    [self addSubview:lineView4];

    [beginlabel sizeToFit];
    beginlabel.lh_left = 10;
    beginlabel.lh_top = 10*XS;
    beginlabel.lh_height = 40*XS;
    beginlabel.lh_width = 120;

    beginDateLabel.lh_height = beginlabel.lh_height;
    beginDateLabel.lh_width = 160;
    beginDateLabel.lh_centerX = self.lh_centerX;
    beginDateLabel.lh_centerY = beginlabel.lh_centerY;


    lineView1.lh_left = 10;
    lineView1.lh_height = 1;
    lineView1.lh_width = WIDTH-10;
    lineView1.lh_top = beginlabel.lh_bottom;

    beginDatePicker.lh_left = 0;
    beginDatePicker.lh_width = WIDTH;
    beginDatePicker.lh_top = lineView1.lh_bottom + 15*XS;

    lineView2.lh_left = 0;
    lineView2.lh_size = CGSizeMake(WIDTH, 5);
    lineView2.lh_top = beginDatePicker.lh_bottom + 15*XS;

    endLabel.lh_left = 10;
    endLabel.lh_size = beginlabel.lh_size;
    endLabel.lh_top = lineView2.lh_bottom + 10*XS;

    endDateLabel.lh_size = beginDateLabel.lh_size;
    endDateLabel.lh_centerX = beginDatePicker.lh_centerX;
    endDateLabel.lh_centerY = endLabel.lh_centerY;

    lineView3.lh_left = 10;
    lineView3.lh_size = lineView1.lh_size;
    lineView3.lh_top = endLabel.lh_bottom;

    endDatePicker.lh_left = 0;
    endDatePicker.lh_width = WIDTH;
    endDatePicker.lh_top = lineView3.lh_bottom + 15*XS;

    lineView4.lh_left = lineView1.lh_left;
    lineView4.lh_top = endDatePicker.lh_bottom + 15*XS;
    lineView4.lh_size = lineView1.lh_size;

    [cancelButton sizeToFit];
    cancelButton.lh_left = 10;
    cancelButton.lh_top = lineView4.lh_bottom+10*XS;

    [finishButton sizeToFit];
    finishButton.lh_right = WIDTH -10;
    finishButton.lh_top = cancelButton.lh_top;
}

- (void)cancelClick{
    [self dismiss];
}

- (void)finishButtonClick{
    if ([beginDateLabel.text floatValue] < 100) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择开始时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self.parentViewController presentViewController:ac animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ac dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }else if ([endDateLabel.text floatValue] < 100){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择结束时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self.parentViewController presentViewController:ac animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ac dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    if ([endDateLabel.text integerValue] > 100 && [beginDateLabel.text integerValue] > 100) {
        if (self.chooseDeate) {

            NSString *beginDate = [beginDateLabel.text copy];
            NSString *endDate = [endDateLabel.text copy];

            beginDate =  [beginDate stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
            beginDate =  [beginDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
            beginDate =  [beginDate stringByReplacingOccurrencesOfString:@"日" withString:@""];

            endDate =  [endDate stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
            endDate = [endDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
            endDate = [endDate stringByReplacingOccurrencesOfString:@"日" withString:@""];
           
            self.chooseDeate(beginDate,endDate);
        }
    }

    [self dismiss];
}


-(void)beginDateClick{
    //转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    beginDateLabel.text = [self replace:[formatter stringFromDate:beginDatePicker.date]];
    endDatePicker.minimumDate = beginDatePicker.date;
}

-(void)endDateClick
{
    //转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    endDateLabel.text  = [self replace:[formatter stringFromDate:endDatePicker.date]];
    beginDatePicker.maximumDate = endDatePicker.date;
}

- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];

    beginDatePicker.date = [NSDate date];
    beginDateLabel.text = [self replace:[formatter stringFromDate:beginDatePicker.date]];
    endDatePicker.date = [NSDate date];
    endDateLabel.text = [self replace:[formatter stringFromDate:endDatePicker.date]];
}

- (NSString *)replace:(NSString *)string{
    NSMutableString *mstring = [string mutableCopy];
    [mstring replaceCharactersInRange:[mstring rangeOfString:@"-"] withString:@"年"];
    [mstring replaceCharactersInRange:[mstring rangeOfString:@"-"] withString:@"月"];
    [mstring appendString:@"日"];
    return mstring;
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


- (void)setDate:(NSString *)dateString  datePiker:(UIDatePicker *)datePiker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
