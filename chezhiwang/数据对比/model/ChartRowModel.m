//
//  ChartRowModel.m
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartRowModel.h"

@implementation ChartRowModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)cellHeight{
    if (_cellHeight < 44) {
        return 44;
    }
    return _cellHeight;
}
@end
