//
//  ChartRowModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartItemModel.h"

@interface ChartRowModel : NSObject

@property (nonatomic,strong) NSArray <__kindof ChartItemModel *> *itemModels;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,copy)   NSString *name;//每行左侧第一列”名字“

- (CGFloat)getCellHeight;

@end
