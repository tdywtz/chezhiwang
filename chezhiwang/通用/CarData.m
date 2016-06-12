//
//  CarData.m
//  auto
//
//  Created by bangong on 15/8/19.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CarData.h"

@implementation CarData

+(void)downloadProvince{
    [HttpRequest GET:[URLFile urlStringForPro] success:^(id responseObject) {
        if ([responseObject count] > 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject) {
                NSString *title = [dict[@"License_plate"] length] > 0?dict[@"License_plate"]:@"台";
                [array
                 addObject:@{@"id":dict[@"Id"],@"title":title,@"name":dict[@"Name"]}];
            }
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"province"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    } failure:^(NSError *error) {
        
    }];
}

+(NSArray *)readProvince{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"province"];
}
//质量投诉
+(NSArray *) getComplainQualityArray{
    NSArray *array = @[@"发动机",@"变速器",@"离合器",@"转向系统",@"制动系统",@"前后桥及悬挂系统",@"轮胎",@"车身附件及电器"];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        NSString *ID = [NSString stringWithFormat:@"%d",i];
        [marr addObject:@{@"id":ID,@"title":array[i]}];
    }
    return marr;
}
//服务问题投诉
+(NSArray *) getComplainServiceArray{
     NSArray *array = @[@"服务态度",@"人员技术",@"服务收费",@"承诺不兑现",@"销售欺诈",@"配件争议",@"其他问题"];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        NSString *ID = [NSString stringWithFormat:@"%d",i];
        [marr addObject:@{@"id":ID,@"title":array[i]}];
    }
    return marr;
}
//综合投诉
+(NSArray *) getComplainSumupArray{
   NSArray *array = @[@"发动机",@"变速器",@"离合器",@"转向系统",@"制动系统",@"前后桥及悬挂系统",@"轮胎",@"车身附件及电器",@"服务态度",@"人员技术",@"服务收费",@"承诺不兑现",@"销售欺诈",@"配件争议",@"其他问题"];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        NSString *ID = [NSString stringWithFormat:@"%d",i];
        [marr addObject:@{@"id":ID,@"title":array[i]}];
    }
    return marr;
}

@end
