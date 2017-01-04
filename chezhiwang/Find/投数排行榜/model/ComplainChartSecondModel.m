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

    _number = [NSString stringWithFormat:@"%@",number];

}

- (void)setPercentage:(NSString *)percentage{
    _percentage = [NSString stringWithFormat:@"%@",percentage];
}
@end
