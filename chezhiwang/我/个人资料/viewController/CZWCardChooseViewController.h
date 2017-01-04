//
//  CZWCardChooseViewController.h
//  autoService
//
//  Created by bangong on 15/12/4.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
@class MyCarModel;

typedef enum {
    cardChooseTypeName,//真实姓名
    cardChooseTypeSex,//性别
    cardChooseTypeBirth,//生日
    cardChooseTypeAge,//年龄
    cardChooseTypePhoneNumber,//手机号
    cardChooseTypeEmail,//邮箱地址
    cardChooseTypeTelephone,//固定电话
    cardChooseTypeQQ,//QQ号
    cardChooseTypeCompany,//公司
    cardChooseTypeProfessional,//职业
    cardChooseTypeBeGoodAt//擅长
}cardChooseType;

typedef void(^success)(NSString *updateKey, NSString *value);
/**
 *  修改个人信息
 */
@interface CZWCardChooseViewController : BasicViewController

@property (nonatomic,strong) MyCarModel *model;
@property (nonatomic,assign) cardChooseType choose;

@property (nonatomic,copy) success block;

-(void)success:(success)block;

@end
