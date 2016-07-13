
//
//  NewsTestTableView.m
//  chezhiwang
//
//  Created by bangong on 16/5/31.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestTableView.h"
#import "ComplainChartView.h"
#import "ChartChooseListViewController.h"
#import "ImageShowViewController.h"

#pragma mark - 文字显示框

@interface TestLabel : LHLabel

@property (nonatomic,assign) CGFloat draw_x;//突角点x坐标
@property (nonatomic,assign) CGFloat cornerRadius;//弧度半径
@end

@implementation TestLabel

-(void)setDraw_x:(CGFloat)draw_x{
    if (_draw_x != draw_x) {
        _draw_x = draw_x;
       // [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
  
  //框
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetRGBStrokeColor(context, 255/255.0,  147/255.0, 4/255.0, 1);//线条颜色
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
    CGFloat tox = rect.size.width-self.textInsets.right+5;
    CGFloat cy = rect.size.height/2+5;
    CGContextMoveToPoint(jiantou, tox, cy-8);
    CGContextAddLineToPoint(jiantou, tox+7, cy);
    CGContextAddLineToPoint(jiantou, tox, cy+8);
    CGContextStrokePath(jiantou);
    
}

@end

#pragma mark 自定义按钮

@interface TestCustonBtn : UIButton

@property (nonatomic,strong) UIImageView *customImageView;
@property (nonatomic,strong) UILabel *customTitleLabel;

- (void)setCustomBarTitleColor:(UIColor *)color;
@end

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
    _customImageView.backgroundColor = [UIColor colorWithCGColor:color.CGColor];
}
@end

#pragma mark - 右侧展示框
@interface TestCellIntroduceView : UIView

@property (nonatomic,strong) NSMutableArray <TestCustonBtn *> *buttons;
@property (nonatomic,strong) TestLabel *contentLabel;//文字展示
@property (nonatomic,strong) NSArray *descArray;//描述数组

@end

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
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.alignment = NSTextAlignmentJustified;
        _contentLabel.textInsets = UIEdgeInsetsMake(5, 5, 18, 20);
        _contentLabel.draw_x = btnWidth/2;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = colorLightGray;
        _contentLabel.lineSpacing = 3;
     
        [self addSubview:_contentLabel];
    }
    
    return self;
}

-(void)titleClick:(TestCustonBtn *)btn{
    _contentLabel.draw_x = btn.center.x;

    NSInteger index = [self.buttons indexOfObject:btn];
    if (index < self.buttons.count) {
        _contentLabel.text = _descArray[index][@"font"];//描述内容
    }else{
        _contentLabel.text = @"";
    }

    for (TestCustonBtn *testBtn in self.buttons) {
      
        if ([testBtn isEqual:btn]) {
          
            [testBtn setCustomBarTitleColor:colorYellow];
           
        }else{
            [testBtn setCustomBarTitleColor:colorLightBlue];
        }
    }
}

- (void)setDescArray:(NSArray *)descArray{
    _descArray = descArray;
    [self titleClick:self.buttons[0]];
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

#pragma mark - 评测cell
//
@interface NewsTestTableViewCell : UITableViewCell

@property (nonatomic,weak) UIViewController *parentController;
- (void)setdictionary:(NSDictionary *)dictionary;
@end

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
        show.imageUrlArray = urlArray;
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

- (void)setdictionary:(NSDictionary *)dictionary{
    titleLabel.text = dictionary[@"title"];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"maxImage"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    [showImageView setImageWithUrl:dictionary[@"minImage"]];
    introduceView.descArray = dictionary[@"desc"]; 
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark - NewsTestTableView////////////////////////////////////////////////////////////////////
@interface NewsTestTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    ComplainChartView *_chart;//头部选择数据
    NSInteger _count;
}
@property (nonatomic,weak) UIViewController *parentViewController;
@end

@implementation NewsTestTableView

- (instancetype)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parent{
    if (self = [super initWithFrame:frame]) {
         _count = 1;
        _parentViewController = parent;
        _dataArray = [[NSMutableArray alloc] init];
        __weak __typeof(self)wealself = self;
        //创建头部选择按钮
        _chart = [[ComplainChartView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 80) titles:@[@"品牌",@"车系",@"车型",@"车型属性",@"品牌属性",@"系别"] block:^(NSInteger index, BOOL initialSetUp) {

            if (!initialSetUp) {
                _count = 1;
                [wealself loadData];
                return ;
            }
            
            ChartChooseType chooseType;
            if (index == 0) {
                chooseType = ChartChooseTypeBrand;
            }else if (index == 1){
                 chooseType = ChartChooseTypeSeries;
            }else if (index == 2){
                 chooseType = ChartChooseTypeModel;
            }else if (index == 3){
                 chooseType = ChartChooseTypeAttributeModel;
            }else if (index == 4){
                 chooseType = ChartChooseTypeAttributeBrand;
            }else if (index == 5){
                 chooseType = ChartChooseTypeAttributeSeries;
            }
            DirectionStyle style = DirectionRight;
            if ((index+1)%3 == 0) {
                style = DirectionLeft;
            }
    
            ChartChooseListViewController *choose = [[ChartChooseListViewController alloc] initWithType:chooseType direction:style];
            //在choose页面选中数据后回调
            choose.chooseEnd = ^(NSString *title , NSString *tid){
                [_chart setTitle:title tid:tid index:index];
                _count = 1;
    
                [wealself loadData];
//                if (chooseType == ChartChooseTypeBrand) {
//
//                }else if (chooseType == ChartChooseTypeSeries){
//
//                }else if (chooseType == ChartChooseTypeAttributeModel){
//
//                }else if (chooseType == ChartChooseTypeAttributeBrand){
//
//                }else if (chooseType == ChartChooseTypeAttributeSeries){
//
//                }
            };
            [wealself.parentViewController presentViewController:choose animated:NO completion:nil];
        }];
        [_chart hideBarWithIndex:2];//隐藏第三个按钮
        [self addSubview:_chart];
    
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_chart.frame)+10, CGRectGetWidth(frame), CGRectGetHeight(frame)-CGRectGetHeight(_chart.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 200;
        [self addSubview:_tableView];
        
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chart.bottom);
            make.left.and.right.equalTo(0);
            make.bottom.equalTo(0);
        }];

        [self loadData];
    }
    
    return self;
}

- (void)loadData{
    NSString *bid = [_chart gettidWithIndex:0];
    NSString *sid = [_chart gettidWithIndex:1];
    NSString *mattr = [_chart gettidWithIndex:3];
    NSString *battr = [_chart gettidWithIndex:4];
    NSString *dep = [_chart gettidWithIndex:5];

    NSString *url = [NSString stringWithFormat:[URLFile urlString_testDrive],bid,sid,mattr,battr,dep,_count];
 
    [HttpRequest GET:url success:^(id responseObject) {
        _dataArray = [responseObject[@"rel"] copy];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  <#Description#>
 *
 *  @param toTop <#toTop description#>
 */
- (void)setScrollToTop:(BOOL)toTop{
    _tableView.scrollsToTop = toTop;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NewsTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (!cell) {
        cell = [[NewsTestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentController = self.parentViewController;
        
    }
    [cell setdictionary:_dataArray[indexPath.row]];
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ImageShowViewController *show = [[ImageShowViewController alloc] init];
//    show.hidesBottomBarWhenPushed = YES;
//    [self.parentViewController.navigationController pushViewController:show animated:YES];
//}


@end
