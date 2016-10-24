//
//  FmdbManager.h
//  chezhiwang
//
//  Created by bangong on 15/9/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
//收藏
typedef enum {
    collectTypeNews = 0,//新闻
    collectTypeCompalin = 1,//投诉
    collectTypeAnswer = 2//答疑
}collectType;

//浏览记录
typedef enum {
    ReadHistoryTypeNews = 0,//浏览新闻
    ReadHistoryTypeForum = 1,//浏览论坛
    ReadHistoryTypeComplain = 2,//浏览的投诉
    ReadHistoryTypeAnswer = 3//浏览的答疑
}ReadHistoryType;

#define FmdbManagerInstance [FmdbManager shareManager]
@interface FmdbManager : NSObject

//收藏
-(void)createTableCollect;
-(void)insertIntoCollectWithId:(NSString *)ID  andTime:(NSString *)time andTitle:(NSString *)title andType:(collectType)type;
-(void)deleteFromCollectWithId:(NSString *)ID andType:(collectType)type;
-(NSArray *)selectAllFromCollect:(collectType)type;
-(NSInteger)selectCollectNumber;
-(NSDictionary *)selectFromCollectWithId:(NSString *)ID andType:(collectType)type;

//浏览记录
-(void)createTableReadHistory;
-(void)insertIntoReadHistoryWithId:(NSString *)ID andTitle:(NSString *)title andType:(ReadHistoryType)type;
-(NSArray *)selectAllFromReadHistory:(ReadHistoryType)type;



//删除表
-(void)dropTables;
//开启单例
+(FmdbManager *)shareManager;
@end
