//
//  ComplainTypeCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainTypeCell.h"
#import "ComplainSectionModel.h"
#import "ChooseViewController.h"

@interface ComplainTypeCell ()<UITextFieldDelegate>

@end

@implementation ComplainTypeCell
{
    UIButton *qualityButton;
    UIButton *serveButton;
    UIButton *synthesizeButton;

    UITextField *qualityTextField;
    UITextField *serveTextField;

    UIView *lineView1;

    UIImageView *qualityImageView;
    UIImageView *serveImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }

    return self;
}

- (void)makeUI{
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = colorBlack;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = @"投诉类型：";

    qualityButton = [self button];
    serveButton = [self button];
    synthesizeButton = [self button];

    UILabel *qualityLabel = [self labelWithText:@" 质量问题"];
    UILabel *serveLabel = [self labelWithText:@" 服务问题"];
    UILabel *synthesizeLabel = [self labelWithText:@" 综合问题"];

    qualityLabel.userInteractionEnabled = YES;
    serveLabel.userInteractionEnabled = YES;
    synthesizeLabel.userInteractionEnabled = YES;

    [qualityLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)]];
    [serveLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)]];
    [synthesizeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3)]];

    qualityTextField = [[UITextField alloc] init];
    qualityTextField.font = [UIFont systemFontOfSize:15];
    qualityTextField.textColor = colorBlack;
    qualityTextField.leftViewMode = UITextFieldViewModeAlways;
    qualityTextField.leftView = [self labelWithText:@"质量投诉部位  "];
    qualityTextField.placeholder = @"请选择质量投诉部位";
    qualityTextField.delegate = self;

    serveTextField = [[UITextField alloc] init];
    serveTextField.font = [UIFont systemFontOfSize:15];
    serveTextField.textColor = colorBlack;
    serveTextField.leftViewMode = UITextFieldViewModeAlways;
    serveTextField.leftView = [self labelWithText:@"服务投诉问题  "];
    serveTextField.placeholder = @"请选择服务投诉问题";
    serveTextField.delegate = self;

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = RGB_color(240, 240, 240, 1);

    lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = RGB_color(240, 240, 240, 1);

    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = RGB_color(240, 240, 240, 1);


    qualityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    serveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];



    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:qualityButton];
    [self.contentView addSubview:serveButton];
    [self.contentView addSubview:synthesizeButton];
    [self.contentView addSubview:qualityTextField];
    [self.contentView addSubview:serveTextField];
    [self.contentView addSubview:qualityLabel];
    [self.contentView addSubview:serveLabel];
    [self.contentView addSubview:synthesizeLabel];
    [self.contentView addSubview:lineView1];
    [self.contentView addSubview:lineView2];
    [self.contentView addSubview:lineView3];
    [self.contentView addSubview:qualityImageView];
    [self.contentView addSubview:serveImageView];

    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(20);
    }];

    [qualityLabel sizeToFit];
    CGFloat space = (WIDTH-qualityLabel.lh_width*3-16*3-5*3)/4;
    [qualityButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(space);
        make.top.equalTo(nameLabel.bottom).offset(20);
        make.size.equalTo(CGSizeMake(16, 16));
    }];

    [qualityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qualityButton.right);
        make.centerY.equalTo(qualityButton);
    }];

    [serveButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qualityLabel.right).offset(space);
        make.top.equalTo(qualityButton);
        make.size.equalTo(CGSizeMake(16, 16));
    }];

    [serveLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serveButton.right);
        make.centerY.equalTo(qualityButton);
    }];


    [synthesizeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serveLabel.right).offset(space);
        make.top.equalTo(qualityButton);
        make.size.equalTo(CGSizeMake(16, 16));
    }];

    [synthesizeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(synthesizeButton.right);
        make.centerY.equalTo(qualityButton);
    }];

    [lineView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];

    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-50);
        make.height.equalTo(1);
    }];

    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-100);
        make.height.equalTo(1);
    }];
}

- (void)tap1{
    [self buttonClick:qualityButton];
}

- (void)tap2{
    [self buttonClick:serveButton];
}

- (void)tap3{
    [self buttonClick:synthesizeButton];
}


- (UIButton *)button{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderColor = colorDeepGray.CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 8;
    [button setTitle:@"•" forState:UIControlStateSelected];
    [button setTitleColor:colorDeepGray forState:UIControlStateSelected];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 1, 0)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(UIButton *)button{


    if (button == qualityButton) {
       _typeModel.type = @"质量问题";
        _typeModel.serveValue = @"";
    }else if (button == serveButton){
        _typeModel.type = @"服务问题";
        _typeModel.qualityValue = @"";
    }else{
        _typeModel.type = @"综合问题";
    }

    [self resetting];
    [self.delegate updateLayout];
}

- (void)resetting{

    qualityTextField.text = _typeModel.qualityValue;
    serveTextField.text = _typeModel.serveValue;
    
    if ([_typeModel.type isEqualToString:@"质量问题"]) {
        lineView1.hidden = YES;
        qualityButton.selected = YES;
        serveButton.selected = NO;
        synthesizeButton.selected = NO;

        serveTextField.hidden = YES;
        qualityTextField.hidden = NO;

        serveImageView.hidden = YES;
        qualityImageView.hidden = NO;

        qualityTextField.lh_top = 90;
        qualityTextField.lh_left = 10;
        qualityTextField.lh_size = CGSizeMake(WIDTH-40, 50);

        qualityImageView.lh_size = CGSizeMake(20, 20);
        qualityImageView.lh_centerY = qualityTextField.lh_centerY;
        qualityImageView.lh_right = WIDTH-10;

        _typeModel.cellHeight = qualityTextField.lh_bottom;

    }else if ([_typeModel.type isEqualToString:@"服务问题"]){
        lineView1.hidden = YES;
        qualityButton.selected = NO;
        serveButton.selected = YES;
        synthesizeButton.selected = NO;

        serveTextField.hidden = NO;
        qualityTextField.hidden = YES;

        serveImageView.hidden = NO;
        qualityImageView.hidden = YES;

        serveTextField.lh_top = 90;
        serveTextField.lh_left = 10;
        serveTextField.lh_size = CGSizeMake(WIDTH-40, 50);

        serveImageView.lh_size = CGSizeMake(20, 20);
        serveImageView.lh_centerY = serveTextField.lh_centerY;
        serveImageView.lh_right = WIDTH-10;

        _typeModel.cellHeight = serveTextField.lh_bottom;
    }else{
         lineView1.hidden = NO;
        qualityButton.selected = NO;
        serveButton.selected = NO;
        synthesizeButton.selected = YES;

        serveTextField.hidden = NO;
        qualityTextField.hidden = NO;

        serveImageView.hidden = NO;
        qualityImageView.hidden = NO;

        qualityTextField.lh_top = 90;
        qualityTextField.lh_left = 10;
        qualityTextField.lh_size = CGSizeMake(WIDTH-40, 50);

        serveTextField.lh_top = qualityTextField.lh_bottom;
        serveTextField.lh_left = 10;
        serveTextField.lh_size = CGSizeMake(WIDTH-40, 50);

        qualityImageView.lh_size = CGSizeMake(20, 20);
        qualityImageView.lh_centerY = qualityTextField.lh_centerY;
        qualityImageView.lh_right = WIDTH-10;

        serveImageView.lh_size = CGSizeMake(20, 20);
        serveImageView.lh_centerY = serveTextField.lh_centerY;
        serveImageView.lh_right = WIDTH-10;

        _typeModel.cellHeight = serveTextField.lh_bottom;
    }
}


- (void)setTypeModel:(ComplainTypeModel *)typeModel{
    _typeModel = typeModel;

    [self resetting];
}

- (UILabel *)labelWithText:(NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = colorBlack;
    label.text = text;
    label.font = [UIFont systemFontOfSize:15];
    [label sizeToFit];
    return label;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    __weak __typeof(self)weakSelf = self;
    ChooseViewController *choose = [[ChooseViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:choose];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [choose retrunResults:^(NSString *title, NSString *ID) {
        if (textField == qualityTextField) {
            weakSelf.typeModel.qualityValue = title;
            qualityTextField.text = title;
        }else{
            weakSelf.typeModel.serveValue = title;
            serveTextField.text = title;
        }
    }];

    if (textField == qualityTextField) {
        choose.choosetype = chooseTypeComplainQuality;
    }else{
        choose.choosetype = chooseTypeComplainService;
    }
    [self.parentViewController presentViewController:nvc animated:YES completion:nil];
    return NO;
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
