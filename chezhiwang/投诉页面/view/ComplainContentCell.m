//
//  ComplainContentCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainContentCell.h"
#import "CZWIMInputTextView.h"
#import "ComplainSectionModel.h"

@implementation ComplainContentCell
{
    UILabel *nameLabel;
    UITextField *describeTextField;
    CZWIMInputTextView *contentTextView;
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
    nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = colorBlack;
    nameLabel.font = [UIFont systemFontOfSize:15];

    describeTextField = [[UITextField alloc] init];
    describeTextField.textColor = colorBlack;
    describeTextField.font = [UIFont systemFontOfSize:15];

    contentTextView = [[CZWIMInputTextView alloc] initWithFrame:CGRectZero];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_color(240, 240, 240, 1);


    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:describeTextField];
    [self.contentView addSubview:contentTextView];
    [self.contentView addSubview:lineView];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];

    [contentTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(4);
        make.right.equalTo(0);
        make.bottom.equalTo(-5);
        make.height.equalTo(60);
    }];
}

- (void)textFiedChange:(NSNotification *)notification{
    _model.value = describeTextField.text;
}

- (void)textViewDidChangeNotification:(NSNotification *)notification{
    _model.value = contentTextView.text;
}

- (void)resetting{
    nameLabel.lh_left = 10;
    nameLabel.lh_top = 10;
    nameLabel.lh_size = CGSizeMake(100, 20);

     nameLabel.text = _model.name;

      [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    if (_model.desOrDetail == 0) {
        describeTextField.text = _model.value;
        contentTextView.hidden = YES;
        describeTextField.hidden = NO;

        describeTextField.lh_left = 10;
        describeTextField.lh_top = nameLabel.lh_bottom;
        describeTextField.lh_size = CGSizeMake(WIDTH-20, 50);

        describeTextField.placeholder = _model.placeholder;
        describeTextField.text = _model.value;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiedChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }else{
        contentTextView.text = _model.value;
        contentTextView.hidden = NO;
        describeTextField.hidden = YES;

        contentTextView.placeHolder = _model.placeholder;
        contentTextView.text = _model.value;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
}

- (void)setModel:(ComplainModel *)model{
    _model = model;

    [self resetting];
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
