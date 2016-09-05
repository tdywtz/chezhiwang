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

@interface ChartView ()<OnTheLeftViewDelegate>
{
    TopCollectionView *topCollectionView;
    ChartTableView *_chartTableView;
    OnTheLeftView  *_onTheLectView;
}
@end

@implementation ChartView

- (void)dealloc
{
    [topCollectionView removeObserver:self forKeyPath:Excel_topCollectionViewContentOffset];
    [_chartTableView removeObserver:self forKeyPath:Excel_collectionViewContentOffset];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:[UIView new]];

        _onTheLectView = [[OnTheLeftView alloc] initWithFrame:CGRectZero];
        _onTheLectView.delegate = self;
        [self addSubview:_onTheLectView];

        _chartTableView = [ChartTableView initWithFrame:CGRectZero];
        [self addSubview:_chartTableView];

        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        topCollectionView = [[TopCollectionView alloc ] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:topCollectionView];
        __weak __typeof(self)weakSelf = self;
        [topCollectionView ruturnModel:^(TopCollectionViewModel *topModel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.block(topModel);
        }];
        
        [topCollectionView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(100);
        }];

        [_chartTableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(100, 0, 0, 0));
        }];

        [_onTheLectView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(0);
            make.size.equalTo(CGSizeMake(100, 100));
        }];

        [topCollectionView addObserver:self forKeyPath:Excel_topCollectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_chartTableView addObserver:self forKeyPath:Excel_collectionViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
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
                        ChartRowModel *newRowModel = [[ChartRowModel alloc] init];
                        newRowModel.cellHeight = rowModel.cellHeight;
                        newRowModel.name = rowModel.name;
                        newRowModel.itemModels = rowModel.itemModels;
                        [rows addObject:newRowModel];
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
    [_chartTableView reloadData];
}



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


- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
 
    if ([keyPath isEqualToString:Excel_topCollectionViewContentOffset]) {
        _chartTableView.topOffset = topCollectionView.contentOffset;

    }
    else if ([keyPath isEqualToString:Excel_collectionViewContentOffset]) {
        topCollectionView.contentOffset = [_chartTableView.collectionViewContentOffset CGPointValue];
    }
}

- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block{
    self.block = block;
}

- (void)setSectionModels:(NSArray<__kindof ChartSectionModel *> *)sectionModels{
    _sectionModels = sectionModels;
    _chartTableView.sectionModels = sectionModels;

}

- (void)reloadData{
    [_chartTableView reloadData];
    [topCollectionView reloadData];
}

- (void)setTopModels:(NSArray<__kindof TopCollectionViewModel *> *)topModels{
    _topModels = topModels;
    topCollectionView.topModels = topModels;
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

}
- (void)hideButtonClick:(BOOL)hide{
    [self hideSimilarity:hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
