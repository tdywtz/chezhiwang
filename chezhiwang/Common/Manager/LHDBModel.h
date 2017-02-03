//
//  LHDBModel.h
//  chezhiwang
//
//  Created by bangong on 17/2/3.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHDBModel : NSObject

@property (nonatomic, assign) int primaryId;
@property (nonatomic, assign) BOOL cct;
@property (nonatomic, assign) float ttt;
@property (nonatomic, strong) NSData *date;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, copy) NSString *str;
@property (nonatomic, strong) NSNumber *num;

+ (NSArray *)getPropertys;

- (void)setValues:(NSDictionary *)values;

@end
