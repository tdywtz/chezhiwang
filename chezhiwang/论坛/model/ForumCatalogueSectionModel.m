//
//  ForumCatalogueSectionModel.m
//  chezhiwang
//
//  Created by bangong on 16/11/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumCatalogueSectionModel.h"

@implementation ForumCatalogueModel

@end


@implementation ForumCatalogueSectionModel

+ (NSArray *)arrayWithArray:(NSArray *)array{

    if ([array isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }

    [ForumCatalogueModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"title":@"name",@"ID":@"id"};
    }];
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {

        ForumCatalogueSectionModel *sectionModel = [[ForumCatalogueSectionModel alloc] init];
        sectionModel.title = dict[@"letter"];


        sectionModel.roeModels = [ForumCatalogueModel mj_objectArrayWithKeyValuesArray:dict[@"brand"]];

        [sections addObject:sectionModel];
    }

    return [sections copy];
}
@end
