//
//  ComplainDetailsView.m
//  chezhiwang
//
//  Created by bangong on 16/12/6.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainDetailsView.h"
#import "MyComplainDetailsViewController.h"

@interface ShowStarView : UIView

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger star;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,copy) void (^submitStar)(NSInteger star);

@end

@implementation ShowStarView
{
    UIButton *submitButton;
    UILabel *gratifiedLabel;//满意度
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(WIDTH, HEIGHT);
    self = [super initWithFrame:frame];

    if (self) {
        CGRect tempRect;
        for (int i = 0; i < 5; i ++) {
            CGRect rect = CGRectMake(35+i*30, 0 , 25, 25);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = rect;
            [btn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:btn];
            [self addSubview:btn];

            tempRect = rect;
        }

        gratifiedLabel = [[UILabel alloc] init];
        gratifiedLabel.font = [UIFont systemFontOfSize:13];
        gratifiedLabel.textColor = colorBlack;

        submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        submitButton.lh_size = CGSizeMake(40, 80);
        [submitButton setTitle:@"提交评分" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitButton.backgroundColor = colorYellow;
        [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:gratifiedLabel];
        [self addSubview:submitButton];

        gratifiedLabel.lh_size = CGSizeMake(60, 20);
        gratifiedLabel.lh_left = tempRect.origin.x + tempRect.size.width + 20;
        gratifiedLabel.lh_centerY = tempRect.origin.y + tempRect.size.height/2;
    }
    return self;
}

- (void)btnClick:(UIButton *)btn{

    [self setStar:[_buttons indexOfObject:btn]+1];
}

- (void)submitClick{
    if (self.submitStar) {
        self.submitStar(_star);
    }
}

- (void)upateLayout{

    if (!_isSelected) {
        submitButton.hidden = YES;
        self.lh_height = gratifiedLabel.lh_bottom + 30;
    }else{
        submitButton.hidden = NO;
        submitButton.lh_size = CGSizeMake(100, 30);
        submitButton.lh_top = gratifiedLabel.lh_bottom + 20;
        submitButton.lh_centerX = self.lh_centerX;

        self.lh_height = submitButton.lh_bottom + 20;
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;

    for (int i = 0; i < _buttons.count; i ++) {
        UIButton *btn = _buttons[i];
        btn.enabled = isSelected;
    }
    [self upateLayout];
}

- (void)setStar:(NSInteger)star{
    _star = star;
    if (star <= _buttons.count && star > 0) {
       NSArray *titles =  @[@"不满意",@"一般",@"较好",@"满意",@"非常满意"];
        gratifiedLabel.text = titles[star  - 1];
    }

    for (int i = 0; i < _buttons.count; i ++) {
        UIButton *btn = _buttons[i];
        if (i < star) {
           [btn setBackgroundImage:[UIImage imageNamed:@"stary"] forState:UIControlStateNormal];
        }else{
           [btn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        }
    }

    [self upateLayout];
}

- (NSMutableArray *)buttons{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
@end

#pragma mark - ComplainPromptView
@implementation ComplainPromptView
{
    UIImageView *answerImageView;//回复
    UIImageView *gratifiedImageView;//满意度

    UILabel *answerTitleLabel;
    UILabel *gratifiedTitleLabel;

    UIView *lineView;
    UILabel *answerLabel;
    UILabel *gratifiedLabel;
    ShowStarView *showView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(WIDTH, HEIGHT);
    self = [super initWithFrame:frame];

    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
        line.backgroundColor = RGB_color(240, 240, 240, 1);

        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        lineView.backgroundColor = RGB_color(240, 240, 240, 1);


        answerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_answerDetail_answer"]];
        answerImageView.contentMode = UIViewContentModeScaleAspectFit;

        gratifiedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_complainDetails_gratified"]];
        gratifiedImageView.contentMode = UIViewContentModeScaleAspectFit;

        answerTitleLabel  = [[UILabel alloc] init];
        answerTitleLabel.font = [UIFont systemFontOfSize:15];
        answerTitleLabel.textColor = colorDeepGray;
        answerTitleLabel.text = @"厂家回复";

        gratifiedTitleLabel  = [[UILabel alloc] init];
        gratifiedTitleLabel.font = [UIFont systemFontOfSize:15];
        gratifiedTitleLabel.textColor = colorDeepGray;
        gratifiedTitleLabel.text = @"满意度评分";

        answerLabel  = [[UILabel alloc] init];
        answerLabel.font = [UIFont systemFontOfSize:15];
        answerLabel.textColor = colorBlack;
        answerLabel.numberOfLines = 0;

        gratifiedLabel  = [[UILabel alloc] init];
        gratifiedLabel.font = [UIFont systemFontOfSize:15];
        gratifiedLabel.textColor = colorBlack;
        gratifiedLabel.hidden = YES;

        showView = [[ShowStarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        showView.hidden = YES;
        __weak __typeof(self)weakSelf = self;
        showView.submitStar = ^(NSInteger star){
            [weakSelf.perentViewController submitStar:star];
        };

        [self addSubview:line];
        [self addSubview:lineView];
        [self addSubview:answerImageView];
        [self addSubview:gratifiedImageView];
        [self addSubview:answerTitleLabel];
        [self addSubview:gratifiedTitleLabel];
        [self addSubview:answerLabel];
        [self addSubview:gratifiedLabel];
        [self addSubview:showView];

    }
    return self;
}

- (void)updateLayout{
    answerImageView.lh_left = 10;
    answerImageView.lh_top = 20;
    answerImageView.lh_size = CGSizeMake(18, 18);

    [answerTitleLabel sizeToFit];
    answerTitleLabel.lh_left = answerImageView.lh_right + 10;
    answerTitleLabel.lh_centerY = answerImageView.lh_centerY;

    answerLabel.lh_width = WIDTH - 10 - answerTitleLabel.lh_left;
    [answerLabel sizeToFit];
    answerLabel.lh_left = answerTitleLabel.lh_left;
    answerLabel.lh_top = answerTitleLabel.lh_bottom + 10;

    lineView.lh_top = answerLabel.lh_bottom + 10;

    gratifiedImageView.lh_left = answerImageView.lh_left;
    gratifiedImageView.lh_size = answerImageView.lh_size;
    gratifiedImageView.lh_top = lineView.lh_bottom + 10;

    [gratifiedTitleLabel sizeToFit];
    gratifiedTitleLabel.lh_left = gratifiedImageView.lh_right + 10;
    gratifiedTitleLabel.lh_centerY = gratifiedImageView.lh_centerY;



    if (showView.hidden) {
        gratifiedLabel.hidden = NO;
        gratifiedLabel.lh_left = gratifiedTitleLabel.lh_left;
        gratifiedLabel.lh_top = gratifiedTitleLabel.lh_bottom + 10;
        [gratifiedLabel sizeToFit];

        self.lh_height = gratifiedLabel.lh_bottom + 15;
    }else{
        gratifiedLabel.hidden = YES;
        showView.lh_left = 0;
        showView.lh_top = gratifiedTitleLabel.lh_bottom + 10;

        self.lh_height = showView.lh_bottom + 15;
    }

}

- (void)setModel:(MyComplainModel *)model{
    _model = model;

    NSString *huifu = model.huifu.length?model.huifu:@"对不起，该投诉还未进行到此步";
    NSMutableAttributedString *huifuAtt = [[NSMutableAttributedString alloc] initWithString:huifu];

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //huifuAtt.lh_font = [UIFont systemFontOfSize:15];
    [huifuAtt addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, huifuAtt.length)];
    answerLabel.attributedText = huifuAtt;


    showView.hidden = NO;
    if ([_model.stepid integerValue] < 4) {
        if (!model.ispf) {
            gratifiedLabel.text = @"对不起，该投诉还未进行到此步";
            showView.hidden = YES;
        }else{
            showView.isSelected = YES;

        }

    }else if([_model.stepid integerValue] == 4){
        showView.isSelected = YES;

    }else if([_model.stepid integerValue] == 5){
        showView.isSelected = NO;
        showView.star = [model.stars integerValue];
    }


    [self updateLayout];
}


@end


#pragma mark - ComplainDetailsView

@interface MyComplainSectionView : UIView

@property (nonatomic,strong)  UIImageView *imageView;
@property (nonatomic,strong)  UILabel *nameLabel;

@end

@implementation MyComplainSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB_color(240, 240, 240, 1);

        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = colorBlack;

        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = RGB_color(240, 240, 240, 1);

        [self addSubview:lineView];
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        [self addSubview:lineView2];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.height.equalTo(10);
        }];

        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.size.equalTo(CGSizeMake(18, 18));
            make.bottom.equalTo(-10);

        }];

        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.right).offset(10);
            make.centerY.equalTo(_imageView);
        }];

        [lineView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];

    }
    return self;
}

@end

//////
@implementation ComplainDetailsView
{
    MyComplainSectionView *sectionView1;
    MyComplainSectionView *sectionView2;
    MyComplainSectionView *sectionView3;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        sectionView1 = [[MyComplainSectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        sectionView1.imageView.image = [UIImage imageNamed:@"tss_07.gif"];
        sectionView1.nameLabel.text = @"车主信息";

        sectionView2 = [[MyComplainSectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        sectionView2.imageView.image = [UIImage imageNamed:@"tss_13.gif"];
        sectionView2.nameLabel.text = @"车辆信息";

        sectionView3 = [[MyComplainSectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        sectionView3.imageView.image = [UIImage imageNamed:@"tss_10.gif"];
        sectionView3.nameLabel.text = @"投诉类型";


        [self addSubview:sectionView1];
        [self addSubview:sectionView2];
        [self addSubview:sectionView3];
    }
    return self;
}

- (void)setDetailsDict:(NSDictionary *)detailsDict{

    for (UIView *view in self.subviews) {
        if (view != sectionView1 && view != sectionView2 && view != sectionView3) {
            [view removeFromSuperview];
        }
    }
    NSArray *arr1 = @[@"uname",@"age",@"sex",@"mobile",@"email",@"phone",@"address",@"occ"];
    NSArray *arr2 = @[@"brand",@"series",@"model",@"engine",@"carriage",@"sign",@"buytime",@"lname",@"issuetime",@"mileage"];
    NSArray *arr3 = @[@"type",@"attribute",@"question",@"content"];


    NSArray *noeArray = @[@"姓名：",@"年龄：",@"性别：",@"移动电话：",@"电子邮箱：",@"固定电话：",@"通讯地址：",@"车主职业："];
    NSArray *twoArray = @[@"投诉品牌:",@"车系:",@"车型:",@"发动机号:",@"车架号:",@"车牌号:",@"购车日期:",@"问题日期:",@"已行驶里程(km):",@"经销商名称:"];
    NSArray *threeArray = @[@"投诉类型:",@"投诉属性:",@"问题描述:",@"投诉详情:"];

    CGRect tempRect = sectionView1.frame;
    for (int i = 0; i < arr1.count; i ++) {

        UILabel *label = [self labelWithName:noeArray[i] content:detailsDict[arr1[i]]];
        [self addSubview:label];

        [self addSubview:label];
        label.lh_left = 10;
        label.lh_top = tempRect.origin.y + tempRect.size.height + 15;

       tempRect = [self addLineWith:label.frame];
    }


    sectionView2.lh_left = 0;
    sectionView2.lh_top = tempRect.origin.y  + tempRect.size.height;

    tempRect = sectionView2.frame;

    for (int i = 0; i < arr2.count; i ++) {

        UILabel *label = [self labelWithName:twoArray[i] content:detailsDict[arr2[i]]];
        [self addSubview:label];

        [self addSubview:label];
        label.lh_left = 10;
        label.lh_top = tempRect.origin.y + tempRect.size.height + 15;

        tempRect = [self addLineWith:label.frame];
    }


    sectionView3.lh_left = 0;
    sectionView3.lh_top = tempRect.origin.y  + tempRect.size.height;

    tempRect = sectionView3.frame;

    for (int i = 0; i < arr3.count; i ++) {
        NSString *name = threeArray[i];
        NSString *content = detailsDict[arr3[i]];
        if (i >= 2) {
            content = [NSString stringWithFormat:@"\n%@",content?content:@""];
        }
        UILabel *label = [self labelWithName:name content:content];
        [self addSubview:label];

        label.lh_left = 10;
        label.lh_top = tempRect.origin.y + tempRect.size.height + 15;
        if (i >= 2) {
            tempRect = [self addLineWith:CGRectMake(0, label.lh_bottom+15, WIDTH, 0)];
        }else{
            tempRect = [self addLineWith:label.frame];
        }

    }

    self.lh_height = tempRect.origin.y + tempRect.size.height;

}

- (CGRect)addLineWith:(CGRect)tempRect{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB_color(240, 240, 240, 1);
    [self addSubview:view];

    view.lh_left = 0;
    view.lh_top = tempRect.origin.y + tempRect.size.height;
    view.lh_size = CGSizeMake(WIDTH, 1);

    return view.frame;
}

- (UILabel *)labelWithName:(NSString *)name content:(NSString *)contet{

    UILabel *label = [[UILabel alloc] init];
    label.lh_width = WIDTH - 20;
    label.numberOfLines = 0;
    label.attributedText = [self attributeWithName:name content:contet];
    [label sizeToFit];

    return  label;
}

- (NSAttributedString *)attributeWithName:(NSString *)name content:(NSString *)contet{
    if (contet == nil) {
        contet = @"";
    }
    name = [NSString stringWithFormat:@"%@   ",name];

    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:name];
    attribute.lh_font = [UIFont systemFontOfSize:15];
    attribute.lh_color = colorBlack;

    NSAttributedString *att = [[NSAttributedString alloc] initWithString:contet attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:colorDeepGray}];

    [attribute appendAttributedString:att];
    attribute.lh_lineSpacing = 15;


    return attribute;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
