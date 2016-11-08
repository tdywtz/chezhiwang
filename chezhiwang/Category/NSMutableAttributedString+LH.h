//
//  NSMutableAttributedString+LH.h
//  chezhiwang
//
//  Created by bangong on 16/11/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (LH)

/**字距（0无效）*/
@property (nonatomic,assign) CGFloat         lh_kern;
/**字体*/
@property (nonatomic,strong) UIFont         *lh_font;

//段落样式
/**行距*/
@property (nonatomic,assign) CGFloat        lh_linesSpacing;
/**段落距离*/
@property(nonatomic,assign) CGFloat         lh_paragraphSpacing;
/** 段落首行距离左边长度*/
@property(nonatomic,assign) CGFloat         lh_firstLineHeadIndent;
/**除去首行段落距离左边长度 */
@property(nonatomic,assign) CGFloat         lh_headIndent;
/**段落宽度*/
@property(nonatomic,assign) CGFloat         lh_tailIndent;
/**段落前空白距离*/
@property(nonatomic,assign) CGFloat         lh_paragraphSpacingBefore;

/**字距（0无效）*/
- (void)lh_setKern:(CGFloat)kern range:(NSRange)range;
- (CGFloat)lh_kernAt:(NSInteger)index;
/**字体*/

@end
