//
//  BrandTableViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BrandTableViewCell.h"
#import "ComplainSectionModel.h"
#import "ChooseViewController.h"

@interface BrandTableViewCell ()<UITextFieldDelegate>
{
    UITextField *brandTextField;
    UITextField *seriesTextField;
    UITextField *modelTextField;

    UIButton *brandButon;
    UIButton *seriesButon;
    UIButton *modelButon;
}
@end

@implementation BrandTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }

    return self;
}

- (void)makeUI{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = colorBlack;
    nameLabel.text = @"投诉车型：";

    UIView *lineView  = [[UIView alloc ] init];
    lineView.backgroundColor = RGB_color(240, 240, 240, 1);

    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:lineView];

    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(0);
        make.height.equalTo(50);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(nameLabel.bottom);
        make.height.equalTo(1);
    }];

    NSArray *fields = @[@"brandTextField",@"seriesTextField",@"modelTextField"];
    NSArray *bottons = @[@"brandButon",@"seriesButon",@"modelButon"];
    NSArray *leftTexts = @[@"品牌",@"车系",@"车型"];

    UIView *temp;
    for (int i = 0; i < 3; i ++) {
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.text = leftTexts[i];
        leftLabel.font = [UIFont systemFontOfSize:15];
        leftLabel.textColor = colorBlack;

        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = colorBlack;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:15];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"自定义" forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateSelected];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:colorLightBlue forState:UIControlStateNormal];

        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGB_color(240, 240, 240, 1);

        [self.contentView addSubview:leftLabel];
        [self.contentView addSubview:textField];
        [self.contentView addSubview:btn];
        [self.contentView addSubview:line];

        [self setValue:textField forKey:fields[i]];
        [self setValue:btn forKey:bottons[i]];

        if (temp == nil) {
            [leftLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.top.equalTo(lineView.bottom);
                make.height.equalTo(50);
                make.width.equalTo(40);
            }];
        }else{
            [leftLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.top.equalTo(temp.bottom).offset(1);
                make.size.equalTo(CGSizeMake(40, 50));
            }];
        }

        temp = leftLabel;

        [textField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.right).offset(5);
            make.top.equalTo(leftLabel);
            make.height.equalTo(50);
            make.right.equalTo(-70);
        }];

        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(leftLabel);
            make.height.equalTo(50);
        }];

        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.left);
            make.top.equalTo(leftLabel.bottom);
            make.right.equalTo(-10);
            make.height.equalTo(1);
        }];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextChange:(NSNotification *)notification {

    if (notification.object == brandTextField) {
        self.brandModel.brandName = brandTextField.text;

    }else if (notification.object == seriesTextField){

        self.brandModel.seriesName = seriesTextField.text;

    }else if (notification.object == modelTextField){

        self.brandModel.modelName = modelTextField.text;

    }
    [self.delegate updateBrandModel:self.brandModel];
    [self restting];
}

- (void)buttonClick:(UIButton *)button{
    BOOL selected = !button.selected;
    button.selected = selected;

    [self endEidge];

    if (button == brandButon) {
        _brandModel.brandSelected = selected;
        _brandModel.seriesSelected = NO;
        _brandModel.modelSelected = NO;

        _brandModel.brandName = @"";
        _brandModel.seriesName = @"";
        _brandModel.modelName = @"";
        if (selected) {
            _brandModel.BrandId = nil;
            _brandModel.SeriesId = nil;
            _brandModel.ModelId = nil;
        }

    }else if (button == seriesButon){

        _brandModel.seriesSelected = selected;
        _brandModel.modelSelected = NO;

        _brandModel.seriesName = @"";
        _brandModel.modelName = @"";
        if (selected) {
            _brandModel.SeriesId = nil;
            _brandModel.ModelId = nil;
        }

    }else{

        _brandModel.modelSelected = selected;
        _brandModel.modelName = @"";
        if (selected) {
            _brandModel.ModelId = nil;
        }
    }

    [self restting];
}

- (void)endEidge{
    [brandTextField resignFirstResponder];
    [seriesTextField resignFirstResponder];
    [modelTextField resignFirstResponder];
}

- (void)restting{

    brandTextField.text = _brandModel.brandName;
    seriesTextField.text = _brandModel.seriesName;
    modelTextField.text = _brandModel.modelName;



    seriesButon.enabled = YES;
    modelButon.enabled = YES;

    brandButon.selected = _brandModel.brandSelected;
    seriesButon.selected = _brandModel.seriesSelected;
    modelButon.selected = _brandModel.modelSelected;


    [seriesButon setTitleColor:colorLightBlue forState:UIControlStateNormal];
    [modelButon setTitleColor:colorLightBlue forState:UIControlStateNormal];

    brandTextField.placeholder = _brandModel.brandSelected?@"输入品牌":@"请选择您的品牌";
    seriesTextField.placeholder = @"选择车系";
    modelTextField.placeholder = @"选择车型";

    if (_brandModel.brandSelected) {
        seriesButon.enabled = NO;
        modelButon.enabled = NO;
        [seriesButon setTitleColor:colorLightGray forState:UIControlStateNormal];
        [modelButon setTitleColor:colorLightGray forState:UIControlStateNormal];
        seriesTextField.placeholder = @"输入车系";
        modelTextField.placeholder = @"输入车型";
    }else if(_brandModel.seriesSelected){
        modelButon.enabled = NO;
        [modelButon setTitleColor:colorLightGray forState:UIControlStateNormal];
        seriesTextField.placeholder = @"输入车系";
        modelTextField.placeholder = @"输入车型";
    }else if (_brandModel.modelSelected){
        modelTextField.placeholder = @"输入车型";
    }
}

- (void)setBrandModel:(ComplainBrandModel *)brandModel{
    _brandModel = brandModel;

    [self restting];
}

#pragma mark - 选择列表
-(void)chooseViewController:(UITextField *)field{

    __weak __typeof(self)weakSelf = self;
    ChooseViewController *choose = [[ChooseViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:choose];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [choose retrunResults:^(NSString *title, NSString *ID) {
        field.text = title;

        if (field == brandTextField) {
            weakSelf.brandModel.BrandId = ID;
            weakSelf.brandModel.SeriesId = @"";
            weakSelf.brandModel.ModelId = @"";

            weakSelf.brandModel.brandName = title;
            weakSelf.brandModel.seriesName = @"";
            weakSelf.brandModel.modelName = @"";

        }else if (field == seriesTextField){
            weakSelf.brandModel.SeriesId = ID;
            weakSelf.brandModel.ModelId = @"";

            weakSelf.brandModel.seriesName = title;
            weakSelf.brandModel.modelName = @"";

        }else if (field == modelTextField){
            weakSelf.brandModel.ModelId = ID;
            weakSelf.brandModel.modelName = title;

        }
        [weakSelf.delegate updateBrandModel:weakSelf.brandModel];
        [weakSelf restting];
    }];
    if (field == brandTextField) {
        choose.choosetype = chooseTypeBrand;
    }else if (field == seriesTextField){
        choose.ID = self.brandModel.BrandId;
        choose.choosetype = chooseTypeSeries;

    }else if (field == modelTextField){
        choose.ID = self.brandModel.SeriesId;
        choose.choosetype = chooseTypeModel;

    }

    [self.parentViewController presentViewController:nvc animated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //如果是投诉类型
    if (textField == brandTextField) {
        //是否自定义
        if (self.brandModel.brandSelected) {
            return YES;
        }
        [self endEidge];
        [self chooseViewController:textField];
        return NO;
    }
    //投诉车系
    if (textField == seriesTextField) {

        if (self.brandModel.brandSelected || self.brandModel.seriesSelected) {
            return YES;
        }
         [self endEidge];
        if (self.brandModel.BrandId.length > 0) {
            [self chooseViewController:textField];
        }else{
            [LHController alert:@"还未选择品牌"];
        }

        return NO;
    }
    //车型
    if (textField == modelTextField) {

        if (self.brandModel.brandSelected || self.brandModel.seriesSelected || self.brandModel.modelSelected) {
            return YES;
        }
         [self endEidge];

        //       NSString *str = [NSString stringWithUTF8String:object_getClassName(seriesId)];
        if ([self.brandModel.SeriesId floatValue] > 0) {
            [self chooseViewController:textField];
        }else{
            [LHController alert:@"还未选择车系"];
        }

        return NO;
    }

    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
