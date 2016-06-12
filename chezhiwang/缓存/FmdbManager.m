//
//  FmdbManager.m
//  chezhiwang
//
//  Created by bangong on 15/9/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "FmdbManager.h"

@implementation FmdbManager
{
    FMDatabase *_dataBase;

}
//开启单例
+(FmdbManager *)shareManager{
    static FmdbManager *manager = nil;
    if (!manager) {
        manager = [[FmdbManager alloc] init];
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       NSString *Path = [NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:Path];
       // NSLog(@"%@",Path);
        [self createTableQuestion];
        [self createTableCollect];
        [self createTableReadHistory];
    }
    return self;
}

//问题类型，不做删除
-(void)createTableQuestion{
    if ([_dataBase open]) {
        NSString *question = @"create table if not exists question(id varchar(256) primary key unique,value varchar(256),name varchar(256),cid varchar(256),title varchar(256))";
        [_dataBase executeUpdate:question];
    }
}

-(void)createQuestion:(NSArray *)array{
   
    [_dataBase executeUpdate:@"delete from question"];//删除就数据
    for (NSDictionary *dict in array) {
        
        NSString *value = dict[@"value"];
        NSString *name = dict[@"name"];
        NSArray *subArray = dict[@"items"];
        
        [_dataBase beginTransaction];
        BOOL isRollBack = NO;
        @try {
            for (NSDictionary *subDict in subArray) {
                NSString *key = [NSString stringWithFormat:@"%@%@",value,subDict[@"id"]];
                NSString *sql =  @"insert into question(id,value,name,cid,title) values(?,?,?,?,?)";
                [_dataBase executeUpdate:sql,key,value,name,(NSString *)subDict[@"id"],subDict[@"title"]];
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_dataBase rollback];
        }
        @finally {
            if (!isRollBack) {
                [_dataBase commit];
            }
        }
    }
}

-(NSDictionary *)selectFormQuestion:(NSString *)key{
    NSString *sql = @"select * from question where id=?";
    FMResultSet *set = [_dataBase executeQuery:sql,key];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    while ([set next]) {
        [dic setObject:[set stringForColumn:@"value"] forKey:@"value"];
        [dic setObject:[set stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[set stringForColumn:@"cid"] forKey:@"id"];
        [dic setObject:[set stringForColumn:@"title"] forKey:@"title"];
    }
    return dic;
}

#pragma mark - 投诉
//创建表
-(void)createTableCollect{
    if ([_dataBase open]) {
        NSString *collect = @"create table if not exists collect(id varchar(256),time varchar(256),title varchar(256),type varchar(256))";
        BOOL create = [_dataBase executeUpdate:collect];
            if (create) {
              //  NSLog(@"sucess");
            }
    }
}

//插入数据
-(void)insertIntoCollectWithId:(NSString *)ID andTime:(NSString *)time andTitle:(NSString *)title andType:(collectType)type{
    NSString *sql =  @"insert into collect(id,time,title,type) values(?,?,?,?)";
    [_dataBase executeUpdate:sql,ID,time,title,[NSString stringWithFormat:@"%d",type]];
   
}

//查询某一类数据
-(NSArray *)selectAllFromCollect:(collectType)type{
    NSString *sql = @"select * from collect where type = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,[NSString stringWithFormat:@"%d",type]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([set next]) {
        [array addObject:@{@"id":[set stringForColumn:@"id"],@"time":[set stringForColumn:@"time"],@"title":[set stringForColumn:@"title"],@"type":[set stringForColumn:@"type"]}];
    }
    return array;
}

//
-(NSInteger)selectCollectNumber{
    return   [[FmdbManager shareManager] selectAllFromCollect:collectTypeAnswer].count+[[FmdbManager shareManager] selectAllFromCollect:collectTypeCompalin].count+[[FmdbManager shareManager] selectAllFromCollect:collectTypeNews].count;

}


//删除指定数据
-(void)deleteFromCollectWithId:(NSString *)ID andType:(collectType)type{
    NSString *sql = @"delete from collect where id = ? and type = ?";
   [_dataBase executeUpdate:sql,ID,[NSString stringWithFormat:@"%d",type]];
}

//查询指定数据
-(NSDictionary *)selectFromCollectWithId:(NSString *)ID andType:(collectType)type{
    NSString *sql = @"select * from collect where id = ? and type = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,ID,[NSString stringWithFormat:@"%d",type]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while ([set next]) {
        [dict setObject:[set stringForColumn:@"id"] forKey:@"id"];
        [dict setObject:[set stringForColumn:@"time"] forKey:@"time"];
        [dict setObject:[set stringForColumn:@"title"] forKey:@"title"];
    }
    return dict;
}

#pragma mark - 浏览记录
-(void)createTableReadHistory{
    if ([_dataBase open]) {
        NSString *readHistory = @"create table if not exists readHistory(id varchar(256) primary key NOT NULL,title varchar(256),type varchar(256))";
        [_dataBase executeUpdate:readHistory];
    }
}

-(void)insertIntoReadHistoryWithId:(NSString *)ID andTitle:(NSString *)title andType:(ReadHistoryType)type{
    NSString *sql =  @"insert into readHistory(id,title,type) values(?,?,?)";
    [self deleteFromReadHistory:ID];
    [_dataBase executeUpdate:sql,ID,title,[NSString stringWithFormat:@"%d",type]];
}

-(void)deleteFromReadHistory:(NSString *)ID{
    NSString *sql = @"delete from readHistory where id = ?";
    [_dataBase executeUpdate:sql,ID];
}

-(NSArray *)selectAllFromReadHistory:(ReadHistoryType)type{
    NSString *sql = @"select * from readHistory where type = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,[NSString stringWithFormat:@"%d",type]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([set next]) {
        [array addObject:@{@"id":[set stringForColumn:@"id"],@"title":[set stringForColumn:@"title"],@"type":[set stringForColumn:@"type"]}];
    }
    return array;
}

//删除表
-(void)dropTables{
    [_dataBase executeUpdate:@"drop table collect"];
    [_dataBase executeUpdate:@"drop table readHistory"];
}

////答疑
//-(void)insertIntoCollectAnswer:(NSDictionary *)dicionary;
//-(NSArray *)selectAllFromCollectAnswer;
//-(NSDictionary *)selectCollectFromCollectAnswer:(NSString *)ID;
//
////新闻
//-(void)insertIntoCollectNews:(NSDictionary *)dicionary;
//-(NSArray *)selectAllFromCollectNews;
//-(NSDictionary *)selectCollectFromCollectNews:(NSString *)ID;

////打开数据库
//-(void)openDataBase{
//
//}
////关闭数据库
//-(void)closeDataBase{
//
//}


@end
