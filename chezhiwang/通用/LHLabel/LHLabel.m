

//
//  LHLabel.m
//  LHLabel
//
//  Created by bangong on 16/6/30.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHLabel.h"
#import <CoreText/CoreText.h>

NSString *const kLHTextRunAttributedName = @"kLHTextRunAttributedName";
static NSString* const kEllipsesCharacter = @"\u2026";

static inline CGSize CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(CTFramesetterRef framesetter, NSAttributedString *attributedString, CGSize size, NSUInteger numberOfLines) {

    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
    CGSize constraints = CGSizeMake(size.width, CGFLOAT_MAX);

    if (numberOfLines > 0) {
        // If the line count of the label more than 1, limit the range to size to the number of lines that have been set
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, constraints.width, CGFLOAT_MAX));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);

        if (CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);

            CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }

        CFRelease(frame);
        CFRelease(path);
    }

    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);

    return CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
}



@interface LHLabel ()
{
    CTFrameRef                  _frameRef;
    CGFloat                     _fontAscent;
    CGFloat                     _fontDescent;
    CGFloat                     _fontHeight;
}
@property (nonatomic,strong)    NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSDictionary  *runRectDictionary;  // runRect字典
@property (nonatomic,strong) NSMutableArray<__kindof LHLabelTextStorage *> *textStorages;
@property (nonatomic,strong) LHLabelTextStorage *touchedStorage;

@end

@implementation LHLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    if (_frameRef)
    {
        CFRelease(_frameRef);
    }
    
}

#pragma mark - 初始化
- (void)setup
{
    _attributedString       = [[NSMutableAttributedString alloc]init];

    _frameRef              = nil;
    _linkColor              = [UIColor blueColor];
    _font                   = [UIFont systemFontOfSize:15];
    _textColor              = [UIColor blackColor];
    _highlightColor         = [UIColor colorWithRed:0xd7/255.0
                                              green:0xf2/255.0
                                               blue:0xff/255.0
                                              alpha:1];
    _lineBreakMode          = kCTLineBreakByWordWrapping;
    _underLineForLink       = YES;
    _lineSpacing            = 0.0;
    _paragraphSpacing       = 0.0;
    _textStorages           = [[NSMutableArray alloc] init];

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self resetFont];
}

- (void)resetFont
{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    if (fontRef)
    {
        _fontAscent     = CTFontGetAscent(fontRef);
        _fontDescent    = CTFontGetDescent(fontRef);
        _fontHeight     = CTFontGetSize(fontRef);
        CFRelease(fontRef);
    }
}

- (NSMutableAttributedString *)attributedStringForDrawWithText:(NSString *)text
{
    if (text)
    {
        //添加排版格式
        NSMutableAttributedString *drawString = [[NSMutableAttributedString alloc] initWithString:text];

        [drawString setFont:_font];
        [drawString setTextColor:_textColor];
        
        //如果LineBreakMode为TranncateTail,那么默认排版模式改成kCTLineBreakByCharWrapping,使得尽可能地显示所有文字
        CTLineBreakMode lineBreakMode = self.lineBreakMode;
        if (self.lineBreakMode == kCTLineBreakByTruncatingTail)
        {
            lineBreakMode = _numberOfLines == 1 ? kCTLineBreakByCharWrapping : kCTLineBreakByWordWrapping;
        }
        CGFloat fontLineHeight = self.font.lineHeight;  //使用全局fontHeight作为最小lineHeight


        CTParagraphStyleSetting settings[] =
        {
            {kCTParagraphStyleSpecifierAlignment,sizeof(_textAlignment),&_textAlignment},
            {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreakMode),&lineBreakMode},
            {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(_lineSpacing),&_lineSpacing},
            {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(_lineSpacing),&_lineSpacing},
            {kCTParagraphStyleSpecifierParagraphSpacing,sizeof(_paragraphSpacing),&_paragraphSpacing},
            {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(fontLineHeight),&fontLineHeight},
            {kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(_firstLineHeadIndent),&_firstLineHeadIndent},
        };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings,sizeof(settings) / sizeof(settings[0]));
        [drawString addAttribute:(id)kCTParagraphStyleAttributeName
                           value:(__bridge id)paragraphStyle
                           range:NSMakeRange(0, [drawString length])];
        CFRelease(paragraphStyle);


        return drawString;
    }
    else
    {
        return nil;
    }
}

#pragma mark - sets
- (void)setText:(NSString *)text{

    if (_text != text) {
        _text = text;
        self.attributedString = [self attributedStringForDrawWithText:text];
        self.attributedText = self.attributedString;
    }
}

- (void)setFont:(UIFont *)font{
    if (_font != font) {
        _font = font;
        [self resetFont];
        if (self.attributedString) {
            [self.attributedString setFont:font];
            self.attributedText = self.attributedString;
        }
    }
}

- (void) setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        _textColor  = textColor;
        if (self.attributedString) {
            [self.attributedString setTextColor:textColor];
            self.attributedText = self.attributedString;
        }
    }
}
- (void)setAttributedText:(NSAttributedString *)attributedText{
    if (_attributedText != attributedText) {
         _attributedText = attributedText;
        [self setNeedsDisplay];
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - coretext
//更新'_frameRef'
- (void)updateFramRefWithSize:(CGSize)size{
    if (_frameRef) {
        CFRelease(_frameRef);
    }
    NSAttributedString *att = [_attributedText copy];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)att);
    _frameRef = [self createFrameRefWithFramesetter:framesetter textSize:size attribute:att];

    CFRelease(framesetter);
    [self saveTextStorageRectWithFrame:_frameRef width:size.width+self.textInsets.left+self.textInsets.right];
}

- (void)saveTextStorageRectWithFrame:(CTFrameRef)frame width:(CGFloat)viewWidth
{
    // 获取每行
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);

    NSInteger numberOfLines = _numberOfLines > 0 ? MIN(_numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);

    NSMutableDictionary *runRectDictionary = [NSMutableDictionary dictionary];

    // 获取每行有多少run
    for (int i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);

        CFArrayRef runs = CTLineGetGlyphRuns(line);
        // 获得每行的run
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            // run的属性字典
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)attributes[(id)kCTRunDelegateAttributeName];

            if (delegate) {
                 LHLabelTextStorage* attributedImage = (LHLabelTextStorage *)CTRunDelegateGetRefCon(delegate);
                CGFloat runWidth  = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);

                if (viewWidth > 0 && runWidth > viewWidth) {
                    runWidth  = viewWidth;
                }
                CGRect runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL),lineOrigin.y - runDescent, runWidth, runAscent + runDescent);


                [runRectDictionary setObject:attributedImage forKey:[NSValue valueWithCGRect:runRect]];
            }
        }
    }


    if (runRectDictionary.count > 0) {
        // 添加响应点击rect
        _runRectDictionary = [runRectDictionary copy];
    }
}

-  (CTFrameRef)createFrameRefWithFramesetter:(CTFramesetterRef)framesetter textSize:(CGSize)textSize attribute:(NSAttributedString *)attribute
{
    // 这里你需要创建一个用于绘制文本的路径区域,通过 self.bounds 使用整个视图矩形区域创建 CGPath 引用。
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, textSize.width, textSize.height));

    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attribute.length), path, NULL);
    CFRelease(path);
    return frameRef;
}

- (LHLabelTextStorage *)storageForpoint:(CGPoint)point ViewHeight:(CGFloat)viewHeight{
    if (_frameRef == nil) {
        return nil;
    }
    // 获取每行
    CFArrayRef lines = CTFrameGetLines(_frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), lineOrigins);
    CGFloat viewWidth = self.bounds.size.width;

    NSInteger numberOfLines = _numberOfLines > 0 ? MIN(_numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    CGAffineTransform transform =  CGAffineTransformScale(CGAffineTransformMakeTranslation(0,viewHeight), 1.f, -1.f);
    // 获取每行有多少run
    for (int i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);

        CFArrayRef runs = CTLineGetGlyphRuns(line);
        // 获得每行的run
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            // run的属性字典
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)attributes[(id)kCTRunDelegateAttributeName];


            if (delegate) {

                CGFloat runWidth  = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
               LHLabelTextStorage * TextStorage = (LHLabelTextStorage *)CTRunDelegateGetRefCon(delegate);
                if (viewWidth > 0 && runWidth > viewWidth) {
                    runWidth  = viewWidth;
                }
                CGRect runRect = CGRectMake(self.textInsets.left+lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runWidth, runAscent + runDescent);
                 CGRect rect = CGRectApplyAffineTransform(runRect, transform);
                rect = UIEdgeInsetsInsetRect(rect, TextStorage.insets);
                rect.origin.y -= self.textInsets.bottom;
                // point 是否在rect里
                if(CGRectContainsPoint(rect, point)){

                    return TextStorage;
                }

            }

            LHLabelTextStorage *linkStorage = (LHLabelTextStorage *)attributes[kLHTextRunAttributedName];

            if (linkStorage) {
                CFRange range = CTRunGetStringRange(run);
                CGFloat runWidth  = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, NULL);

                if (viewWidth > 0 && runWidth > viewWidth) {
                    runWidth  = viewWidth;
                }
                CGRect runRect = CGRectMake(self.textInsets.left+lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL),lineOrigin.y - runDescent, runWidth, runAscent + runDescent);
                CGRect rect = CGRectApplyAffineTransform(runRect, transform);
                rect.origin.y -= self.textInsets.bottom;
                // point 是否在rect里
                if(CGRectContainsPoint(rect, point)){
                    linkStorage.drawRect = runRect;

                    linkStorage.range = NSMakeRange(range.location, 20);
                    return linkStorage;
                }

            }
        }
    }
    return nil;
}

- (NSRange)drawRange{
    if (_frameRef == nil) {
        return NSMakeRange(0, 0);
    }
    // 获取每行
    CFArrayRef lines = CTFrameGetLines(_frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), lineOrigins);

    NSRange mageRange = NSMakeRange(0, 0);
    NSInteger numberOfLines = _numberOfLines > 0 ? MIN(_numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);

    // 获取每行有多少run
    for (int i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);

        CFArrayRef runs = CTLineGetGlyphRuns(line);
        // 获得每行的run
        for (int j = 0; j < CFArrayGetCount(runs); j++) {

            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            // run的属性字典
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);

            LHLabelTextStorage *linkStorage = (LHLabelTextStorage *)attributes[kLHTextRunAttributedName];

            if (linkStorage) {

                if ([linkStorage isEqual:self.touchedStorage]) {
                    CFRange range  = CTRunGetStringRange(run);
                    if (mageRange.length == 0) {
                        mageRange = NSMakeRange(range.location, range.length);
                    }else{
                        mageRange.length += range.length;
                    }
                }

            }
        }
    }
    return mageRange;
}

#pragma mark - views
-(CGSize)intrinsicContentSize{

    if (!_attributedText) {
        return CGSizeZero;
    }
    NSAttributedString *atttibuted = [_attributedText copy];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)atttibuted);
    CGSize  size = CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(framesetter, atttibuted, CGSizeMake(_preferredMaxLayoutWidth-self.textInsets.left-self.textInsets.right,CGFLOAT_MAX), (NSUInteger)self.numberOfLines);
    CFRelease(framesetter);

    [self updateFramRefWithSize:size];

    return CGSizeMake(size.width+self.textInsets.left+self.textInsets.right, size.height+self.textInsets.top+self.textInsets.bottom);
}




- (void)drawRect:(CGRect)rect{
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.textInsets);
    
    if (_frameRef == nil) {
        [self updateFramRefWithSize:insetRect.size];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, self.textInsets.left,insetRect.size.height+self.textInsets.top);
    CGContextScaleCTM(context, 1.0, -1.0);


    [self drawSelectionAreaFrame:_frameRef InRange:[self drawRange] bgColor:self.highlightColor];
    [self drawShadow:context];  // 画阴影
    [self drawText:_attributedText frame:_frameRef rect:insetRect context:context]; // CTFrameDraw 将 frame 描述到设备上下文
    [self drawTextStorage];  // 画其他元素

}
// 绘画选择区域
- (void)drawSelectionAreaFrame:(CTFrameRef)frameRef InRange:(NSRange)selectRange bgColor:(UIColor *)bgColor{
    NSInteger selectionStartPosition = selectRange.location;
    NSInteger selectionEndPosition = NSMaxRange(selectRange);
    if (!_touchedStorage) {
        return;
    }
    if (selectionStartPosition < 0 || selectRange.length <= 0 || selectionEndPosition > self.attributedText.length) {
        return;
    }

    CFArrayRef lines = CTFrameGetLines(frameRef);
    if (!lines) {
        return;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
       // linePoint.x += self.textInsets.left;
       // linePoint.y -= self.textInsets.top;

        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:selectionStartPosition inRange:range] && [self isPosition:selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect bgColor:bgColor];
            break;
        }

        // 2. start和end不在一个line
        // 2.1 如果start在line中，则填充Start后面部分区域
        if ([self isPosition:selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect bgColor:bgColor];
        } // 2.2 如果 start在line前，end在line后，则填充整个区域
        else if (selectionStartPosition < range.location && selectionEndPosition >= range.location + range.length) {
            CGFloat ascent, descent, leading, width;
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, width, ascent + descent);
            [self fillSelectionAreaInRect:lineRect bgColor:bgColor];
        } // 2.3 如果start在line前，end在line中，则填充end前面的区域,break
        else if (selectionStartPosition < range.location && [self isPosition:selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, selectionEndPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect bgColor:bgColor];
        }
    }
}

- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range {
    return (position >= range.location && position < range.location + range.length);
}

- (void)fillSelectionAreaInRect:(CGRect)rect bgColor:(UIColor *)bgColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
}



//- (void)drawHighlightWithRect:(CGRect)rect
//{
//    if (self.touchedStorage && self.highlightColor)
//    {
//        if (CGRectEqualToRect(self.touchedStorage.drawRect, CGRectZero)) {
//            return;
//        }
//        [self.highlightColor setFill];
//        CGRect highlightRect = self.touchedStorage.drawRect;
//                CGContextRef ctx = UIGraphicsGetCurrentContext();
//                CGFloat pi = (CGFloat)M_PI;
//
//                CGFloat radius = 1.0f;
//                CGContextMoveToPoint(ctx, highlightRect.origin.x, highlightRect.origin.y + radius);
//                CGContextAddLineToPoint(ctx, highlightRect.origin.x, highlightRect.origin.y + highlightRect.size.height - radius);
//                CGContextAddArc(ctx, highlightRect.origin.x + radius, highlightRect.origin.y + highlightRect.size.height - radius,
//                                radius, pi, pi / 2.0f, 1.0f);
//                CGContextAddLineToPoint(ctx, highlightRect.origin.x + highlightRect.size.width - radius,
//                                        highlightRect.origin.y + highlightRect.size.height);
//                CGContextAddArc(ctx, highlightRect.origin.x + highlightRect.size.width - radius,
//                                highlightRect.origin.y + highlightRect.size.height - radius, radius, pi / 2, 0.0f, 1.0f);
//                CGContextAddLineToPoint(ctx, highlightRect.origin.x + highlightRect.size.width, highlightRect.origin.y + radius);
//                CGContextAddArc(ctx, highlightRect.origin.x + highlightRect.size.width - radius, highlightRect.origin.y + radius,
//                                radius, 0.0f, -pi / 2.0f, 1.0f);
//                CGContextAddLineToPoint(ctx, highlightRect.origin.x + radius, highlightRect.origin.y);
//                CGContextAddArc(ctx, highlightRect.origin.x + radius, highlightRect.origin.y + radius, radius,
//                                -pi / 2, pi, 1);
//                CGContextFillPath(ctx);
//
//    }
//
//}


// 画阴影
- (void)drawShadow:(CGContextRef)context{
    if (self.shadowColor){
      CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowBlur, self.shadowColor.CGColor);
    }
}

// CTFrameDraw 将 frame 描述到设备上
// this code quote M80AttributedLabel
- (void)drawText: (NSAttributedString *)attributedString
           frame:(CTFrameRef)frame
            rect: (CGRect)rect
         context: (CGContextRef)context
{
    if (self.numberOfLines > 0)
    {
        CFArrayRef lines = CTFrameGetLines(frame);
        NSInteger numberOfLines = MIN(self.numberOfLines, CFArrayGetCount(lines));

        CGPoint lineOrigins[numberOfLines];
        CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);

        BOOL truncateLastLine = (self.lineBreakMode == NSLineBreakByTruncatingTail);

        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
        {
            CGPoint lineOrigin = lineOrigins[lineIndex];
            CGContextSetTextPosition(context, lineOrigin.x+self.textInsets.left, lineOrigin.y+self.textInsets.top);
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);

            BOOL shouldDrawLine = YES;
            if (lineIndex == numberOfLines - 1 && truncateLastLine)
            {
                // Does the last line need truncation?

                CFRange lastLineRange = CTLineGetStringRange(line);

                if (lastLineRange.location + lastLineRange.length < attributedString.length)
                {
                    CTLineTruncationType truncationType = kCTLineTruncationEnd;
                    NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;

                    NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
                    NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter attributes:tokenAttributes];
                    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);

                    NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];

                    if (lastLineRange.length > 0)
                    {
                        // Remove last token
                        [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                    }
                    //[truncationString replaceCharactersInRange:NSMakeRange(lastLineRange.length-1, 1) withAttributedString:tokenString];
                    [truncationString appendAttributedString:tokenString];


                    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationString);
                    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                    if (!truncatedLine)
                    {
                        // If the line is not as wide as the truncationToken, truncatedLine is NULL
                        truncatedLine = CFRetain(truncationToken);
                    }
                    CFRelease(truncationLine);
                    CFRelease(truncationToken);
                    CTLineDraw(truncatedLine, context);
                    CFRelease(truncatedLine);

                    shouldDrawLine = NO;
                }
            }
            if(shouldDrawLine)
            {
                CTLineDraw(line, context);
            }
        }
    }
    else
    {
        CTFrameDraw(frame,context);
    }
}


- (void)drawTextStorage
{
    [_runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, LHLabelTextStorage * obj, BOOL * _Nonnull stop) {

        if ([obj.draw isKindOfClass:[UIImage class]]) {
            CGRect frame = [key CGRectValue];
            UIEdgeInsets insets = UIEdgeInsetsMake(obj.insets.bottom, obj.insets.left, obj.insets.top, obj.insets.right);
            frame = UIEdgeInsetsInsetRect(frame, insets);

            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextDrawImage(context, frame, ((UIImage *)obj.draw).CGImage);
        }else{
            CGRect frame = [key CGRectValue];
            frame.origin.y = self.bounds.size.height-frame.origin.y-frame.size.height-self.textInsets.top;
            frame.origin.x += self.textInsets.left;
            UIView *view = (UIView*)obj.draw;
            view.frame = frame;
        }
    }];
}

#pragma mark - touchs

//接受触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    self.touchedStorage = [self storageForpoint:location ViewHeight:self.bounds.size.height];
    if (self.touchedStorage) {
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    if (self.touchedStorage) {
        CGAffineTransform transform =  CGAffineTransformScale(CGAffineTransformMakeTranslation(0,self.bounds.size.height), 1.f, -1.f);
        CGRect rect = CGRectApplyAffineTransform(self.touchedStorage.drawRect, transform);

        if (!CGRectContainsPoint(rect, location)) {
             self.touchedStorage = nil;
            [self setNeedsDisplay];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    self.touchedStorage = [self storageForpoint:location ViewHeight:self.bounds.size.height];
    if (self.touchedStorage) {
        if ([self.delegate respondsToSelector:@selector(storage:)]) {
            [self.delegate storage:self.touchedStorage];
        }

    }
    self.touchedStorage = nil;
    [self setNeedsDisplay];
}


- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{

    self.touchedStorage = nil;
   [self setNeedsDisplay];
}

#pragma mark - 添加链接
- (void)addUrl:(NSURL *)url range:(NSRange)range{
    LHLabelTextStorage *storage = [[LHLabelTextStorage alloc] initWithData:url];

    [self.attributedString setTextColor:_linkColor range:range];
    [self.attributedString addAttribute:kLHTextRunAttributedName value:storage range:range];
    [_textStorages addObject:storage];
    self.attributedText = self.attributedString;
}

//添加
- (void)addData:(id)data
          range:(NSRange)range{
    LHLabelTextStorage *storage = [[LHLabelTextStorage alloc] initWithData:data];

    [self.attributedString setTextColor:_linkColor range:range];
    [self.attributedString addAttribute:kLHTextRunAttributedName value:storage range:range];
    [_textStorages addObject:storage];
    self.attributedText = self.attributedString;
}

#pragma mark - 图片
- (void)addImage:(UIImage *)image data:(id)data size:(CGSize)size range:(NSRange)range{
    LHLabelTextStorage *storage = [LHLabelTextStorage initWithData:data draw:image size:size];
    NSAttributedString *att = [self attributedWithStorage:storage fontAscent:_fontAscent fontDescent:_fontDescent];
    [self.attributedString replaceCharactersInRange:range withAttributedString:att];
    [_textStorages addObject:storage];
    self.attributedText = self.attributedString;
}

- (void)addImage:(UIImage *)image data:(id)data size:(CGSize)size insets:(UIEdgeInsets)insets range:(NSRange)range{
    LHLabelTextStorage *storage = [LHLabelTextStorage initWithData:data draw:image size:size];
    NSAttributedString *att = [self attributedWithStorage:storage fontAscent:_fontAscent fontDescent:_fontDescent];
    [self.attributedString replaceCharactersInRange:range withAttributedString:att];
    storage.insets = insets;
    [_textStorages addObject:storage];
    self.attributedText = self.attributedString;
}

#pragma mark - 添加view
- (void)addView:(UIView *)view size:(CGSize)size range:(NSRange)range{
    [self addSubview:view];
    
    LHLabelTextStorage *storage = [LHLabelTextStorage initWithData:nil draw:view size:size];
    NSAttributedString *att = [self attributedWithStorage:storage fontAscent:_fontAscent fontDescent:_fontDescent];
    [self.attributedString replaceCharactersInRange:range withAttributedString:att];

    [_textStorages addObject:storage];
    self.attributedText = self.attributedString;
}

- (NSAttributedString *)attributedWithStorage:(LHLabelTextStorage *)textStorage
                                      fontAscent:(CGFloat)fontAscent
                                     fontDescent:(CGFloat)fontDescent
{

    textStorage.fontAscent = fontAscent;
    textStorage.fontDescent = fontDescent;
    
    unichar objectReplacementChar           = 0xFFFC;
    NSString *objectReplacementString       = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString *attachText   = [[NSMutableAttributedString alloc]initWithString:objectReplacementString];

    CTRunDelegateCallbacks callbacks;
    callbacks.version       = kCTRunDelegateVersion1;
    callbacks.getAscent     = LHTextRunDelegateGetAscentCallback;
    callbacks.getDescent    = LHTextRunDelegateGetDescentCallback;
    callbacks.getWidth      = LHTextRunDelegateGetWidthCallback;
    callbacks.dealloc       = LHTextRunDelegateDeallocCallback;

    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (void *)textStorage);
    [attachText addAttribute:(__bridge_transfer NSString *)kCTRunDelegateAttributeName value:(__bridge id)delegate range:NSMakeRange(0, 1)];

    CFRelease(delegate);

    return attachText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
