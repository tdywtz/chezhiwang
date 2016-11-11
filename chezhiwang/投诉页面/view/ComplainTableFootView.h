//
//  ComplainTableFootView.h
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainTableFootView : UIView

@property (nonatomic,copy) void(^submit)(BOOL isEqual);

- (void)submit:(void (^)(BOOL isEqual))submit;

@end
