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

#pragma mark - class - ChooseSectionModel
@class ChooseViewModel;
@interface ChooseSectionModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray <ChooseViewModel *> *rowModels;

@end


#pragma mark - class - ChooseViewModel
@interface ChooseViewModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithID:(NSString *)ID title:(NSString *)title;

@end


#pragma mark - class - ChooseViewController
@interface ChooseViewController : BasicViewController

@property (nonatomic,assign) chooseType choosetype;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *seriesId;
@property (nonatomic,copy) returnResult block;

-(void)retrunResults:(returnResult)block;
@end
