//
//  MyCarCell.h
//  auto
//
//  Created by bangong on 15/7/24.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) NSDictionary *dictCar;

@property (nonatomic,assign) NSInteger num;
@property (nonatomic,copy) void(^myBlock)(NSString *key,NSString *right);
@property (nonatomic,copy) void(^myCell)(MyCarCell *myCell,UITextField *cellTextField,NSInteger num);
@property (nonatomic,copy) void(^iconImage)(UIImageView *imageView);

-(void)getStr:(void(^)(NSString *key,NSString *right))block;
-(void)getCell:(void(^)(MyCarCell *myCell,UITextField *cellTextField,NSInteger num))block;
-(void)getIconImageView:(void(^)(UIImageView *imageView))block;

@end
