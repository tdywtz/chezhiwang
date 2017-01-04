//
//  MyCarModel.h
//  chezhiwang
//
//  Created by bangong on 16/12/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCarModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *valueKey;
@property (nonatomic,copy) NSString *submitKey;
@property (nonatomic,copy) NSString *placeholder;

@property (assign,nonatomic) BOOL isEnable;

+ (instancetype)initWithName:(NSString *)name value:(NSString *)value valueKey:(NSString *)valueKey submitKey:(NSString *)submitKey placeholder:(NSString *)placeholder;

@end
