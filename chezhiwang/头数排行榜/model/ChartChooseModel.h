//
//  ChartChooseModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"
#import "ChartChooseListViewController.h"

@interface ChartChooseModel : BasicObject

@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *title;

+ (NSArray *)initWithArray:(NSArray *)array type:(ChartChooseType)type;

@end
