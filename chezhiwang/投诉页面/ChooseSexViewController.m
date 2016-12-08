//
//  ChooseSexViewController.m
//  chezhiwang
//
//  Created by bangong on 16/11/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChooseSexViewController.h"

@interface ChooseSexViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickerView;
    UIView *_pickerSuperView;
    UILabel *_titleLabel;
    NSString *_selectText;
    NSString *_selectID;
}
@end

@implementation ChooseSexViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self createPickView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGB_color(0, 0, 0, 0.5);
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    // Do any additional setup after loading the view.
}

#pragma  mark - 创建选择列表框pickView
-(void)createPickView{
    _pickerSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 240)];
    _pickerSuperView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerSuperView];

    UIButton *button = [LHController createButtnFram:CGRectMake(WIDTH-60, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"完成"];
    button.titleLabel.font = [UIFont systemFontOfSize:15];

    [button setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [_pickerSuperView addSubview:button];

    UIButton *qx = [LHController createButtnFram:CGRectMake(20, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"取消"];
    qx.titleLabel.font = [UIFont systemFontOfSize:15];
    [qx setTitleColor:colorDeepGray forState:UIControlStateNormal];
    [_pickerSuperView addSubview:qx];

    _titleLabel = [LHController createLabelWithFrame:CGRectMake(60, 10, WIDTH-120, 20) Font:17 Bold:NO TextColor:colorBlack Text:nil];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_pickerSuperView addSubview:_titleLabel];

    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 180)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerSuperView addSubview:_pickerView];
}


-(void)pickViewClick:(UIButton *)btn{

    [self dismissView];

    if ([btn.titleLabel.text isEqualToString:@"完成"]) {
        if (self.block) {
            self.block(_selectText,_selectID);
        }
    }
}

-(void)setTitleText:(NSString *)titleText{
    _titleLabel.text = titleText;
}

-(void)setDataArray:(NSArray *)dataArray{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }

    [_pickerView reloadAllComponents];
}

-(void)returnResult:(returnResult)block{
    self.block = block;
}

-(void)showPickerView{
    [UIView animateWithDuration:0.2 animations:^{
        _pickerSuperView.frame = CGRectMake(0, HEIGHT-240, WIDTH, 240);
    }];
}

-(void)dismissView{
    [UIView animateWithDuration:0.2 animations:^{
        _pickerSuperView.frame = CGRectMake(0, HEIGHT, WIDTH, 240);
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 列表框pickerViewDataSource代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,_pickerView.frame.size.width,40.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _dataArray[row][@"title"];

    if (row == 0) {
        _selectText = label.text;
    }
    return label;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectText = _dataArray[row][@"title"];
    _selectID = _dataArray[row][@"id"];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
