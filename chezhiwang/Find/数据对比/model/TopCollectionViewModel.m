//
//  TopCollectionViewModel.m
//  chezhiwang
//
//  Created by bangong on 16/8/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TopCollectionViewModel.h"

@implementation TopCollectionViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _brandName = @"选择品牌";
        _seriesName = @"选择车系";
        _modelName = @"选择车型";
    }
    return self;
}
@end
