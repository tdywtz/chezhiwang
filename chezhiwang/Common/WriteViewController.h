//
//  WriteViewController.h
//  chezhiwang
//
//  Created by bangong on 16/10/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  回复输入框
 */
@interface WriteViewController : UIViewController

@property (nonatomic,copy) void(^sendBlick)(NSString *content);
@property (nonatomic,copy) NSString *labelText;
-(void)send:(void(^)(NSString *content))block;


@end
