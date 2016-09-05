//
//  VehicleSeriesSctionModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"
/**
 *  车系图片section模型
 */
@interface VehicleSeriesSctionModel : BasicObject
//第一组
@property (nonatomic,assign) NSInteger selectRow;//选择哪一行
@property (nonatomic,strong) NSArray  *serieslist;//车型数组

//第二组以下
@property (nonatomic,assign) BOOL open;//是否打开全部
@property (nonatomic,assign) NSInteger num;//数量
@property (nonatomic,copy)   NSString *typeName;
@property (nonatomic,strong) NSArray  *images;

@end
