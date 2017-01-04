//
//  MyCarModel.m
//  chezhiwang
//
//  Created by bangong on 16/12/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyCarModel.h"

@implementation MyCarModel

- (NSString *)value{
    if (_value == nil) {
        _value = @"";
    }

    return _value;
}


+ (instancetype)initWithName:(NSString *)name value:(NSString *)value valueKey:(NSString *)valueKey submitKey:(NSString *)submitKey placeholder:(NSString *)placeholder{
    MyCarModel *model = [[MyCarModel alloc] init];

    model.isEnable = YES;
    model.name = name;
    model.value = value;
    model.valueKey = valueKey;
    model.submitKey = submitKey;
    model.placeholder = placeholder;

    return model;
}
@end
