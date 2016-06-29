//
//  ComplainChartSecondModel.m
//  chezhiwang
//
//  Created by bangong on 16/6/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartSecondModel.h"

@implementation ComplainChartSecondModel

- (void)setNumber:(NSString *)number{
    if ([number isKindOfClass:[NSString class]]) {
        number = [NSString stringWithFormat:@"%@",number];
    }
    _number = number;
}
@end
