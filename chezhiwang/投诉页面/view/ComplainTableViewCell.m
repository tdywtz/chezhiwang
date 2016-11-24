//
//  ComplainTableViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainTableViewCell.h"
#import "ComplainSectionModel.h"
#import "LHPickerView.h"
#import "ChooseSexViewController.h"
#import "ChooseDateViewController.h"

#pragma mark - 车牌号
@implementation ComplainLicenseplateCell
{
    UIButton *proButton;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }

    return self;
}

- (void)makeUI{

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = colorBlack;
    _nameLabel.font = [UIFont systemFontOfSize:15];

    proButton = [UIButton buttonWithType:UIButtonTypeCustom];
    proButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [proButton setTitle:@"京" forState:UIControlStateNormal];
    [proButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [proButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [proButton addTarget:self action:@selector(proClick) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *proImageView = [[UIImageView alloc] init];
    proImageView.contentMode = UIViewContentModeScaleAspectFit;
    proImageView.image = [UIImage imageNamed:@"xuanze"];

    [proButton addSubview:proImageView];
    [proImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(proButton.right);
        make.centerY.equalTo(0);
        make.width.equalTo(15);
    }];

    _textField = [[UITextField alloc] init];
    _textField.textColor = colorBlack;
    _textField.font = [UIFont systemFontOfSize:15];

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB_color(240, 240, 240, 1);

    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:proButton];
    [self.contentView addSubview:_textField];
    [self.contentView addSubview:_lineView];


    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
        make.width.equalTo(60);
    }];

    [proButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.right);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(40, 50));
    }];

    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(proButton.right).offset(20);
        make.top.bottom.equalTo(0);
        make.right.equalTo(-10);
    }];
    
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)proClick{
    [self.parentViewController.view endEditing:YES];
    ChooseSexViewController *picker = [[ChooseSexViewController alloc] init];
    picker.titleText = @"省份简称";
    [picker showPickerView];
    __weak __typeof(self)weakSelf = self;
    [picker returnResult:^(NSString *title, NSString *ID) {
        [proButton setTitle:title forState:UIControlStateNormal];
        weakSelf.model.value = [NSString stringWithFormat:@"%@^%@",title,weakSelf.textField.text];
    }];
    [self.parentViewController presentViewController:picker animated:YES completion:nil];

    [HttpRequest GET:[URLFile urlStringForPro] success:^(id responseObject) {
        if ([responseObject count] > 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject[@"rel"]) {
                NSString *title = [dict[@"license_plate"] length] > 0?dict[@"license_plate"]:@"台";
                [array
                 addObject:@{@"id":dict[@"id"],@"title":title,@"name":dict[@"name"]}];
            }
            picker.dataArray = array;
        }

    } failure:^(NSError *error) {

    }];
}

- (void)textChange:(NSNotification *)notification{
    _model.value = [NSString stringWithFormat:@"%@^%@",proButton.titleLabel.text,_textField.text];
}



- (void)setModel:(ComplainModel *)model{
    _model = model;

    _nameLabel.text = model.name;
    _textField.placeholder = model.placeholder;

    NSArray *textArray = [model.value componentsSeparatedByString:@"^"];
    if (textArray.count == 2) {
        [proButton setTitle:textArray[0] forState:UIControlStateNormal];
         _textField.text = textArray[1];
    }

}


@end

#pragma mark - cell
@interface ComplainTableViewCell ()<UITextFieldDelegate>
{
    UIImageView *rightImageView;
}
@end

@implementation ComplainTableViewCell
- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }

    return self;
}

- (void)makeUI{

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = colorBlack;
    _nameLabel.font = [UIFont systemFontOfSize:15];


    _textField = [[UITextField alloc] init];
    _textField.textColor = colorBlack;
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.keyboardType = UIKeyboardTypeEmailAddress;
    _textField.delegate = self;

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB_color(240, 240, 240, 1);

    rightImageView = [[UIImageView alloc] init];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.image = [UIImage imageNamed:@"arrow"];

    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_textField];
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:rightImageView];


    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];

    [rightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(20, 20));
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChange:(NSNotification *)notification{
    _model.value = _textField.text;
}

- (void)resetting{
    _nameLabel.text = _model.name;
    _textField.placeholder = _model.placeholder;
    _textField.text = _model.value;

    if (_model.style == ComplainCellStyleSex || _model.style == ComplainCellStyleBeginDate || _model.style == ComplainCellStyleEndDate) {
        rightImageView.hidden = NO;
    }else{
        rightImageView.hidden = YES;
    }

    [_nameLabel sizeToFit];
    _nameLabel.lh_left = 10;
    _nameLabel.lh_centerY = self.contentView.lh_centerY+2;

    _textField.lh_left = _nameLabel.lh_right+10;
    _textField.lh_height = _model.cellHeight;
    _textField.lh_width = WIDTH - _nameLabel.lh_right-10;
    _textField.lh_centerY = _nameLabel.lh_centerY;

}
- (void)setModel:(ComplainModel *)model{
    _model = model;

    [self resetting];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{


    [textField resignFirstResponder];
     __weak __typeof(self)weakSelf = self;

    if (_model.style == ComplainCellStyleAge) {
        return YES;
    }else if (_model.style == ComplainCellStyleSex){
        NSDictionary *dict1 = @{@"title":@"男",@"id":@"1"};
        NSDictionary *dict2 = @{@"title":@"女",@"id":@"2"};
        NSArray *array = @[dict1,dict2];
        ChooseSexViewController *picker = [[ChooseSexViewController alloc] init];
        picker.dataArray = array;
        picker.titleText = @"性别";
        [picker showPickerView];

        [picker returnResult:^(NSString *title, NSString *ID) {
            textField.text = title;
            weakSelf.model.value = title;
        }];
        [self.parentViewController presentViewController:picker animated:YES completion:nil];
        return NO;
    }else if ( _model.style == ComplainCellStyleBeginDate){
        ChooseDateViewController *chooseDate = [[ChooseDateViewController alloc] init];
        chooseDate.minimumDate = @"2000-01-01";
        if (self.sectionModel.endDate.length > 1) {
            chooseDate.maximumDate = self.sectionModel.endDate;
        }else{
            chooseDate.maximumDate = [self nowDate];
        }
        chooseDate.titleText = @"购车日期";

        [chooseDate returnDate:^(NSString *date) {
            weakSelf.model.value = date;
            weakSelf.sectionModel.beginDate = date;
            [weakSelf resetting];
        }];
        [self.parentViewController presentViewController:chooseDate animated:YES completion:nil];
        return NO;
    }
    else if (_model.style == ComplainCellStyleEndDate){
        ChooseDateViewController *chooseDate = [[ChooseDateViewController alloc] init];
        chooseDate.maximumDate = [self nowDate];
        if (self.sectionModel.beginDate.length > 1) {
            chooseDate.minimumDate = self.sectionModel.beginDate;
        }else{
           chooseDate.minimumDate = @"2000-01-01";
        }
        [chooseDate returnDate:^(NSString *date) {
            weakSelf.model.value = date;
            weakSelf.sectionModel.endDate = date;
            [weakSelf resetting];
        }];
        [self.parentViewController presentViewController:chooseDate animated:YES completion:nil];
        return NO;
    }

    return YES;
}

- (NSString *)nowDate{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
