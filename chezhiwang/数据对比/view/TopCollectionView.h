//
//  TopCollectionView.h
//  chezhiwang
//
//  Created by bangong on 16/8/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopCollectionViewModel.h"

@interface TopCollectionView : UICollectionView

@property (nonatomic,weak) UIViewController *parentViewController;

@property (nonatomic, strong) NSValue *topCollectionViewContentOffset;
@property (nonatomic,strong) NSArray<__kindof TopCollectionViewModel *> *topModels;
@property (nonatomic,assign) CGFloat itemWidth;
/**选择车型信息*/
@property (nonatomic,copy) void(^block)(TopCollectionViewModel *topModel);
/**取消选择*/
@property (nonatomic,copy) void (^cancel)(TopCollectionViewModel *topModel);

/**选择车型信息*/
- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block;
/**取消选择*/
- (void)cancel:(void (^)(TopCollectionViewModel *topModel))cancel;
@end
