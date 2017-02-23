//
//  LCReputationViewController.h
//  chezhiwang
//
//  Created by bangong on 17/2/6.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@interface LCReputationChangeView : UIView

@property (nonatomic, copy) void (^change)(NSInteger index);

@end


/**口碑*/
@interface LCReputationViewController : BasicViewController

@property (nonatomic,assign) UIEdgeInsets contentInsets;
@property (nonatomic,copy) NSString *sid;//车系

@end
