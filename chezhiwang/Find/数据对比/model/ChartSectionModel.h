//
//  ChartSectionModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartRowModel.h"

@interface ChartSectionModel : NSObject

@property (nonatomic,strong) NSArray <__kindof ChartRowModel *> *rowModels;
@property (nonatomic,copy) NSString *name;//

@end
