//
//  CustomCommentView.h
//  chezhiwang
//
//  Created by bangong on 16/1/13.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCommentView : UIView

@property (nonatomic,copy) void(^sendBlick)(NSString *content);
@property (nonatomic,copy) NSString *title;
-(void)send:(void(^)(NSString *content))block;

-(void)show;
@end
