//
//  LHController.m
//  auto
//
//  Created by bangong on 15/7/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "LHController.h"

@implementation LHController

//设置字体
+ (CGFloat)setFont{
    return 17;
}

#pragma mark - 去掉逗号
+(NSString *)component:(NSString *)string andSubString:(NSString *)subString{
    
    NSArray *array = [string componentsSeparatedByString:subString];
    NSString *str = [array componentsJoinedByString:@"  "];
    return str;
}

#pragma mark - UITextView
+(UITextField *)createTextFieldWithFrame:(CGRect)frame andBGImageName:(NSString *)name andPlaceholder:(NSString *)placeholder andTextFont:(CGFloat)size andSmallImageName:(NSString *)smallName andDelegate:(id)delegate{

    UIImage *imge = [UIImage imageNamed:name];
    imge = [imge stretchableImageWithLeftCapWidth:8 topCapHeight:5];

    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setBackground:imge];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:size];
    //清除按钮
    textField.clearButtonMode=YES;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
    
    
    if (smallName) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-18, 4, 11, frame.size.height-8)];
        image.image =[UIImage imageNamed:smallName];
        [textField addSubview:image];
    }
    
    if (delegate) {
        textField.delegate = delegate;
    }
    textField.backgroundColor = [UIColor whiteColor];
    return textField;
}

+(UITextField *)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString *)placeholder Font:(CGFloat)font Delegate:(id)delegate{

    
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.placeholder = placeholder;
    field.font = [UIFont systemFontOfSize:font];
    field.clearButtonMode = YES;
    field.textColor = colorBlack;
    //关闭首字母大写
    field.autocapitalizationType = NO;
    field.delegate = delegate;
   // UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)];
    field.leftViewMode = UITextFieldViewModeAlways;
   // field.leftView = leftview;

    return field;
}

#pragma mark - 判断字符串是否为空
+(BOOL)judegmentSpaceChar:(NSString *)str{
  //  = [str componentsSeparatedByString:@" "];
    NSArray *array = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n "]];
    for (NSString *string in array) {
       // NSLog(@"%@",string);
        if (string.length > 0) return YES;
    }
    return NO;
}

#pragma mark - 判断字符串中是否只有汉字、字母。数字
+(BOOL)judegmentChar:(NSString *)str{
//    for (int i = 0; i < str.length; i ++) {
//    
//        unichar c = [str characterAtIndex:i];
//      //const  char *han = [[str substringFromIndex:i] UTF8String];
//        if (!(c > 0x4e00 && c < 0x9fff)) {
//            if (!(c >= '0' && c <= '9')) {
//                if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))) {
//                      return NO;
//                }
//              
//            }
//        }
//   
//    }
//    return YES;
    NSString * regex = @"^[\u4e00-\u9fa5A-Za-z0-9\u3000-\u301e\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee]{0,25}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

#pragma mark - 判断字符串中是否只有字母。数字
+(BOOL)judegmentCarNum:(NSString *)str{
    for (int i = 0; i < str.length; i ++) {
        
        unichar c = [str characterAtIndex:i];
        if (!isdigit(c) && !isalpha(c)) {
            return NO;
        }
     
    }
    return YES;
}

#pragma mark - 判断时间大小
+(BOOL)judgementWithDateOneSmall:(NSString *)dateOne andDateTwo:(NSString *)dateTwo{
    NSArray *array1 = [dateOne componentsSeparatedByString:@"-"];
    NSArray *array2 = [dateTwo componentsSeparatedByString:@"-"];
    if ([array1[0] integerValue] > [array2[0] integerValue]) {
        return YES;
    }else if([array1[0] integerValue] == [array2[0] integerValue]){
        if ([array1[1] integerValue] > [array2[1] integerValue]) {
            return YES;
        }else if ([array1[1] integerValue] == [array2[1] integerValue]){
            if ([array1[2] integerValue] > [array2[2] integerValue]) {
                return YES;
            }
        }
    }
    
    return NO;
}


#pragma mark - 创建圆心选择按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:@"circlekong.jpg"] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"circleshi.jpg"] forState:UIControlStateSelected];
   // [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGPoint point = CGPointMake(btn.center.x, btn.center.y);
    btn.frame = CGRectMake(0, 0, frame.size.height/1.7, frame.size.height/1.7);
    btn.center = point;
    
//    //设置圆角
//    btn.layer.cornerRadius = 2;
//    btn.layer.masksToBounds = YES;
//    
    return btn;
}

#pragma mark - 黄色背景圆角按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Font:(CGFloat)font Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    btn.backgroundColor = colorYellow;
    btn.layer.cornerRadius = 3;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    btn.layer.masksToBounds = YES;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - 自定义按钮
+(UIButton *)createButtnFram:(CGRect)frame Target:(id)target Action:(SEL)action Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Bold:(BOOL)bold TextColor:(UIColor *)color Text:(NSString*)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    if (color) {
        label.textColor = color;
    }
    if (bold == YES) {
        label.font = [UIFont boldSystemFontOfSize:font];
    }
    label.numberOfLines = 0;
    return label;
}

#pragma mark - 创建图片控制器
+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)name{
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:frame];
    iamgeView.image = [UIImage imageNamed:name];
    return iamgeView;
}


#pragma mark - 邮箱格式验证
+(BOOL)emailTest:(NSString *)email{

    
    if (![email hasSuffix:@".com"] && ![email hasSuffix:@".cn"]) {
        return NO;
    }
    NSArray *aray = [email componentsSeparatedByString:@"@"];
    if (aray.count != 2) {
        return NO;
    }
   
    return YES;
}


#pragma mark - alertview
+(void)alert:(NSString *)str{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [al show];

        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            [al dismissWithClickedButtonIndex:0 animated:YES];
        });

    });
}

//#pragma mark - 判断输入文字是否含有表情字符
//+ (BOOL)stringContainsEmoji:(NSString *)string {
//    return NO;
//    __block BOOL returnValue = NO;
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
//     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//         
//         const unichar hs = [substring characterAtIndex:0];
//         // surrogate pair
//         if (0xd800 <= hs && hs <= 0xdbff) {
//             if (substring.length > 1) {
//                 const unichar ls = [substring characterAtIndex:1];
//                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                 if (0x1d000 <= uc && uc <= 0x1f77f) {
//                     returnValue = YES;
//                 }
//             }
//         } else if (substring.length > 1) {
//             const unichar ls = [substring characterAtIndex:1];
//             if (ls == 0x20e3) {
//                 returnValue = YES;
//             }
//             
//         } else {
//             // non surrogate
//             if (0x2100 <= hs && hs <= 0x27ff) {
//                 returnValue = YES;
//             } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                 returnValue = YES;
//             } else if (0x2934 <= hs && hs <= 0x2935) {
//                 returnValue = YES;
//             } else if (0x3297 <= hs && hs <= 0x3299) {
//                 returnValue = YES;
//             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                 returnValue = YES;
//             }
//         }
//     }];
//    
//    return returnValue;
//}

//我要投诉按钮
+(UIBarButtonItem *)createComplainItemWthFrame:(CGRect)frame Target:(id)target Action:(SEL)action{
    UIButton *btn = [self createButtnFram:frame Target:target Action:action Text:@"我要投诉"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 16, 14)];
    imageView.image = [UIImage imageNamed:@"complain_complain"];
    [btn addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

@end
