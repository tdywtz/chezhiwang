//
//  ChartChooseModel.m
//  chezhiwang
//
//  Created by bangong on 16/8/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartChooseModel.h"

@implementation ChartChooseModel

+ (NSArray *)initWithArray:(NSArray *)array type:(ChartChooseType)type{
    NSMutableArray *marr = [[NSMutableArray alloc] init];

    NSString *titleKey;
    NSString *tidKey;
    if (type == ChartChooseTypeAttributeBrand) {
        titleKey = @"name";
        tidKey   = @"brandAttr";
    }else if (type == ChartChooseTypeAttributeModel){

        titleKey = @"name";
        tidKey   = @"modelAttr";
    }else if (type == ChartChooseTypeAttributeSeries){
        titleKey = @"name";
        tidKey   = @"dep";
    }else if (type == ChartChooseTypeQuality){
        titleKey = @"name";
        tidKey   = @"zlwt";
    }
    for (NSDictionary *dict in array) {
        ChartChooseModel * model = [[ChartChooseModel alloc] init];
        model.tid = dict[tidKey];
        model.title = dict[titleKey];
        [marr addObject:model];

    }

    return marr;
}

@end
