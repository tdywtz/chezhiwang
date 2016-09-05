//
//  UICollectionView+Chart.m
//  chezhiwang
//
//  Created by bangong on 16/8/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "UICollectionView+Chart.h"
#import <objc/runtime.h>

@implementation UICollectionView (Chart)


- (void)setTheCellHeight:(CGFloat)theCellHeight{

    objc_setAssociatedObject(self, @"theCellHeight", @(theCellHeight), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)theCellHeight{
    return [objc_getAssociatedObject(self,  @"theCellHeight") floatValue];
}


- (void)setItemModels:(NSArray *)itemModels{
    objc_setAssociatedObject(self, @"itemModels", itemModels, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)itemModels{
    return objc_getAssociatedObject(self, @"itemModels");
}
@end
