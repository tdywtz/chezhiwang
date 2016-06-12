//
//  InvestigateChangeViewController.h
//  chezhiwang
//
//  Created by bangong on 16/5/18.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@interface InvestigateChangeViewController : BasicViewController

@property (nonatomic,copy) void(^blcok)(NSString *name,NSString *ID);

-(void)returnChange:(void(^)(NSString *name,NSString *ID))block;

@end
