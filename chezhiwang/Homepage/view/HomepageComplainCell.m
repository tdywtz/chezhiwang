//
//  HomepageComplainCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageComplainCell.h"

@interface CustomShowQuestionView : UIView
{
    CGPoint _point;
}

- (void)setTsbw:(NSArray *)tsbw fwtd:(NSArray *)fwtd;
- (CGFloat)viewHeight;
@end

@implementation CustomShowQuestionView

- (void)setTsbw:(NSArray *)tsbw fwtd:(NSArray *)fwtd{
    _point = CGPointZero;
    [self remoSubviews];
    [self createTsbw:tsbw];
    [self createFwtd:fwtd];
}

- (void)remoSubviews{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

-(void)createTsbw:(NSArray *)array{

    if (array.count == 0) return;

    UIImageView  *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x, _point.y, 20, 20)];
    carImageView.image = [UIImage imageNamed:@"auto_complain_quality"];
    [self addSubview:carImageView];

    _point = CGPointMake(25, _point.y);
    for (int i = 0; i < array.count; i ++) {

        NSDictionary *ceDic = array[i];

        UILabel *label = [self labelWithText:ceDic[@"bw"] backColor:colorPurple borderColor:nil];
        [self upDataPint:label.lh_width];
        label.lh_left = _point.x;
        label.lh_top = _point.y;
        [self addSubview:label];

        _point = CGPointMake(label.lh_right-1, _point.y);

        //
        UILabel *label2 = [self labelWithText:ceDic[@"ques"] backColor:nil borderColor:colorPurple];
        [self upDataPint:label2.lh_width];
        label2.lh_left = _point.x;
        label2.lh_top = _point.y;
        [self addSubview:label2];

        _point = CGPointMake(label2.lh_right+5,_point.y);
    }
}

-(void)createFwtd:(NSArray *)fwtd{

    if (fwtd.count == 0) {
        return;
    }

    if (_point.x+30 > WIDTH) {
        _point = CGPointMake(0, _point.y+25);
    }
    CGFloat x;
    if (_point.x == 0) {
        x = 0;
    }else{
        x = _point.x + 10;
    }

    UIImageView *questionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, _point.y, 20, 20)];
    questionImageView.image = [UIImage imageNamed:@"auto_complain_serve"];
    [self addSubview:questionImageView];
    _point = CGPointMake(questionImageView.lh_right+5, _point.y);

    if (_point.x+70 > WIDTH-20) {
        _point = CGPointMake(10, _point.y+25);
    }

    for (int i = 0; i < fwtd.count; i ++) {
         NSDictionary *dict = fwtd[i];



        UILabel *labelServer = [self labelWithText:dict[@"bw"] backColor:colorGreen borderColor:nil];
        [self upDataPint:labelServer.lh_width];
        labelServer.lh_left = _point.x;
        labelServer.lh_top = _point.y;
        [self addSubview:labelServer];



        if ([dict[@"ques"] length]) {
            _point = CGPointMake(labelServer.lh_right-1, labelServer.lh_top);

            UILabel *label2 = [self labelWithText:dict[@"ques"] backColor:nil borderColor:colorGreen];
            [self upDataPint:label2.lh_width];
            label2.lh_left = _point.x;
            label2.lh_top = _point.y;
            [self addSubview:label2];

            _point = CGPointMake(label2.lh_right+5,_point.y);

        }else{
            _point = CGPointMake(labelServer.lh_right+5, labelServer.lh_top);
        }
    }
}

- (UILabel *)labelWithText:(NSString *)text backColor:(UIColor *)backColor borderColor:(UIColor *)borderColor{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];
    if (backColor) {
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = backColor;
    }else{
        label.textColor = borderColor;
        label.layer.borderColor = borderColor.CGColor;
        label.layer.borderWidth = 1;
    }
    [label sizeToFit];
    label.lh_width += 10;
    label.lh_height += 5;
    return label;
}

#pragma mark - 计算坐标
-(void)upDataPint:(CGFloat)length{
    if (length+_point.x > WIDTH-30) {
        _point = CGPointMake(0, _point.y+25);
    }
}

- (CGFloat)viewHeight{
    if (_point.x == 0) {
        return _point.y-5;
    }
    return _point.y+20;
}
@end

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
@implementation HomepageComplainCell
{
    UILabel *titleLabel;
    UILabel *cpidLabel;
    UILabel *dateLabel;
    UILabel *brandNameLabel;
    UILabel *seriesNameLabel;
    UILabel *modelNameLabel;

    CustomShowQuestionView *showView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
    titleLabel.textColor = colorBlack;
    titleLabel.numberOfLines = 1;
    

    cpidLabel = [[UILabel alloc] init];
    cpidLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    cpidLabel.textColor = colorBlack;

    UIImageView *cpidImageView = [[UIImageView alloc] init];
    cpidImageView.image = [UIImage imageNamed:@"auto_complain_cpid"];


    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = colorLightGray;

    brandNameLabel = [[UILabel alloc] init];
    brandNameLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    brandNameLabel.textColor = colorBlack;

    seriesNameLabel = [[UILabel alloc] init];
    seriesNameLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    seriesNameLabel.textColor = colorBlack;

    modelNameLabel = [[UILabel alloc] init];
    modelNameLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    modelNameLabel.textColor = colorBlack;

    showView = [[CustomShowQuestionView alloc] initWithFrame:CGRectZero];

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:cpidImageView];
    [self.contentView addSubview:cpidLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:brandNameLabel];
    [self.contentView addSubview:seriesNameLabel];
    [self.contentView addSubview:modelNameLabel];
    [self.contentView addSubview:showView];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];

    [cpidImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.size.equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(cpidLabel);
    }];

    [cpidLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cpidImageView.right).offset(5);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];

    [brandNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(cpidLabel.bottom).offset(10);
        make.width.equalTo(WIDTH/3);
    }];

    [seriesNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(brandNameLabel.right).offset(5);
        make.top.equalTo(brandNameLabel);
    }];

    [modelNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brandNameLabel.bottom).offset(10);
        make.left.equalTo(10);
    }];

    [showView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(modelNameLabel.bottom).offset(10);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(showView.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];
}

- (void)setComplainModel:(HomepageComplainModel *)complainModel{
    
    _complainModel = complainModel;

    [self setData];
}

- (void)setData{
    titleLabel.text = self.complainModel.question;

    NSMutableAttributedString *matt = [self attributedWithString1:@"编号：" string2:self.complainModel.cpid];
    [matt addAttribute:NSKernAttributeName value:@(-3.2) range:NSMakeRange(2, 1)];
    cpidLabel.attributedText = matt;

    dateLabel.text = self.complainModel.date;

    brandNameLabel.attributedText = [self attributedWithString1:@"品牌:" string2:[NSString stringWithFormat:@"【%@】",self.complainModel.brandname]];
    seriesNameLabel.attributedText = [self attributedWithString1:@"车系:" string2:[NSString stringWithFormat:@"【%@】",self.complainModel.seriesname]];
    modelNameLabel.attributedText = [self attributedWithString1:@"车型:" string2:[NSString stringWithFormat:@"【%@】",self.complainModel.modelsname]];

    [showView setTsbw:self.complainModel.tsbw fwtd:self.complainModel.tsfw];
    CGFloat height = [showView viewHeight];
    [showView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}

- (NSMutableAttributedString *)attributedWithString1:(NSString *)string1 string2:(NSString *)string2{
    if (string2 == nil) {
        string2 = @"";
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string1 attributes:@{NSForegroundColorAttributeName:RGB_color(153, 153, 153, 1)}];
    [att appendAttributedString:[[NSAttributedString alloc] initWithString:string2]];

    return att;
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
