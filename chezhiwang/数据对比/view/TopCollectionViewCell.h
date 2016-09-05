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

@property (nonatomic,copy) void (^block)(TopCollectionViewModel *topModel);

- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block;

@end
