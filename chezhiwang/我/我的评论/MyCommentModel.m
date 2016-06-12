//
//  MyComplainModel.m
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel
/**
 *  数据字典转换数据模型
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        NSArray *keys = [self getPropertyArray];
        for (NSString *key in keys) {
            
            if(dictionary[key]) [self setValue:dictionary[key] forKey:key];
        }
        if (dictionary[@"id"]) {
             _ID = dictionary[@"id"];
        }
    }
    return self;
}

@end
