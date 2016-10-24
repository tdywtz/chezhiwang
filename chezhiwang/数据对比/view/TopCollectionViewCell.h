//
//  TopCollectionViewCell.h
//  chezhiwang
//
//  Created by bangong on 16/8/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopCollectionViewModel.h"

@interface TopCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) UIViewController *parentViewController;

@property (nonatomic,strong) TopCollectionViewModel *topModel;
/**选择车型信息*/
@property (nonatomic,copy) void (^block)(TopCollectionViewModel *topModel);
/**取消选择*/
@property (nonatomic,copy) void (^cancel)(TopCollectionViewModel *topModel);

/**选择车型信息*/
- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block;
/**取消选择*/
- (void)cancel:(void (^)(TopCollectionViewModel *topModel))cancel;
@end
