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

        NSString *str1 = ceDic[@"bw"];
        CGFloat length1 = [self getStr:str1 andFont:PT_FROM_PX(16)];
        [self upDataPint:length1];


        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_point.x, _point.y, length1+20, 20)];
        label.text = str1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = colorPurple;
        label.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];

        [self addSubview:label];
        _point = CGPointMake(label.frame.size.width+label.frame.origin.x-1, _point.y);

        //
        NSString *str2 = ceDic[@"ques"];
        CGFloat length2 = [self getStr:str2 andFont:PT_FROM_PX(16)];
        [self upDataPint:length2];


        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_point.x, _point.y, length2+20, 20)];
        label2.text = str2;
        label2.textColor = colorPurple;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];
        label2.layer.borderColor = colorPurple.CGColor;
        label2.layer.borderWidth = 1;

        [self addSubview:label2];

        _point = CGPointMake(label2.frame.size.width+label2.frame.origin.x+5,_point.y);
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
    _point = CGPointMake(questionImageView.frame.origin.x+questionImageView.frame.size.width+5, _point.y);

    if (_point.x+70 > WIDTH-20) {
        _point = CGPointMake(10, _point.y+25);
    }

    for (int i = 0; i < fwtd.count; i ++) {
         NSDictionary *dict = fwtd[i];

        CGFloat w = [self getStr:dict[@"bw"] andFont:PT_FROM_PX(16)];
        [self upDataPint:w];



        UILabel *labelServer = [LHController createLabelWithFrame:CGRectMake(_point.x, _point.y, w+20, 20) Font:PT_FROM_PX(16) Bold:NO TextColor:nil Text:dict[@"bw"]];
        labelServer.textColor = [UIColor whiteColor];
        labelServer.backgroundColor = colorGreen;
        labelServer.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelServer];



        if ([dict[@"ques"] length]) {
            _point = CGPointMake(labelServer.lh_left+labelServer.lh_width-1, labelServer.frame.origin.y);

            NSString *str2 = dict[@"ques"];
            CGFloat length2 = [self getStr:str2 andFont:PT_FROM_PX(16)];
            [self upDataPint:length2];


            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_point.x, _point.y, length2+20, 20)];
            label2.text = str2;
            label2.textColor = colorGreen;
            label2.textAlignment = NSTextAlignmentCenter;
            label2.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];
            label2.layer.borderColor = colorGreen.CGColor;
            label2.layer.borderWidth = 1;

            [self addSubview:label2];

            _point = CGPointMake(label2.frame.size.width+label2.frame.origin.x+5,_point.y);

        }else{
            _point = CGPointMake(labelServer.frame.origin.x+labelServer.frame.size.width+5, labelServer.frame.origin.y);
        }
    }
}

#pragma mark - 计算字符串长度
-(CGFloat)getStr:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
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
    cpidLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
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

    NSMutableAttributedString *matt = [self attributedWithString1:@"编号：" string2:[NSString stringWithFormat:@"【%@】",self.complainModel.cpid]];
    [matt addAttribute:NSKernAttributeName value:@(-3.2) range:NSMakeRange(2, 1)];
    cpidLabel.attributedText = matt;

    dateLabel.text = self.complainModel.date;
    brandNameLabel.attributedText = [self attributedWithString1:@"品牌：" string2:self.complainModel.brandname];
    seriesNameLabel.attributedText = [self attributedWithString1:@"车系：" string2:self.complainModel.seriesname];
    modelNameLabel.attributedText = [self attributedWithString1:@"车型：" string2:self.complainModel.modelsname];

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
