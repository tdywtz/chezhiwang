//
//  ChartView.m
//  chezhiwang
//
//  Created by bangong on 16/8/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartView.h"
#import "TopCollectionView.h"
#import "ChartTableView.h"
#import "OnTheLeftView.h"


@interface ExcelMenu : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) NSArray *dataArray;
@property (nonatomic,copy) void (^scrollToSection)(NSInteger section);

@end

@implementation ExcelMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(80, 25);
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(5, 20, 5, 10);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"menuCell"];

        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_collectionView reloadData];

    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = weakSelf.frame;
        frame.size.height = _collectionView.contentSize.height+10;
        weakSelf.frame = frame;
        [weakSelf setNeedsDisplay];
    });
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGRect frame = _collectionView.frame;
    frame.size.height = self.frame.size.height;
    _collectionView.frame = frame;
}

- (void)drawRect:(CGRect)rect{

     [super drawRect:rect];

    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, colorLightBlue.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 10, 1);
    CGContextAddLineToPoint(context, width-1, 1);
    CGContextAddLineToPoint(context, width-1, height-1);
    CGContextAddLineToPoint(context, 10, height-1);
    CGContextAddLineToPoint(context, 10, height/2+5);
    CGContextAddLineToPoint(context, 5, height/2);
    CGContextAddLineToPoint(context, 10, height/2-5);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);


}

// UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count-1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc] init];
        label.tag = 100;
        label.textColor = colorDeepGray;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = colorLightBlue.CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 3;
        [cell.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    ChartSectionModel *sectionModel = _dataArray[indexPath.row+1];
    label.text = sectionModel.name;
    return cell;
}
//UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.scrollToSection) {
        self.scrollToSection(indexPath.row+1);
    }
}

@end


#pragma mark - %%%
@interface ChartView ()<OnTheLeftViewDelegate>
{
    TopCollectionView *topCollectionView;
    ChartTableView *_chartTableView;
    OnTheLeftView  *_onTheLectView;
    //滑动到顶部按钮
    UIButton *scrollToTopButton;
    //菜单
    UIButton *menuButton;
    ExcelMenu *menuView;
}
@end

@implementation ChartView

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

        [self addSubview:[UIView new]];

        _onTheLectView = [[OnTheLeftView alloc] initWithFrame:CGRectZero];
        _onTheLectView.delegate = self;

        _chartTableView = [ChartTableView initWithFrame:CGRectZero];

        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        topCollectionView = [[TopCollectionView alloc ] initWithFrame:CGRectZero collectionViewLayout:layout];

        scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scrollToTopButton.layer.cornerRadius = 15;
        scrollToTopButton.layer.masksToBounds = YES;
        scrollToTopButton.backgroundColor = [UIColor grayColor];
        scrollToTopButton.hidden = YES;
        [scrollToTopButton addTarget:self action:@selector(scrollToTopClick) forControlEvents:UIControlEventTouchUpInside];

        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setTitle:@"目录" forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        menuButton.backgroundColor = colorLightBlue;
        [menuButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];


        menuView = [[ExcelMenu alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        menuView.hidden = YES;
         __weak __typeof(_chartTableView)weakTableView = _chartTableView;
        menuView.scrollToSection = ^(NSInteger section){
            ChartSectionModel *sectionModel = weakTableView.sectionModels[section];
            if (sectionModel.rowModels.count > 0) {
                [weakTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

        };

        [self addSubview:_onTheLectView];
        [self addSubview:_chartTableView];
        [self addSubview:topCollectionView];
        [self addSubview:scrollToTopButton];
        [self addSubview:menuButton];
        [self addSubview:menuView];

         __weak __typeof(self)weakSelf = self;
        [topCollectionView ruturnModel:^(TopCollectionViewModel *topModel) {
            weakSelf.block(topModel);
        }];

        [topCollectionView cancel:^(TopCollectionViewModel *topModel) {

            [weakSelf highlight:NO];
            [weakSelf hideSimilarity:NO];
            [weakSelf clearDateQueue:topModel.index];
            [_onTheLectView resetButton];
            [_chartTableView reloadData];
        }];

        [topCollectionView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(110);
        }];

        [_chartTableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(110, 0, 0, 0));
        }];

        [_onTheLectView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(0);
            make.size.equalTo(CGSizeMake(100, 110));
        }];

        [scrollToTopButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-5);
            make.bottom.equalTo(-100);
            make.size.equalTo(CGSizeMake(30, 30));
        }];

        [menuButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.bottom.equalTo(-200);
            make.size.equalTo(CGSizeMake(60, 30));
        }];

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

/**隐藏相同项*/
- (void)hideSimilarity:(BOOL)hide{

    if (hide) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.sectionModels.count; i ++) {
            ChartSectionModel *sectionModel = self.sectionModels[i];
            ChartSectionModel *newSectionModel = [[ChartSectionModel alloc] init];
            newSectionModel.name = sectionModel.name;
            if (i > 0) {
                //第一分组不做处理
                NSMutableArray *rows = [[NSMutableArray alloc] init];
                for (ChartRowModel *rowModel in sectionModel.rowModels) {
                    if (![self similarityData:rowModel.itemModels]) {
                        [rows addObject:rowModel];
                    }
                }
                newSectionModel.rowModels = rows;
            }else{
                newSectionModel.rowModels = sectionModel.rowModels;
            }

            [array addObject:newSectionModel];
        }
        _chartTableView.sectionModels = array;
    }else{

        _chartTableView.sectionModels = self.sectionModels;

    }
}

/**高亮异步参数*/
- (void)highlight:(BOOL)highlight{
    for (int i = 0; i < _chartTableView.sectionModels.count; i ++) {
        ChartSectionModel *sectionModel = _chartTableView.sectionModels[i];
        //第一分组不做处理
        if (i > 0) {
            for (ChartRowModel *rowModel in sectionModel.rowModels) {
                if (highlight) {
                    if ([self similarityData:rowModel.itemModels]) {

                        rowModel.textColor = colorDeepGray;
                    }else{

                        rowModel.textColor = colorOrangeRed;
                    }
                }else{
                    rowModel.textColor = colorDeepGray;
                }

            }
        }
    }
}

/**判断一行中是否都是相同数据*/
- (BOOL)similarityData:(NSArray *)items{

    if (items.count < 2) {
        return YES;
    }
    ChartItemModel *tempNodel = items[0];
    for (int i = 1; i < items.count; i ++) {
        ChartItemModel *itemModel = items[i];
        if (itemModel.name == nil) {
            continue;
        }
        if (![itemModel.name isEqualToString:tempNodel.name]) {
            return NO;
        }
    }
    return YES;
}

/**清除列数据*/
- (void)clearDateQueue:(NSInteger)queue{
    for (int i = 0; i < _sectionModels.count; i ++) {
        ChartSectionModel *sectionModel = _sectionModels[i];

        for (int j = 0; j < sectionModel.rowModels.count; j ++) {
            ChartRowModel *rowModel = sectionModel.rowModels[j];
            ChartItemModel *itemModel = rowModel.itemModels[queue];
            [itemModel releaseData];
            if (i == 0 && j == 4) {
                 rowModel.cellHeight = [rowModel getCellHeight];
            }
        }
    }
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


/**选择车型信息*/
- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block{
    self.block = block;
}
/**取消选择*/
- (void)cancel:(void (^)(TopCollectionViewModel *topModel))cancel{
    self.cancel = cancel;
}

- (void)setSectionModels:(NSArray<__kindof ChartSectionModel *> *)sectionModels{
    _sectionModels = sectionModels;
    _chartTableView.sectionModels = sectionModels;
    //重置按钮状态
    [_onTheLectView resetButton];
    //取消高亮状态
    [self highlight:NO];
    menuView.dataArray = sectionModels;

}

- (void)reloadData{
    [_chartTableView reloadData];
    [topCollectionView reloadData];
}

- (void)setTopModels:(NSArray<__kindof TopCollectionViewModel *> *)topModels{
    _topModels = topModels;
    topCollectionView.topModels = topModels;
    [_onTheLectView resetButton];
    [self highlight:NO];
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
    
    _chartTableView.itemWidth = itemWidth;
    topCollectionView.itemWidth = itemWidth;
}

- (void)setParentViewController:(UIViewController *)parentViewController{
    _parentViewController = parentViewController;
    topCollectionView.parentViewController = parentViewController;
}

#pragma mark - OnTheLeftViewDelegate
- (void)highlightButtonClick:(BOOL)highlight{
    [self highlight:highlight];
     [_chartTableView reloadData];
}
- (void)hideButtonClick:(BOOL)hide{
    [self hideSimilarity:hide];
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
