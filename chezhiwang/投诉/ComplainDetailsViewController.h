//
//  ComplainDetailsViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  投诉详情
 */
@interface ComplainDetailsViewController : BasicViewController

@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *textTitle;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSDictionary *dict;

@end
