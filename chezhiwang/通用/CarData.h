//
//  CarData.h
//  auto
//
//  Created by bangong on 15/8/19.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarData : NSObject

+ (void) downloadProvince;


//+(NSArray *) readeCarBrand;
+(NSArray *) readProvince;


//
//+(NSArray *) getComplainQualityArray;//质量投诉
//+(NSArray *) getComplainServiceArray;//服务问题投诉
//+(NSArray *) getComplainSumupArray;//综合投诉
@end
