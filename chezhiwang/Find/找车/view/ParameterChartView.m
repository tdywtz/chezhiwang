//
//  ParameterChartView.m
//  chezhiwang
//
//  Created by bangong on 17/1/5.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "ParameterChartView.h"
#import "ChartTableView.h"
#import "ChooseTableViewController.h"
#import "ChartView.h"

#pragma mark - ParameterTopModel
@implementation ParameterTopModel

- (NSAttributedString *)defaultAttribute{
    //NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"\n选择车型"];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:[UIImage imageNamed:@"auto_车型参数_加号"] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(20, 20) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
   // [attachment appendAttributedString:att];
    attachment.yy_font = [UIFont systemFontOfSize:15];
    attachment.yy_color = colorDeepGray;
    attachment.yy_alignment = NSTextAlignmentCenter;
    return attachment;
}


+ (instancetype)modelWithString:(NSString *)string{
    ParameterTopModel *model = [[ParameterTopModel alloc] init];
    if (string) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
        att.yy_font = [UIFont systemFontOfSize:13];
        att.yy_color = colorLightBlue;
        att.yy_lineSpacing = 2;
        model.attributeText = att;
    }
    return model;
}
@end




#pragma mark - LeftTopView
@implementation LeftTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = colorLineGray;

        _highlightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_highlightButton setTitle:@" 高亮差异参数 " forState:UIControlStateNormal];
        [_highlightButton setTitleColor:colorDeepGray forState:UIControlStateNormal];
        [_highlightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _highlightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_highlightButton addTarget:self action:@selector(highlightClick) forControlEvents:UIControlEventTouchUpInside];
        _highlightButton.layer.cornerRadius = 4;
        _highlightButton.backgroundColor = colorBackGround;

        _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideButton setTitle:@" 隐藏相同参数 " forState:UIControlStateNormal];
        [_hideButton setTitleColor:colorDeepGray forState:UIControlStateNormal];
        [_hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _hideButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_hideButton addTarget:self action:@selector(hideClick) forControlEvents:UIControlEventTouchUpInside];
        _hideButton.layer.cornerRadius = 4;
        _hideButton.backgroundColor = colorBackGround;

        [self addSubview:_highlightButton];
        [self addSubview:_hideButton];
        [self addSubview:lineView];

        [_highlightButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(20);
        }];

        [_hideButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(-20);
        }];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(0);
            make.width.equalTo(0.5);
        }];
    }
    return self;
}

- (void)highlightClick{

    _highlightButton.selected = !_highlightButton.selected;
    if (self.click) {
        self.click(0,_highlightButton.selected);
    }
    if (_highlightButton.selected) {
        _highlightButton.backgroundColor = colorYellow;
    }else{
        _highlightButton.backgroundColor = colorBackGround;
    }
}

- (void)hideClick{

    _hideButton.selected = !_hideButton.selected;
    if (self.click) {
        self.click(1,_hideButton.selected);
    }
    if (_hideButton.selected) {
        _hideButton.backgroundColor = colorYellow;
    }else{
        _hideButton.backgroundColor = colorBackGround;
    }
}

- (void)initialSetting{
    _highlightButton.selected = NO;
    _hideButton.selected = NO;
    _highlightButton.backgroundColor = colorBackGround;
    _hideButton.backgroundColor = colorBackGround;
}

@end




#pragma mark - ParameterTopCell
@implementation ParameterTopCell
{
    YYLabel *Label;
    UIButton *cancelButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = colorLineGray.CGColor;

        Label = [YYLabel new];
        Label.layer.cornerRadius = 4;
        Label.layer.borderWidth = 0.7;
        Label.numberOfLines = 0;
        Label.layer.borderColor = colorLineGray.CGColor;
        Label.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [Label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];

        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"车型对比-删除"] forState:UIControlStateNormal];

        [self.contentView addSubview:Label];
        [self.contentView addSubview:cancelButton];

        Label.lh_width = frame.size.width - 20;
        Label.lh_height = frame.size.height - 30;
        Label.lh_centerY = frame.size.height/2;
        Label.lh_centerX = frame.size.width/2;

        cancelButton.lh_size = CGSizeMake(25, 25);
        cancelButton.lh_right = frame.size.width;
        cancelButton.lh_top = 0;
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    if (_topModel.isModelName) {
        return;
    }

//    NSString
//    HttpRequest GET:<#(NSString *)#> success:<#^(id responseObject)success#> failure:<#^(NSError *error)failure#>
//
//    ParameterTopModel *model = [ParameterTopModel modelWithString:@"KFHKGNJKK"];
//    model.isModelName = YES;
//    _topModel.addModel = model;
    if (self.block) {
        self.block(_topModel);
    }
}

- (void)cancelClick{
    if (self.cancel) {
        self.cancel(_topModel);
    }
}

- (void)setTopModel:(ParameterTopModel *)topModel{
    _topModel = topModel;

    Label.attributedText = topModel.attributeText;
    if (topModel.isModelName) {
        cancelButton.hidden = NO;

    }else{
        cancelButton.hidden = YES;
    }
    Label.hidden = topModel.isHide;
}

@end



#pragma mark - ParameterTopCollectionView
@implementation ParameterTopCollectionView

+ (instancetype)HorizontalWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    ParameterTopCollectionView *one = [[ParameterTopCollectionView alloc ] initWithFrame:frame collectionViewLayout:layout];
    return one;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {

        ParameterTopModel *model = [[ParameterTopModel alloc] init];
        model.attributeText = [model defaultAttribute];
        _topModels = @[model];
        _itemWidth = 110;

        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        [self registerClass:[ParameterTopCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_topCollectionViewContentOffset];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ParameterTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.parentViewController = self.parentViewController;
    cell.topModel = self.topModels[indexPath.row];
    cell.topModel.index = indexPath.row;
    //回调数据
    cell.block = self.block;
    cell.cancel = self.cancel;

    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.itemWidth, self.frame.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end

#pragma mark - ParameterChartView
@interface ParameterChartView ()
{
  ParameterTopCollectionView *topCollectionView;
  ChartTableView *_chartTableView;
  LeftTopView *ltView;
    //滑动到顶部按钮
    UIButton *scrollToTopButton;
    //菜单
    UIButton *menuButton;
    ExcelMenu *menuView;
}
@end

@implementation ParameterChartView

- (void)dealloc
{
    [topCollectionView removeObserver:self forKeyPath:Excel_topCollectionViewContentOffset];
    [_chartTableView removeObserver:self forKeyPath:Excel_collectionViewContentOffset];
    [_chartTableView removeObserver:self forKeyPath:Excel_contentTableViewContentOffset];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        __weak __typeof(self)weakSelf = self;
        ltView            = [[LeftTopView alloc] init];
        ltView.click = ^(NSInteger index, BOOL style){
            if (index == 0) {
                [weakSelf highlight:style];
            }else{
                [weakSelf hide:style];
            }
        };

        topCollectionView = [ParameterTopCollectionView HorizontalWithFrame:CGRectZero];
         _chartTableView  = [ChartTableView initWithFrame:CGRectZero];

        scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scrollToTopButton.layer.cornerRadius = 15;
        scrollToTopButton.layer.masksToBounds = YES;
        scrollToTopButton.backgroundColor = [UIColor lightGrayColor];
        scrollToTopButton.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"bar_btn_icon_returntext"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:UIImageOrientationRight];
        [scrollToTopButton setImage:image forState:UIControlStateNormal];
        [scrollToTopButton addTarget:self action:@selector(scrollToTopClick) forControlEvents:UIControlEventTouchUpInside];

        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setTitle:@"目录" forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuButton.backgroundColor = colorLightBlue;
        [menuButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];


        menuView = [[ExcelMenu alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        menuView.hidden = YES;
        __weak __typeof(_chartTableView)weakTableView = _chartTableView;
        __weak __typeof(menuView)weakMenu = menuView;
        menuView.scrollToSection = ^(NSInteger section){
            weakMenu.hidden = YES;
            ChartSectionModel *sectionModel = weakTableView.sectionModels[section];
            if (sectionModel.rowModels.count > 0) {
                [weakTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        };


        [self addSubview:ltView];
        [self addSubview:topCollectionView];
        [self addSubview:_chartTableView];
        [self addSubview:scrollToTopButton];
        [self addSubview:menuButton];
        [self addSubview:menuView];

        ltView.lh_size = CGSizeMake(100, 100);
        
        topCollectionView.lh_top = 0;
        topCollectionView.lh_left = 100;
        topCollectionView.lh_height = 100;
        topCollectionView.lh_width = frame.size.width - 100;

        _chartTableView.lh_left = 0;
        _chartTableView.lh_top = topCollectionView.lh_bottom;
        _chartTableView.lh_width = frame.size.width;
        _chartTableView.lh_height = frame.size.height - topCollectionView.lh_bottom;

        scrollToTopButton.lh_size = CGSizeMake(30, 30);
        scrollToTopButton.lh_right = self.lh_width - 5;
        scrollToTopButton.lh_bottom = self.lh_height - 100;

        menuButton.lh_size = CGSizeMake(60, 30);
        menuButton.lh_bottom = self.lh_height - 200;


        [topCollectionView addObserver:self forKeyPath:Excel_topCollectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_chartTableView addObserver:self forKeyPath:Excel_collectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_chartTableView addObserver:self forKeyPath:Excel_contentTableViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return self;
}

//滑动至顶部按钮响应事件
- (void)scrollToTopClick{
    [_chartTableView setContentOffset:CGPointZero animated:YES];
}

//目录
- (void)menuClick{

    CGPoint center = menuView.center;
    center.y = menuButton.center.y;
    center.x = menuView.frame.size.width/2+menuButton.frame.size.width;
    menuView.center = center;

    menuView.hidden = !menuView.hidden;
}

//高亮差异参数
- (void)highlight:(BOOL)style{
    NSArray *sections = self.sectionModels;
    for (ChartSectionModel *sectionModel in sections) {
        for (ChartRowModel *rowModel in sectionModel.rowModels) {

            if (style) {
                if ([rowModel similarityData]) {
                    rowModel.textColor = colorDeepGray;
                }else{
                    rowModel.textColor = colorOrangeRed;
                }
            }else{
                rowModel.textColor = colorDeepGray;
            }
        }
    }
    [_chartTableView reloadData];
}

//隐藏相同参数
- (void)hide:(BOOL)style{
    if (style) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.sectionModels.count; i ++) {
            ChartSectionModel *sectionModel = self.sectionModels[i];
            ChartSectionModel *newSectionModel = [[ChartSectionModel alloc] init];
            newSectionModel.name = sectionModel.name;

                NSMutableArray *rows = [[NSMutableArray alloc] init];
                for (ChartRowModel *rowModel in sectionModel.rowModels) {
                    //若不是完全相同，加入新数组
                    if (![rowModel similarityData]) {
                        [rows addObject:rowModel];
                    }
                }
                newSectionModel.rowModels = rows;

            [array addObject:newSectionModel];
        }
        _chartTableView.sectionModels = array;
    }else{

        _chartTableView.sectionModels = self.sectionModels;
        
    }
    [_chartTableView reloadData];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{

    if ([keyPath isEqualToString:Excel_topCollectionViewContentOffset]) {
        _chartTableView.topOffset = topCollectionView.contentOffset;

    }
    else if ([keyPath isEqualToString:Excel_collectionViewContentOffset]) {
        topCollectionView.contentOffset = [_chartTableView.collectionViewContentOffset CGPointValue];
    }else if ([keyPath isEqualToString:Excel_contentTableViewContentOffset]){
        CGPoint point = [_chartTableView.contentTableViewContentOffset CGPointValue];

        if (point.y > 1000) {
            scrollToTopButton.hidden = NO;
        }else{
            scrollToTopButton.hidden = YES;
        }
    }
}


- (void)setSectionModels:(NSArray<__kindof ChartSectionModel *> *)sectionModels{
    _sectionModels = sectionModels;
    _chartTableView.sectionModels = sectionModels;
     menuView.dataArray = sectionModels;
}

- (void)setTopModels:(NSArray<__kindof ParameterTopModel *> *)topModels{
    topCollectionView.topModels = topModels;
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;

    _chartTableView.itemWidth = itemWidth;
    topCollectionView.itemWidth = itemWidth;
}

- (void)setBlock:(ParameterTopCellBlock)block{
    topCollectionView.block = block;
    [topCollectionView reloadData];
}

- (void)setCancel:(ParameterTopCellCancel)cancel{
     topCollectionView.cancel = cancel;
    [topCollectionView reloadData];
}

- (void)setParentViewController:(UIViewController *)parentViewController{
    topCollectionView.parentViewController = parentViewController;
}

//- (NSArray<__kindof ChartSectionModel *> *)sectionModels{
//    return _chartTableView.sectionModels;
//}

- (NSArray<__kindof ParameterTopModel *> *)topModels{
    return  topCollectionView.topModels;
}

- (void)reloadData{
    [topCollectionView reloadData];
    [_chartTableView reloadData];
}


- (void)leftTopInitialSetting{
    [ltView initialSetting];
    [self highlight:NO];
    [self hide:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
