//
//  LHLabel.h
//  LHLabel
//
//  Created by bangong on 16/6/30.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableAttributedString+LH.h"
#import "LHLabelTextStorage.h"

@protocol LHLabelDelegate <NSObject>
@optional
- (void)storage:(LHLabelTextStorage *)storage;

@end


@interface LHLabel : UIView

@property (nonatomic,copy)      NSString           *text;                    //普通文本
@property (nonatomic,copy)      NSAttributedString *attributedText;          //属性文本
@property (nonatomic,assign)    UIEdgeInsets        textInsets;              //文字四周间距
@property (nonatomic,assign)    CGFloat             preferredMaxLayoutWidth; //layout最大宽度

@property (nonatomic,weak)      id<LHLabelDelegate> delegate;   //代理

@property (nonatomic,strong)    UIFont   *font;               //字体
@property (nonatomic,strong)    UIColor  *textColor;          //文字颜色
@property (nonatomic,strong)    UIColor  *highlightColor;     //链接点击时背景高亮色
@property (nonatomic,strong)    UIColor  *linkColor;          //链接色
@property (nonatomic,strong)    UIColor  *shadowColor;        //阴影颜色
@property (nonatomic,assign)    CGSize    shadowOffset;       //阴影offset
@property (nonatomic,assign)    CGFloat   shadowBlur;         //阴影半径
@property (nonatomic,assign)    BOOL      underLineForLink;   //链接是否带下划线
@property (nonatomic,assign)    NSInteger numberOfLines;      //行数

@property (nonatomic,assign)    CTTextAlignment textAlignment;       //文字排版样式
@property (nonatomic,assign)    CTLineBreakMode lineBreakMode;       //LineBreakMode
@property (nonatomic,assign)    CGFloat         lineSpacing;         //行间距
@property (nonatomic,assign)    CGFloat         paragraphSpacing;    //段间距
@property(nonatomic,assign)     CGFloat         firstLineHeadIndent; //段落首行距离左边长度

//添加链接
- (void)addUrl:(NSURL *)url
         range:(NSRange)range;
//添加
- (void)addData:(id)data
         range:(NSRange)range;

//添加图片
- (void)addImage:(UIImage *)image
            data:(id)data
            size:(CGSize)size
           range:(NSRange)range;

- (void)addImage:(UIImage *)image
            data:(id)data
            size:(CGSize)size
          insets:(UIEdgeInsets)insets
           range:(NSRange)range;

//添加view
- (void)addView:(UIView *)view
           size:(CGSize)size
          range:(NSRange)range;


@end




