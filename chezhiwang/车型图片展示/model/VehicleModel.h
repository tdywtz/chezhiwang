//
//  VehicleModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"

@interface VehicleModel : BasicObject

@property (nonatomic,copy)   NSString  *seriesname;
@property (nonatomic,copy)   NSString  *sid;
@property (nonatomic,copy)   NSString  *url;
@property (nonatomic,assign) NSInteger *num;


@end
