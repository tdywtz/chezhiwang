//
//  VehicleSeriesSctionModel.m
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "VehicleSeriesSctionModel.h"

@implementation VehicleSeriesSctionModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super initWithDictionary:dictionary]) {
        self.typeName = dictionary[@"typename"];
    }
    return self;
}
@end
