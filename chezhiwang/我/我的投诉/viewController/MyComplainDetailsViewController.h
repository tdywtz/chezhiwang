//
//  ComplainDetailsViewController.h
//  auto
//
//  Created by bangong on 15/6/11.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
#import "MyComplainModel.h"
/**
 *  投诉详情
 */
@interface MyComplainDetailsViewController : BasicViewController

@property (nonatomic,copy) NSString *Cpid;


- (void)updateLayout:(BOOL)showLeft;
-(void)changeClick:(NSString *)title;
-(void)submitStar:(NSInteger)star;

@end
