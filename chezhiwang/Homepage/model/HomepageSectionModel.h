//
//  HomepageSectionModel.h
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepageSectionModel : NSObject

@property (nonatomic,copy) NSString *headTitle;
@property (nonatomic,copy) NSString *headImageName;
@property (nonatomic,strong) UIColor *headLineColor;

@property (nonatomic,copy) NSString *footTitle;

@property (nonatomic,strong) NSMutableArray *rowModels;

+ (NSArray *)arrryWithDictionary:(NSDictionary *)dictionary;

@end
