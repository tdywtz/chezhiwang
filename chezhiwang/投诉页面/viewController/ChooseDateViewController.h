//
//  ChooseDateViewController.h
//  chezhiwang
//
//  Created by bangong on 16/11/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"
typedef void(^returnDate)(NSString *date);

@interface ChooseDateViewController : BasicViewController

@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) NSString *minimumDate;
@property (nonatomic,copy) NSString *maximumDate;
@property (nonatomic,copy) returnDate block;

-(void)returnDate:(returnDate)block;

-(void)showDatePicerView;
-(void)hiddenDatePicerView;

@end
