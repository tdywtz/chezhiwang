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


    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in array) {
        NSString *key = dict[@"letter"];
        NSMutableArray *mArr = dictionary[key];
        if (mArr == nil) {
            mArr = [[NSMutableArray alloc] init];
        }
        [mArr addObject:dict];
        [dictionary setObject:mArr forKey:key];
    }


    NSMutableArray *sections = [[NSMutableArray alloc] init];
    for (int i = 'A'; i <= 'Z'; i ++) {
        NSString *key = [NSString stringWithFormat:@"%c",i];
        if (dictionary[key] == nil) {
            continue;
        }
        ForumCatalogueSectionModel *sectionModel = [[ForumCatalogueSectionModel alloc] init];
        sectionModel.title = key;

        NSMutableArray *rows = [NSMutableArray array];
        for (NSDictionary *subDict in dictionary[key]) {
            ForumCatalogueModel *model = [[ForumCatalogueModel alloc] init];
            model.title = subDict[@"bname"];
            model.ID = subDict[@"bid"];

            ForumCatalogueSectionModel *sonSectionModel = [[ForumCatalogueSectionModel alloc] init];
            sonSectionModel.title = subDict[@"bname"];
            NSMutableArray *sons = [NSMutableArray array];
            for (NSDictionary *sonDict in subDict[@"series"]) {
                ForumCatalogueModel *sonModel = [[ForumCatalogueModel alloc] init];
                sonModel.title = sonDict[@"sname"];
                sonModel.ID = sonDict[@"sid"];
                [sons addObject:sonModel];
            }
            sonSectionModel.roeModels = sons;
            model.sections = @[sonSectionModel];

            [rows addObject:model];

        }

        sectionModel.roeModels = rows;

        [sections addObject:sectionModel];
    }

    return [sections copy];
}
@end
