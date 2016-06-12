//
//  ContrasChartCollectionView.h
//  chezhiwang
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContrasChartCollectionViewScrollDelegate <NSObject>

@optional
-(void)scrollContentOffSet:(CGPoint)contentOffSet;

@end

@interface ContrasChartCollectionView : UICollectionView

@property (nonatomic,weak) id<ContrasChartCollectionViewScrollDelegate> ChartDelegate;

+ (instancetype)initWithFrame:(CGRect)frame;

-(void)setScrollContentOffSet:(CGPoint)contentOffSet;

@end
