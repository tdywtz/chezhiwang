//
//  ParameterChartView.m
//  chezhiwang
//
//  Created by bangong on 17/1/5.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "ParameterChartView.h"
#import "ChartTableView.h"

#pragma mark - ParameterTopModel
@implementation ParameterTopModel

- (NSAttributedString *)defaultAttribute{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"\n选择车型"];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:[UIImage imageNamed:@"centre_answer"] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(20, 20) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    [attachment appendAttributedString:att];
    attachment.yy_font = [UIFont systemFontOfSize:15];
    attachment.yy_color = colorDeepGray;
    attachment.yy_lineSpacing = 5;
    attachment.yy_alignment = NSTextAlignmentCenter;
    return attachment;
}


+ (instancetype)modelWithString:(NSString *)string{
    ParameterTopModel *model = [[ParameterTopModel alloc] init];
    if (string) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
        att.yy_font = [UIFont systemFontOfSize:15];
        att.yy_color = colorLightBlue;
        att.yy_lineSpacing = 4;
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
        [_highlightButton setTitle:@"高亮差异参数" forState:UIControlStateNormal];
        [_highlightButton setTitleColor:colorDeepGray forState:UIControlStateNormal];
        _highlightButton.titleLabel.font = [UIFont systemFontOfSize:12];

        _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideButton setTitle:@"隐藏相同参数" forState:UIControlStateNormal];
        [_hideButton setTitleColor:colorDeepGray forState:UIControlStateNormal];
        _hideButton.titleLabel.font = [UIFont systemFontOfSize:12];

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
            make.width.equalTo(1);
        }];
    }
    return self;
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

        Label = [YYLabel new];
        Label.layer.cornerRadius = 4;
        Label.layer.borderWidth = 1;
        Label.numberOfLines = 0;
        Label.layer.borderColor = colorLightBlue.CGColor;
        Label.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [Label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];

        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:Label];
        [self.contentView addSubview:cancelButton];

        Label.lh_width = frame.size.width - 10;
        Label.lh_height = frame.size.height - 20;
        Label.lh_centerY = frame.size.height/2;
        Label.lh_centerX = frame.size.width/2;

        cancelButton.layer.cornerRadius = 10;
        cancelButton.layer.masksToBounds = YES;
        cancelButton.backgroundColor = [UIColor redColor];
        cancelButton.lh_size = CGSizeMake(20, 20);
        cancelButton.lh_centerX = Label.lh_right - 3;
        cancelButton.lh_centerY = Label.lh_top + 3;
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    if (_topModel.isModelName) {
        return;
    }

    ParameterTopModel *model = [ParameterTopModel modelWithString:@"KFHKGNJKK"];
    model.isModelName = YES;
    _topModel.addModel = model;
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

        ltView            = [[LeftTopView alloc] init];
        topCollectionView = [ParameterTopCollectionView HorizontalWithFrame:CGRectZero];
         _chartTableView  = [ChartTableView initWithFrame:CGRectZero];

        [self addSubview:ltView];
        [self addSubview:topCollectionView];
        [self addSubview:_chartTableView];

        ltView.lh_size = CGSizeMake(100, 100);
        
        topCollectionView.lh_top = 0;
        topCollectionView.lh_left = 100;
        topCollectionView.lh_height = 100;
        topCollectionView.lh_width = frame.size.width - 100;

        _chartTableView.lh_left = 0;
        _chartTableView.lh_top = topCollectionView.lh_bottom;
        _chartTableView.lh_width = frame.size.width;
        _chartTableView.lh_height = frame.size.height - topCollectionView.lh_bottom;

        [topCollectionView addObserver:self forKeyPath:Excel_topCollectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_chartTableView addObserver:self forKeyPath:Excel_collectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_chartTableView addObserver:self forKeyPath:Excel_contentTableViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return self;
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

//        if (point.y > 1000) {
//            scrollToTopButton.hidden = NO;
//        }else{
//            scrollToTopButton.hidden = YES;
//        }
    }
}


- (void)setSectionModels:(NSArray<__kindof ChartSectionModel *> *)sectionModels{
    _chartTableView.sectionModels = sectionModels;
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

- (NSArray<__kindof ChartSectionModel *> *)sectionModels{
    return _chartTableView.sectionModels;
}

- (NSArray<__kindof ParameterTopModel *> *)topModels{
    return  topCollectionView.topModels;
}

- (void)reloadData{
    [topCollectionView reloadData];
    [_chartTableView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
