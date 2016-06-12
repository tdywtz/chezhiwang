//
//  RevokeComplainViewController.h
//  chezhiwang
//
//  Created by bangong on 16/5/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@interface RevokeComplainViewController : BasicViewController

@property (nonatomic,strong) NSMutableDictionary *dictionary;
@property (nonatomic,copy) NSString *cpid;
@property (nonatomic,copy) void (^success)();
@end
