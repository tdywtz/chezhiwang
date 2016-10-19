//
//  NewsTestTableViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestTableViewCell.h"
#import "ImageShowViewController.h"

#pragma mark - 精品试驾cell右侧展示视图文字展示框
@implementation TestLabel

-(void)setDraw_x:(CGFloat)draw_x{
    if (_draw_x != draw_x) {
        _draw_x = draw_x;
        // [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    rect.size.height -= 6;
    rect.size.width -= 4;
    //框
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //    CGContextTranslateCTM(context, -self.textInsets.left, rect.size.height+self.textInsets.top);
    //  CGContextScaleCTM(context, 1.0, -1.0);

    //CGContextSetRGBStrokeColor(context, 255/255.0,  147/255.0, 4/255.0, 1);//线条颜色
    CGContextSetStrokeColorWithColor(context, RGB_color(231, 212, 183, 1).CGColor);
    //CGContextSetRGBFillColor(context, 0.2, 0.3, 0.8, 0.5);
    //CGContextMoveToPoint(context, 1, 10);
    CGContextMoveToPoint(context, self.draw_x-5, 10);
    CGContextAddLineToPoint(context, self.draw_x, 5);
    CGContextAddLineToPoint(context, self.draw_x+5, 10);
    CGContextAddArcToPoint(context, rect.size.width-1, 10, rect.size.width-1, rect.size.height-1, self.cornerRadius);
    CGContextAddArcToPoint(context, rect.size.width-1, rect.size.height-1, 1, rect.size.height-1, self.cornerRadius);
    CGContextAddArcToPoint(context, 1, rect.size.height-1, 1, 10, self.cornerRadius);
    CGContextAddArcToPoint(context, 1, 10, self.draw_x-5, 10, self.cornerRadius);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);

    //三角
    CGContextRef jiantou = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(jiantou, 220/255.0,  220/255.0, 220/255.0, 1);//线条颜色
    CGFloat tox = rect.size.width-self.textInsets.right+10;
    CGFloat cy = rect.size.height/2+5;
    CGContextMoveToPoint(jiantou, tox, cy-8);
    CGContextAddLineToPoint(jiantou, tox+7, cy);
    CGContextAddLineToPoint(jiantou, tox, cy+8);
    CGContextStrokePath(jiantou);
}
@end

#pragma mark - 精品试驾cell右侧展示视图上自定义button
@implementation TestCustonBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetWidth(frame))];
        _customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height-17, frame.size.width, 17)];
        _customTitleLabel.font = [UIFont systemFontOfSize:15];
        _customTitleLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_customImageView];
        [self addSubview:_customTitleLabel];
    }

    return self;
}

//设置选中view的背景颜色和标题颜色
- (void)setCustomBarTitleColor:(UIColor *)color{
    _customTitleLabel.textColor = [UIColor colorWithCGColor:color.CGColor];
    //_customImageView.backgroundColor = [UIColor colorWithCGColor:color.CGColor];
}
@end

#pragma mark - 精品试驾cell右侧展示视图
@implementation TestCellIntroduceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        _buttons = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"外观",@"内饰",@"性能",@"空间",@"安全"];
        CGFloat btnWidth = 35;
        if (WIDTH > 330 ) {
            btnWidth = 40;
        }
        CGFloat space = (WIDTH-130-btnWidth*titles.count)/(titles.count-1);
        for (int i = 0; i < titles.count; i ++) {
            TestCustonBtn *btn = [[TestCustonBtn alloc] initWithFrame:CGRectMake((btnWidth+space)*i, 0, btnWidth, btnWidth+21)];
            btn.customTitleLabel.text = titles[i];
            [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_buttons addObject:btn];
            if (i == 0) {
                //设置选中颜色
                [btn setCustomBarTitleColor:colorYellow];
            }else{
                //未选中颜色
                [btn setCustomBarTitleColor:colorLightBlue];
            }
        }

        TestCustonBtn *btn = _buttons[0];
        _contentLabel = [[TestLabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-btn.frame.size.height)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.cornerRadius = 2;
        _contentLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 2;
        _contentLabel.textAlignment = kCTTextAlignmentJustified;
        _contentLabel.textInsets = UIEdgeInsetsMake(15, 5, 5, 25);
        _contentLabel.draw_x = btnWidth/2;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = colorLightGray;
        _contentLabel.lineSpacing = 1;
        _contentLabel.userInteractionEnabled = NO;
        //_contentLabel.firstLineHeadIndent = 20;
        [self addSubview:_contentLabel];
        // _contentLabel.backgroundColor = [UIColor redColor];
    }

    return self;
}

-(void)titleClick:(TestCustonBtn *)btn{
    if (btn.gray) {
        return;
    }
    _contentLabel.draw_x = btn.center.x;

    NSInteger index = [self.buttons indexOfObject:btn];
    _model.descCurrent = index;
    if (index < self.buttons.count) {
        _contentLabel.text = _descArray[index][@"font"];//描述内容
    }else{
        _contentLabel.text = @"";
    }

    NSArray *imageNames   = @[@"pc_wg",@"pc_ns",@"pc_xn",@"pc_kj",@"pc_aq"];
    NSArray *imageNames_h = @[@"pc_wg_h",@"pc_ns_h",@"pc_xn_h",@"pc_kj_h",@"pc_aq_h"];

    for (int i = 0; i < self.buttons.count; i ++) {
        TestCustonBtn *testBtn = self.buttons[i];
        testBtn.gray = NO;
        if ([testBtn isEqual:btn]) {

            [testBtn setCustomBarTitleColor:RGB_color(218, 165, 101, 1)];
            testBtn.customImageView.image = [UIImage imageNamed:imageNames_h[i]];

        }else{
            [testBtn setCustomBarTitleColor:RGB_color(102, 160, 178, 1)];
            testBtn.customImageView.image = [UIImage imageNamed:imageNames[i]];
        }
    }
    [self setGray];
}

- (void)setDescArray:(NSArray *)descArray{
    _descArray = descArray;
    [self titleClick:self.buttons[_model.descCurrent]];
}

- (void)setModel:(NewsTestTableViewModel *)model{
    _model = model;
}

- (void)setGray{
    NSInteger index = [_model.gray integerValue];
    index--;

    if (index > 0 && index < 5) {
        TestCustonBtn *btn = self.buttons[index];
        btn.gray = YES;
        NSArray *imageNames_g = @[@"pc_wg_g",@"pc_ns_g",@"pc_xn_g",@"pc_kj_g",@"pc_aq_g"];
        btn.customTitleLabel.textColor = colorLineGray;
        btn.customImageView.image = [UIImage imageNamed:imageNames_g[index]];
    }
}
@end

#pragma mark - 实拍图片
@interface TimeShowImageView : UIView

@property (nonatomic,copy) void(^block)(NSInteger index, NSArray *urlArray);
@property (nonatomic,strong) NSArray *urlArray;
- (void)setImageWithUrl:(NSArray <NSString *>*)urlArray;
@end

@implementation TimeShowImageView
{
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UIImageView *imageViewFour;
}

- (instancetype)init{
    if (self = [super init]) {
        CGFloat width = 80*(WIDTH/375);
        CGFloat height = 55*(WIDTH/375);
        CGFloat space = (WIDTH-20 -width*4)/3;
        NSArray *array = @[@"imageViewOne",@"imageViewTwo",@"imageViewThree",@"imageViewFour"];
        UIImageView *temp = nil;
        for (int i =  0; i < 4; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = 100+i;
            [self addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];

            if (!temp) {
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(0);
                    make.top.equalTo(0);
                    make.bottom.equalTo(0);
                    make.width.equalTo(width);
                    make.height.equalTo(height);
                }];
            }else{
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(temp.right).offset(space);
                    make.top.equalTo(0);
                    make.bottom.equalTo(0);
                    make.width.equalTo(width);
                }];

            }
            [self setValue:imageView forKey:array[i]];
            temp = imageView;
        }
    }
    return self;
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag-100;
    if (index >= 0 && index < _urlArray.count) {
        if (self.block) {
            self.block(index,_urlArray);
        }
    }
}

- (void)setImageWithUrl:(NSArray <NSDictionary *>*)urlArray{
    _urlArray = urlArray;
    imageViewOne.image = nil;
    imageViewTwo.image = nil;
    imageViewThree.image = nil;
    imageViewFour.image = nil;
    for (int i = 0; i < urlArray.count; i ++) {
        if (i == 0) {
            [imageViewOne sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }else if (i == 1){
            [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }else if (i == 2){
            [imageViewThree sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }else if (i == 3){
            [imageViewFour sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }
    }
}
@end

#pragma mark - cell
@implementation NewsTestTableViewCell

{
    UILabel *titleLabel;//标题
    UIImageView *iconImageView;//左侧图片
    TestCellIntroduceView *introduceView;//右侧5个按钮及描述视图
    TimeShowImageView *showImageView;//底部图片展示

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = colorBlack;

    iconImageView = [[UIImageView alloc] init];

    introduceView = [[TestCellIntroduceView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-130, 120)];

    UILabel *label = [[UILabel alloc] init];
    label.textColor = colorDeepGray;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"    实拍图片";
    UIView *lietiaotiao = [[UIView alloc] init];
    lietiaotiao.backgroundColor = colorYellow;
    [label addSubview:lietiaotiao];
    [lietiaotiao makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(0);
        make.width.equalTo(2);
    }];

    showImageView = [[TimeShowImageView alloc] init];
    __weak __typeof(self)weakSelf = self;
    showImageView.block = ^(NSInteger index, NSArray *urlArray){
        ImageShowViewController *show = [[ImageShowViewController alloc] init];
        show.mid = urlArray[index][@"mid"];
        show.pageIndex = index;
        show.hidesBottomBarWhenPushed = YES;
        [weakSelf.parentController.navigationController pushViewController:show animated:YES];
    };

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = colorLineGray;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:introduceView];
    [self.contentView addSubview:label];
    [self.contentView addSubview:showImageView];
    [self.contentView addSubview:line];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(5);
        make.size.equalTo(CGSizeMake(100, 120));
    }];

    [introduceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(iconImageView);
        make.right.equalTo(-10);
        make.height.equalTo(iconImageView);
    }];

    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(iconImageView.bottom).offset(10);
    }];

    [showImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(label.bottom).offset(10);
        make.width.equalTo(WIDTH-20);
    }];

    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showImageView.bottom).offset(10);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

- (void)setModel:(NewsTestTableViewModel *)model{
    titleLabel.text = model.title;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.maxImage] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    [showImageView setImageWithUrl:model.minImage];
    introduceView.model = model;
    introduceView.descArray = model.desc;
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
