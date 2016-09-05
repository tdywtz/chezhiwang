//
//  NSMutableAttributedString+LH.h
//  LHLabel
//
//  Created by bangong on 16/6/30.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString (LH)

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

- (void)setFont:(UIFont*)font;
- (void)setFont:(UIFont*)font range:(NSRange)range;

- (void)setUnderlineStyle:(CTUnderlineStyle)style
                     modifier:(CTUnderlineStyleModifiers)modifier;
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                     modifier:(CTUnderlineStyleModifiers)modifier
                        range:(NSRange)range;
@end
