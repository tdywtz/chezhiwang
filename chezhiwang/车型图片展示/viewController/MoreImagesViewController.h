//
//  MoreImagesViewController.h
//  chezhiwang
//
//  Created by bangong on 16/8/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"
#import "VehicleSeriesSctionModel.h"

@interface MoreImagesViewController : BasicViewController

@property (nonatomic,strong) VehicleSeriesSctionModel  *model;
@property (nonatomic,copy)   NSString *modelname;

@property (nonatomic,copy) NSString *mid;//当前分组车型id
@property (nonatomic,assign) NSInteger num;//记录当前分组之前所有分组的照片数量

@end
