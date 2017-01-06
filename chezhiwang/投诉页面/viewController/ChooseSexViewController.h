//
//  ChooseSexViewController.h
//  chezhiwang
//
//  Created by bangong on 16/11/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"
typedef void(^returnResult)(NSString *title, NSString *ID);

@interface ChooseSexViewController : BasicViewController

@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) returnResult block;
@property (nonatomic,strong) NSArray *dataArray;

-(void)returnResult:(returnResult)block;
-(void)showPickerView;
-(void)dismissView;

@end
