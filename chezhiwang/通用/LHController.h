//
//  LHController.h
//  auto
//
//  Created by bangong on 15/7/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LHController : NSObject
//设置字体
+ (CGFloat)setFont;
#pragma mark - 去掉逗号
+(NSString *)component:(NSString *)string andSubString:(NSString *)subString;
#pragma mark - UITextView
+(UITextField *)createTextFieldWithFrame:(CGRect)frame andBGImageName:(NSString *)name andPlaceholder:(NSString *)placeholder andTextFont:(CGFloat)size andSmallImageName:(NSString *)smallName andDelegate:(id)delegate;
+(UITextField *)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder Font:(CGFloat)font  Delegate:(id)delegate;
#pragma mark - 判断字符串是否为空
+(BOOL)judegmentSpaceChar:(NSString *)str;
#pragma mark - 判断字符串中是否只有汉字、字母。数字
+(BOOL)judegmentChar:(NSString *)str;
#pragma mark - 判断字符串中是否只有字母。数字
+(BOOL)judegmentCarNum:(NSString *)str;
#pragma mark - 判断时间大小
+(BOOL)judgementWithDateOneSmall:(NSString *)dateOne andDateTwo:(NSString *)dateTwo;

//complain2
#pragma mark - 创建圆心选择按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action;

/** - 黄色背景圆角按钮*/
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Font:(CGFloat)font Text:(NSString *)text;
/** - 自定义按钮*/
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Text:(NSString *)text;

/** - --创建Label*/
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Bold:(BOOL)bold TextColor:(UIColor *)color Text:(NSString*)text;
#define mark - 创建图片控制器
+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)name;

#pragma mark - 邮箱格式验证
+(BOOL)emailTest:(NSString *)email;

#pragma mark - alertview
+(void)alert:(NSString *)str;

//#pragma mark - 判断输入文字是否含有表情字符
//+ (BOOL)stringContainsEmoji:(NSString *)string;
//投诉item
+(UIBarButtonItem *)createComplainItemWthFrame:(CGRect)frame Target:(id)target Action:(SEL)action;
@end
