//
//  ChooseViewController.h
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"

typedef enum {
    chooseTypeBrand,//品牌
    chooseTypeSeries,//车系
    chooseTypeModel,//车型
    chooseTypeComplainQuality,//质量投诉
    chooseTypeComplainService,//服务投诉
    chooseTypeComplainSumup,//综合
    chooseTypeBusiness//经销商
}chooseType;

typedef void(^returnResult)(NSString *title, NSString *ID);


@interface ChooseViewController : BasicViewController

@property (nonatomic,assign) chooseType choosetype;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *seriesId;
@property (nonatomic,copy) returnResult block;

-(void)retrunResults:(returnResult)block;
@end
