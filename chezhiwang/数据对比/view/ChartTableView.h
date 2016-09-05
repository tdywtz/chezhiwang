//
//  ChartTableView.h
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartSectionModel.h"

#define Excel_topCollectionViewContentOffset @"topCollectionViewContentOffset"
#define Excel_collectionViewContentOffset @"collectionViewContentOffset"

@interface ChartTableView : UITableView

@property (nonatomic,strong) NSArray <__kindof ChartSectionModel *> *sectionModels;
//记录collectionView滚动坐标
@property (nonatomic,strong) NSValue *collectionViewContentOffset;
//头部collectionView的滑动坐标
@property (nonatomic,assign) CGPoint topOffset;
//列表item的宽度
@property (nonatomic,assign) CGFloat itemWidth;

+ (instancetype)initWithFrame:(CGRect)frame;

@end
