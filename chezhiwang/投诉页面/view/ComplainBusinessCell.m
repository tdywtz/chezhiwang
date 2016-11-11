//
//  ComplainBusinessCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainBusinessCell.h"
#import "ComplainSectionModel.h"
#import "ChooseViewController.h"
#import "CityChooseViewController.h"

@interface ComplainBusinessCell ()<UITextFieldDelegate>
{
    UIButton *button;
}
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *proTextField;
@property (nonatomic,strong) UITextField *businessTextField;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;

@end

@implementation ComplainBusinessCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }

    return self;
}

- (void)makeUI{
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = colorBlack;
    _nameLabel.text = @"经销商名称：";

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"自定义" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateSelected];
    [button setTitleColor:colorLightBlue forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];

    _proTextField = [[UITextField alloc] init];
    _proTextField.font = [UIFont systemFontOfSize:15];
    _proTextField.leftViewMode = UITextFieldViewModeAlways;
    _proTextField.leftView = [self leftLabelWithText:@"省、市"];
    _proTextField.delegate = self;

    _businessTextField = [[UITextField alloc] init];
    _businessTextField = [[UITextField alloc] init];
    _businessTextField.font = [UIFont systemFontOfSize:15];
    _businessTextField.leftViewMode = UITextFieldViewModeAlways;
    _businessTextField.leftView = [self leftLabelWithText:@"经销商"];
    _businessTextField.delegate = self;

    _lineView1 = [[UIView alloc] init];
     _lineView1.backgroundColor = RGB_color(240, 240, 240, 1);

    _lineView2 = [[UIView alloc] init];
     _lineView2.backgroundColor = RGB_color(240, 240, 240, 1);

    _lineView3 = [[UIView alloc] init];
     _lineView3.backgroundColor = RGB_color(240, 240, 240, 1);

    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:button];
    [self.contentView addSubview:_proTextField];
    [self.contentView addSubview:_businessTextField];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_lineView2];
    [self.contentView addSubview:_lineView3];

    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(_nameLabel);
        make.height.equalTo(50);
    }];

    [_lineView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

- (UILabel *)leftLabelWithText:(NSString *)text{
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.textColor = colorBlack;
    leftLabel.text = text;
    leftLabel.frame = CGRectMake(0, 0, 60, 30);
    return leftLabel;
}

- (void)buttonClick{
    button.selected = !button.selected;
    _businessModel.custom = button.selected;
    [self.delegate updateCellHeight];

    [_businessTextField resignFirstResponder];
    [_proTextField resignFirstResponder];
   // [self resettring];
}

- (void)resettring{

    _nameLabel.lh_left = 10;
    _nameLabel.lh_top = 0;
    _nameLabel.lh_size = CGSizeMake(120, 50);

    _lineView1.lh_left = 0;
    _lineView1.lh_size = CGSizeMake(WIDTH, 1);
    _lineView1.lh_top = _nameLabel.lh_bottom;

    if (_businessModel.custom) {
        _lineView2.hidden = YES;
        _proTextField.hidden = YES;

        _businessTextField.lh_left = 20;
        _businessTextField.lh_top = _lineView1.lh_bottom;
        _businessTextField.lh_height = 50;
        _businessTextField.lh_width = self.contentView.frame.size.width - 20;

    }else{

        _lineView2.hidden = NO;
        _proTextField.hidden = NO;

        _proTextField.lh_left = 20;
        _proTextField.lh_top = _lineView1.lh_bottom;
        _proTextField.lh_height = 50;
        _proTextField.lh_width = self.contentView.frame.size.width - 20;


        _lineView2.lh_left = 0;
        _lineView2.lh_top = _proTextField.lh_bottom;
        _lineView2.lh_size = CGSizeMake(WIDTH, 1);

        _businessTextField.lh_left = _proTextField.lh_left;
        _businessTextField.lh_top = _lineView2.lh_bottom;
        _businessTextField.lh_size = _proTextField.lh_size;
    }
}

- (void)setBusinessModel:(ComplainBusinessModel *)businessModel{
    _businessModel = businessModel;

    _proTextField.placeholder = businessModel.proPlaceholder;
    _businessTextField.placeholder = businessModel.businessPlaceholder;
    _proTextField.text = [NSString stringWithFormat:@"%@%@",businessModel.province,businessModel.city];
    _businessTextField.text = businessModel.businessValue;

    [self resettring];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_businessModel.custom) {
        return YES;
    }
    __weak __typeof(self)weakSelf = self;

    if (textField == _proTextField) {
            CityChooseViewController *city = [[CityChooseViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:city];
        [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
            if ([pName isEqualToString:cName]) {
                textField.text = pName;
            }else{
                textField.text = [NSString stringWithFormat:@"%@%@",pName,cName];
            }
            weakSelf.businessModel.pid = pid;
            weakSelf.businessModel.cid = [NSString stringWithFormat:@"%@",cid];
            weakSelf.businessModel.province = pName;
            weakSelf.businessModel.city = cName;
        }];

        [self.parentViewController presentViewController:nvc animated:YES completion:nil];

        return NO;
    }else if (textField == _businessTextField) {
        ChooseViewController *choose = [[ChooseViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:choose];
        nvc.navigationBar.barStyle = UIBarStyleBlack;
        [choose retrunResults:^(NSString *title, NSString *ID) {
            weakSelf.businessModel.businessValue = title;
            _businessTextField.text = title;
            weakSelf.businessModel.businessId = ID;
        }];
        choose.ID = _businessModel.pid;
        choose.cityId = _businessModel.cid;
        choose.seriesId = _businessModel.seriesId;
        choose.choosetype = chooseTypeBusiness;

        [self.parentViewController presentViewController:nvc animated:YES completion:nil];
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
