//
//  LHLabel.h
//  autoService
//
//  Created by bangong on 16/5/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZWLabel : UILabel

@property (nonatomic,strong) NSMutableAttributedString *attributeString;

//文字四周间距
@property (nonatomic,assign) UIEdgeInsets     textInsets;
/**字距（0无效）*/
@property (nonatomic,assign) CGFloat          characterSpace;

//段落样式
///**换行模式*/
//@property (nonatomic,assign)    NSLineBreakMode lineBreakMode;
/**行距*/
@property (nonatomic,assign)    CGFloat         lineSpacing;
/**段落距离*/
@property(NS_NONATOMIC_IOSONLY) CGFloat         paragraphSpacing;
/**对其方式*/
@property(NS_NONATOMIC_IOSONLY) NSTextAlignment alignment;
/** 段落首行距离左边长度*/
@property(NS_NONATOMIC_IOSONLY) CGFloat         firstLineHeadIndent;
/**除去首行段落距离左边长度 */
@property(NS_NONATOMIC_IOSONLY) CGFloat         headIndent;
/**段落宽度*/
@property(NS_NONATOMIC_IOSONLY) CGFloat         tailIndent;
/**段落前空白距离*/
@property(NS_NONATOMIC_IOSONLY) CGFloat         paragraphSpacingBefore;

- (void)addColor:(UIColor *)color range:(NSRange)range;
@end
