//
//  HomepageSectionModel.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageSectionModel.h"
#import "HomepageNewsModel.h"
#import "HomepageComplainModel.h"
#import "HomepageResearchModel.h"
#import "HomepageAnswerModel.h"
#include "HomepageForumModel.h"

@implementation HomepageSectionModel

- (NSMutableArray *)rowModels{
    if (_rowModels == nil) {
        _rowModels = [[NSMutableArray alloc] init];
    }
    return _rowModels;
}

+ (NSArray *)arrryWithDictionary:(NSDictionary *)dictionary{

    HomepageSectionModel *newsSectionModel = [[HomepageSectionModel alloc] init];
    newsSectionModel.headTitle = @"新闻";
    newsSectionModel.headImageName = @"新闻";
    newsSectionModel.footTitle = @"=更多新闻";
    newsSectionModel.headLineColor = RGB_color(0, 159, 251, 1);
    for (NSDictionary *dict in dictionary[@"news"]) {
        HomepageNewsModel * Model = [[HomepageNewsModel alloc] initWithDictionary:dict];
        [newsSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *complainSectionModel = [[HomepageSectionModel alloc] init];
    complainSectionModel.headTitle = @"投诉";
    complainSectionModel.headImageName = @"投诉";
    complainSectionModel.footTitle = @"更多投诉";
    complainSectionModel.headLineColor = RGB_color(247, 162, 0, 1);
    for (NSDictionary *dict in dictionary[@"complain"]) {
        HomepageComplainModel * Model = [[HomepageComplainModel alloc] initWithDictionary:dict];
        [complainSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *researchSectionModel = [[HomepageSectionModel alloc] init];
    researchSectionModel.headTitle = @"调查";
    researchSectionModel.headImageName =@"调查";
    researchSectionModel.footTitle = @"更多调查";
    researchSectionModel.headLineColor = RGB_color(239, 95, 96, 1);
    for (NSDictionary *dict in dictionary[@"report"]) {
        HomepageResearchModel * Model = [[HomepageResearchModel alloc] initWithDictionary:dict];
        [researchSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *answerSectionModel = [[HomepageSectionModel alloc] init];
    answerSectionModel.headTitle = @"答疑";
    answerSectionModel.headImageName = @"答疑";
    answerSectionModel.footTitle = @"更多答疑";
    answerSectionModel.headLineColor = RGB_color(0, 169, 75, 1);
    for (NSDictionary *dict in dictionary[@"zjdy"]) {
        HomepageAnswerModel * Model = [[HomepageAnswerModel alloc] initWithDictionary:dict];
        [answerSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *forumSectionModel = [[HomepageSectionModel alloc] init];
    forumSectionModel.headTitle = @"论坛";
    forumSectionModel.headImageName = @"论坛";
    forumSectionModel.footTitle = @"更多论坛";
    forumSectionModel.headLineColor = RGB_color(0, 159, 251, 1);
    for (NSDictionary *dict in dictionary[@"bbs"]) {
        HomepageForumModel * Model = [[HomepageForumModel alloc] initWithDictionary:dict];
        [forumSectionModel.rowModels addObject:Model];
    }


    return @[newsSectionModel,complainSectionModel,researchSectionModel,answerSectionModel,forumSectionModel];
}
@end
