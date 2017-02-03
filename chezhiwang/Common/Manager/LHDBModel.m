//
//  LHDBModel.m
//  chezhiwang
//
//  Created by bangong on 17/2/3.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "LHDBModel.h"

@implementation LHDBModel

//+ (NSDictionary *)getPropertysDictionary{
//
//}

+ (NSArray *)getPropertys{
    NSMutableArray *proNames = [NSMutableArray array];
    NSArray *theTransients = [[self class] transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSLog(@"%@",propertyType);
        /*
         各种符号对应类型，部分类型在新版SDK中有所变化，如long 和long long
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”


         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         因为在项目中用的类型不多，故只考虑了少数类型
         */

    }
    free(properties);

    return proNames;
}


/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients
{
    return [NSArray array];
}


- (void)setValues:(NSDictionary *)values{
    NSArray *keys = [values allKeys];
    for (NSString *key in keys) {
        [self setValue:values[key] forKey:key];
    }
}

@end
