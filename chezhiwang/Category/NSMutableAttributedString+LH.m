\
//
//  NSMutableAttributedString+LH.m
//  chezhiwang
//
//  Created by bangong on 16/11/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NSMutableAttributedString+LH.h"

@implementation NSMutableAttributedString (LH)

#pragma mark - sets
- (void)setLh_kern:(CGFloat)lh_kern{
    [self lh_setKern:lh_kern range:NSMakeRange(0, self.length)];
}

#pragma mark - gets
- (CGFloat)lh_kern{
    return [self lh_kernAt:0];
}

#pragma mark - 
- (void)lh_setKern:(CGFloat)kern range:(NSRange)range{
    [self lh_setAttribute:NSKernAttributeName value:@(kern) range:range];
}

- (CGFloat)lh_kernAt:(NSInteger)index{
    NSNumber *kk = [self lh_attribute:NSKernAttributeName index:index];
    return [kk floatValue];
}

/**
 返回指定属性

 @param attribute <#attribute description#>
 @param index <#index description#>
 @return <#return value description#>
 */
- (id)lh_attribute:(NSString *)attribute index:(NSInteger)index{
    if (self.length == 0) {
        return nil;
    }
    if (index == self.length) {
        index --;
    }
  return  [self attribute:attribute atIndex:index effectiveRange:nil];
}


/**
 设置属性

 @param attribute <#attribute description#>
 @param value <#value description#>
 @param range <#range description#>
 */
- (void)lh_setAttribute:(NSString *)attribute value:(id)value range:(NSRange)range{
    if (attribute == nil) {
        return;
    }
    if (value == nil) {
        [self removeAttribute:attribute range:range];
    }else{
        [self addAttribute:attribute value:value range:range];
    }
}
@end
