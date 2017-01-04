//
//  CZWCardChooseViewController.m
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWCardChooseViewController.h"
#import "CZWDatePicker.h"
#import "CZWPickerView.h"
#import "NSString-Helper.h"
#import "MyCarModel.h"

@interface CZWCardChooseViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
}
@end

@implementation CZWCardChooseViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = colorBackGround;
    [self.view addSubview:[UIView new]];
    [self createLeftItemBack];
    [self createRightItem];
    [self createTextField];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_textField.enabled) {
        [_textField becomeFirstResponder];
    }
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"保存"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{

    if (_choose == cardChooseTypeName) {
        if (![NSString isName:_textField.text]) {
            [LHController alert:@"姓名只能包含汉子和字母"];
            return;
        }
    }

    if (_choose == cardChooseTypeSex){

        if (_textField.text.length == 0) {
            [LHController alert:@"请选择性别"];
            return;
        }

    }

    if (_choose == cardChooseTypeBirth){
        if (_textField.text.length == 0) {
            [LHController alert:@"请选择生日"];
            return;
        }

    }
    if (_choose == cardChooseTypeAge){
        if ([_textField.text integerValue] <= 10) {
            [LHController alert:@"请输入大于10的数字"];
            return;
        }

    }

    if (_choose == cardChooseTypePhoneNumber){
        if (!([NSString isNumber:_textField.text] && _textField.text.length == 11)) {
            [LHController alert:@"手机号码须为11位数字"];
            return;
        }

    }

    if (_choose == cardChooseTypeEmail){
        if (!([NSString isEmailTest:_textField.text] && _textField.text.length > 0)) {
            [LHController alert:@"邮箱格式不正确"];
            return;
        }

    }

    if (_choose == cardChooseTypeTelephone){
        if (![NSString isNotNULL:_textField.text]) {
            [LHController alert:@"您还没有输入内容"];
            return;
        }

    }

    if (_choose == cardChooseTypeQQ){
        if (![NSString isNumber:_textField.text]) {
            [LHController alert:@"qq号只能输入数字"];
            return;
        }


    }

    if (_choose == cardChooseTypeCompany){
        if (![NSString isNotNULL:_textField.text]) {
            [LHController alert:@"你还没有输入内容"];
            return;
        }
    }

    if (_choose == cardChooseTypeProfessional){
        if (![NSString isNotNULL:_textField.text]) {
            [LHController alert:@"你还没有输入内容"];
            return;
        }

    }

    if (_choose == cardChooseTypeBeGoodAt){
        if (![NSString isNotNULL:_textField.text]) {
            [LHController alert:@"你还没有输入内容"];
            return;
        }
    }

    [self submitData];
}

//提交数据
-(void)submitData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *text = _textField.text;
    if ([text isEqualToString:@"男"]) {
      text = @"1";
    }else if ([text isEqualToString:@"女"]){
      text = @"2";
    }
    dict[self.model.submitKey] = text;


    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForpersonalInfo],[CZWManager manager].userID];
    [HttpRequest POST:url parameters:dict success:^(id responseObject) {
                                           
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        if (responseObject[@"error"]) {
            [LHController alert:responseObject[@"error"]];
        }else if(responseObject[@"success"]){
            [LHController alert:responseObject[@"success"]];
            weakSelf.model.value = _textField.text;
            if (weakSelf.block) {
                weakSelf.block(weakSelf.model.valueKey,_textField.text);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;

    }];
}

-(void)createTextField{


    _textField = [LHController createTextFieldWithFrame:CGRectMake(0, 84, WIDTH, 40) Placeholder:nil Font:15 Delegate:self];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.text = self.model.value;
    _textField.placeholder = self.model.placeholder;
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    [self.view addSubview:_textField];

    if (_choose == cardChooseTypeBirth) {
        _textField.enabled = NO;
        [self createDatePicker];
    }else if (_choose == cardChooseTypeSex){
        _textField.enabled = NO;
        CZWPickerView *pickerView = [[CZWPickerView alloc] initWithFrame:CGRectZero];
        pickerView.sections = [CZWPickerViewSectionModel sex];
        [pickerView reloadAllComponents];
        pickerView.didSelectRow = ^(CZWPickerViewModel *model){
            _textField.text = model.title;
        };
        [self.view addSubview:pickerView];

        pickerView.lh_left = 0;
        pickerView.lh_top = _textField.lh_bottom + 10;
        pickerView.lh_size = CGSizeMake(WIDTH, 180);

    }
}

-(void)createDatePicker{
    CZWDatePicker *picker = [[CZWDatePicker alloc] initWithFrame:CGRectMake(0, _textField.frame.origin.y+_textField.frame.size.height+10, WIDTH, 180)];
    picker.backgroundColor = [UIColor whiteColor];
    [picker returnDate:^(NSString *date) {
        _textField.text = date;
    }];
    [self.view addSubview:picker];

}



- (void)setModel:(MyCarModel *)model{
    _model = model;

    self.title = model.name;
}

-(void)success:(success)block{
    self.block = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (self.se) {
//        <#statements#>
//    }
//}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
