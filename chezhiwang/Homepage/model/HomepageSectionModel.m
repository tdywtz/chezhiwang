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

#import "NewsViewController.h"
#import "ComplainListViewController.h"
#import "NewsInvestigateViewController.h"
#import "AnswerViewController.h"
#import "ForumViewController.h"

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
    newsSectionModel.footTitle = @"更多新闻";
    newsSectionModel.headLineColor = colorLightBlue;
    newsSectionModel.pushClass = [NewsViewController class];
    for (NSDictionary *dict in dictionary[@"news"]) {
        HomepageNewsModel * Model = [HomepageNewsModel mj_objectWithKeyValues:dict];

        [newsSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *complainSectionModel = [[HomepageSectionModel alloc] init];
    complainSectionModel.headTitle = @"投诉";
    complainSectionModel.headImageName = @"投诉";
    complainSectionModel.footTitle = @"更多投诉";
    complainSectionModel.headLineColor = colorYellow;
    complainSectionModel.pushClass = [ComplainListViewController class];
    for (NSDictionary *dict in dictionary[@"complain"]) {
        HomepageComplainModel * Model = [HomepageComplainModel mj_objectWithKeyValues:dict];
        [complainSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *researchSectionModel = [[HomepageSectionModel alloc] init];
    researchSectionModel.headTitle = @"调查";
    researchSectionModel.headImageName =@"调查";
    researchSectionModel.footTitle = @"更多调查";
    researchSectionModel.headLineColor = RGB_color(239, 95, 96, 1);
    researchSectionModel.pushClass = [NewsInvestigateViewController class];
    for (NSDictionary *dict in dictionary[@"report"]) {
        HomepageResearchModel * Model = [HomepageResearchModel mj_objectWithKeyValues:dict];
        [researchSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *answerSectionModel = [[HomepageSectionModel alloc] init];
    answerSectionModel.headTitle = @"答疑";
    answerSectionModel.headImageName = @"答疑";
    answerSectionModel.footTitle = @"更多答疑";
    answerSectionModel.headLineColor = RGB_color(0, 169, 75, 1);
    answerSectionModel.pushClass = [AnswerViewController class];
    for (NSDictionary *dict in dictionary[@"zjdy"]) {
        HomepageAnswerModel * Model = [HomepageAnswerModel mj_objectWithKeyValues:dict];
        [answerSectionModel.rowModels addObject:Model];
    }

    HomepageSectionModel *forumSectionModel = [[HomepageSectionModel alloc] init];
    forumSectionModel.headTitle = @"论坛";
    forumSectionModel.headImageName = @"论坛";
    forumSectionModel.footTitle = @"更多论坛";
    forumSectionModel.headLineColor = RGB_color(0, 159, 251, 1);
    forumSectionModel.pushClass = [ForumViewController class];
    for (NSDictionary *dict in dictionary[@"bbs"]) {
        HomepageForumModel * Model = [HomepageForumModel mj_objectWithKeyValues:dict];
        [forumSectionModel.rowModels addObject:Model];
    }


    return @[newsSectionModel,complainSectionModel,researchSectionModel,answerSectionModel,forumSectionModel];
}
@end
