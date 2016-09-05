//
//  NewsTestTableViewModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"

@interface NewsTestTableViewModel : BasicObject

@property (nonatomic,copy) NSString  *ID;//
@property (nonatomic,copy) NSString  *gray;//灰色不能点击
@property (nonatomic,copy) NSString  *title;//标题
@property (nonatomic,copy) NSString  *maxImage;//左侧大图
@property (nonatomic,strong) NSArray *minImage;//小图数组
@property (nonatomic,strong) NSArray *desc;//描述数组
@property (nonatomic,assign) NSInteger descCurrent;//显示的描述所在数组下标

@end
