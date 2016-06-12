//
//  BasicObject.h
//  chezhiwang
//
//  Created by bangong on 16/5/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicObject : NSObject
/**
 *  数据字典转换数据模型
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  获取属性名数组
 */
-(NSArray *)getPropertyArray;

/**
 *  将属性转换成字典
 */
-(NSDictionary *)getDcitonary;

/**
 *  二进制数据转换字典
 */
-(NSDictionary*)returnDictionaryWithData:(NSData *)data;

/**
 *  字典转换二进制
 */
-(NSData*)returnDataWithDictionary:(NSDictionary*)dict;
@end
