//
//  ParameterChartView.h
//  chezhiwang
//
//  Created by bangong on 17/1/5.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartSectionModel.h"

@class ParameterTopModel;
/**选择车型信息*/
typedef void (^ParameterTopCellBlock)(ParameterTopModel *topModel);
/**取消选择*/
typedef void (^ParameterTopCellCancel)(ParameterTopModel *topModel);

#pragma mark - ParameterTopModel
@interface ParameterTopModel : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSAttributedString *attributeText;
@property (nonatomic,assign) BOOL isModelName;
@property (nonatomic,strong) ParameterTopModel *addModel;
@property (nonatomic,assign) BOOL isHide;

+ (instancetype)modelWithString:(NSString *)string;

@end


#pragma mark - LeftTopView
@interface LeftTopView : UIView

@property (nonatomic,strong) UIButton *highlightButton;
@property (nonatomic,strong) UIButton *hideButton;

@property (nonatomic,copy) void (^click)(NSInteger index, BOOL style);

- (void)initialSetting;

@end

#pragma mark - ParameterTopCell
@interface ParameterTopCell : UICollectionViewCell

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) ParameterTopModel *topModel;
/**选择车型信息*/
@property (nonatomic,copy) ParameterTopCellBlock block;
/**取消选择*/
@property (nonatomic,copy) ParameterTopCellCancel cancel;

@end

#pragma mark - ParameterTopCollectionView
@interface ParameterTopCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic, strong) NSValue *topCollectionViewContentOffset;
@property (nonatomic,strong) NSArray<__kindof ParameterTopModel *> *topModels;
@property (nonatomic,assign) CGFloat itemWidth;

/**选择车型信息*/
@property (nonatomic,copy) ParameterTopCellBlock block;
/**取消选择*/
@property (nonatomic,copy) ParameterTopCellCancel cancel;

+ (instancetype)HorizontalWithFrame:(CGRect)frame;

@end


/**
 车型参数表格

 @param nonatomic <#nonatomic description#>
 @param weak <#weak description#>
 @return <#return value description#>
 */
#pragma mark - ParameterChartView
@interface ParameterChartView : UIView

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) NSArray <__kindof ChartSectionModel *> *sectionModels;
@property (nonatomic) NSArray <__kindof ParameterTopModel *> *topModels;
@property (nonatomic,assign) CGFloat itemWidth;


/**选择车型信息*/
- (void)setBlock:(ParameterTopCellBlock)block;
/**取消选择*/
- (void)setCancel:(ParameterTopCellCancel)cancel;

- (void)reloadData;

- (void)leftTopInitialSetting;

@end
