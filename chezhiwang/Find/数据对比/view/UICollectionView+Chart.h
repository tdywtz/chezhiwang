//
//  UICollectionView+Chart.h
//  chezhiwang
//
//  Created by bangong on 16/8/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Chart)

@property (nonatomic,assign) CGFloat theCellHeight;//行高
@property (nonatomic,strong) NSArray *itemModels;//当前行items数组
@property (nonatomic,strong) UIColor *rowTextColor;

@property (nonatomic,weak) NSIndexPath *path;//当前分组
@end
