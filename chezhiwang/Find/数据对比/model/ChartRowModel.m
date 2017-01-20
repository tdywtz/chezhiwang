//
//  ChartRowModel.m
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartRowModel.h"

@implementation ChartRowModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textColor = colorDeepGray;
        _itemWidth = 120;
    }
    return self;
}

/**判断一行中是否都是相同数据*/
- (BOOL)similarityData{
    NSArray *items = _itemModels;
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


- (CGFloat)cellHeight{
    if (_cellHeight < 44) {
        return 44;
    }
    return _cellHeight;
}

- (CGFloat)getCellHeight{
    CGFloat getHeight = 0;
    for (ChartItemModel *itemModel in self.itemModels) {
        NSInteger height = (NSInteger)[itemModel.attribute boundingRectWithSize:CGSizeMake(_itemWidth-10, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        height += 20;

        if (getHeight < height) {
            getHeight = height;
        }
    }

    return getHeight;
}

@end
