//
//  ChangeView.h
//  chezhiwang
//
//  Created by bangong on 15/11/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnChange)(NSString *name,NSString *ID);

@interface ChangeView : UIView

@property (nonatomic,copy) returnChange blcok;

-(void)returnChange:(returnChange)block;
@end
