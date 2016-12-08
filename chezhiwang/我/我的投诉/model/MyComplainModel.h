//
//  TheComplainModel.h
//  auto
//
//  Created by bangong on 15/6/17.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyComplainModel : NSObject

@property (nonatomic,copy) NSString *common;
@property (nonatomic,copy) NSString *Cpid;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *huifu;
@property (nonatomic,assign) BOOL    ispf;
@property (nonatomic,copy) NSString *pingfen;
@property (nonatomic,copy) NSString *show;
@property (nonatomic,copy) NSString *stars;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *stepid;
@property (nonatomic,strong) NSArray *steps;
@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) BOOL isOpen;
@end
