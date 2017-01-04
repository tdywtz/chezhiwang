//
//  CZWPickerView.m
//  chezhiwang
//
//  Created by bangong on 16/12/20.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWPickerView.h"

#pragma mark - CZWPickerViewModel
@implementation CZWPickerViewModel

+ (instancetype)initWithID:(NSString *)ID title:(NSString *)title{
    CZWPickerViewModel *model = [[CZWPickerViewModel alloc] init];
    model.ID = ID;
    model.title = title;
    return model;
}

@end

#pragma mark - CZWPickerViewSectionModel
@implementation CZWPickerViewSectionModel

+ (NSArray *)sex{
    CZWPickerViewSectionModel *sectionModel = [[CZWPickerViewSectionModel alloc] init];
    sectionModel.rowModels = @[
                               [CZWPickerViewModel initWithID:@"1" title:@"男"],
                               [CZWPickerViewModel initWithID:@"0" title:@"女"]
                               ];
    return @[sectionModel];
}

@end

#pragma mark - CZWPickerView
@interface CZWPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation CZWPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - 列表框pickerViewDataSource代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return self.sections.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    CZWPickerViewSectionModel *sectionModel = self.sections[component];
    return sectionModel.rowModels.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.frame.size.width,40.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    CZWPickerViewSectionModel *sectionModel = self.sections[component];
    CZWPickerViewModel *model = sectionModel.rowModels[row];
    label.text = model.title;

    return label;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.didSelectRow) {
        CZWPickerViewSectionModel *sectionModel = self.sections[component];
        CZWPickerViewModel *model = sectionModel.rowModels[row];
        self.didSelectRow(model);
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
