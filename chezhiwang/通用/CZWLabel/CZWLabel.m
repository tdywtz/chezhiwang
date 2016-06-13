//
//  LHLabel.m
//  autoService
//
//  Created by bangong on 16/5/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWLabel.h"
#import <CoreText/CoreText.h>


@interface CZWLabel()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableParagraphStyle *parapgStyle;

@end

@implementation CZWLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return  self;
}

-(void)setUp{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.alignment = NSTextAlignmentLeft;
    self.backgroundColor = [UIColor clearColor];
    self.textInsets = UIEdgeInsetsZero;
   //添加手势
    [self attachTapHandler];
}

#pragma mark - 菜单
//设置可唤醒键盘
- (BOOL)canBecomeFirstResponder{
    return YES;
}
//"反馈"关心的功能，即放出你需要的功能，比如你要放出copy，你就返回YES，否则返回NO；
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copy:)){
        return YES;
    }
    return NO;
}

//针对于copy的实现
-(void)copy:(id)sender{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}


-(void)attachTapHandler{
  // self.userInteractionEnabled =YES;  //用户交互的总开关
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.delegate = self;
    [self addGestureRecognizer:touch];
   // touch.numberOfTapsRequired =1;
}

//响应点击事件
-(void)handleTap:(UILongPressGestureRecognizer *) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - sets
-(void)setText:(NSString *)text{
    [super setText:text];
  
    _attributeString = nil;
    [self addattributeName];
    self.attributedText = self.attributeString;
}

#pragma mark getters

-(NSMutableParagraphStyle *)parapgStyle{
    if (_parapgStyle == nil) {
        _parapgStyle = [[NSMutableParagraphStyle alloc] init];
    }
    return _parapgStyle;
}

-(NSMutableAttributedString *)attributeString{
    if (_attributeString == nil) {
        _attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    return _attributeString;
}


#pragma mark - add
-(void)addattributeName{
    NSRange range = NSMakeRange(0, self.attributeString.length);
    [self.attributeString addAttribute:NSForegroundColorAttributeName value:self.textColor range:range];
    [self.attributeString addAttribute:NSFontAttributeName value:self.font range:range];
    [self.attributeString addAttribute:NSKernAttributeName value:@(self.characterSpace) range:range];
    self.parapgStyle.lineSpacing =  self.lineSpacing;
    self.parapgStyle.paragraphSpacing = self.paragraphSpacing;
    self.parapgStyle.alignment = self.alignment;
    self.parapgStyle.firstLineHeadIndent = self.firstLineHeadIndent;
    self.parapgStyle.headIndent = self.headIndent;
    self.parapgStyle.tailIndent = self.tailIndent;
    self.parapgStyle.lineBreakMode = self.lineBreakMode;
    self.parapgStyle.paragraphSpacingBefore = self.paragraphSpacingBefore;
    
    [self.attributeString addAttribute:NSParagraphStyleAttributeName value:self.parapgStyle range:range];
    
  //  [self.attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Snell Roundhand" size:15] range:range];

}

#pragma mark - views

-(CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
  
    return CGSizeMake(size.width+self.textInsets.left+self.textInsets.right, size.height+self.textInsets.top+self.textInsets.bottom);
}

- (void)drawTextInRect:(CGRect)rect{
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.textInsets);
    [super drawTextInRect:insetRect];
    //绘画选择区域背景
}

-(void)addColor:(UIColor *)color range:(NSRange)range{
    [self.attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = self.attributeString;
}

////接受触摸事件
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    //获取UITouch对象
//
//    UITouch *touch = [touches anyObject];
//    //获取触摸点击当前view的坐标位置
//    CGPoint location = [touch locationInView:self];
//    NSLog(@"touch:%@",NSStringFromCGPoint(location));
//    //获取每一行
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)[self.attributeString copy]);
//    CGRect insetRect = UIEdgeInsetsInsetRect(self.bounds, self.textInsets);
//    CTFrameRef _frame = [self createFrameRefWithFramesetter:framesetter textSize:insetRect.size];
//    CFArrayRef lines = CTFrameGetLines(_frame);
//    CGPoint origins[CFArrayGetCount(lines)];
//    //获取每行的原点坐标
//    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
//    CTLineRef line = NULL;
//    CGPoint lineOrigin = CGPointZero;
//    for (int i= 0; i < CFArrayGetCount(lines); i++)
//    {
//        CGPoint origin = origins[i];
//        CGPathRef path = CTFrameGetPath(_frame);
//        //获取整个CTFrame的大小
//        CGRect rect = CGPathGetBoundingBox(path);
//      //  NSLog(@"origin:%@",NSStringFromCGPoint(origin));
//       // NSLog(@"rect:%@",NSStringFromCGRect(rect));
//        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
//        CGFloat y = self.frame.size.height - rect.size.height - origin.y;
//       // NSLog(@"y:%f",y);
//        //判断点击的位置处于那一行范围内
//        if ((location.y <= y) && (location.x >= origin.x))
//        {
//            line = CFArrayGetValueAtIndex(lines, i);
//            lineOrigin = origin;
//            break;
//        }
//    }
//    
//    location.x -= lineOrigin.x;
//   
//    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
//    CFIndex index = CTLineGetStringIndexForPosition(line, location);
//    NSLog(@"index:%ld",index);
//    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
//    if (index>=0&&index<=3) {
//        NSLog(@"asdf");
//    }
//    CFRelease(_frame);
//    CFRelease(framesetter);
//}
//
//
//#pragma mark -
//-  (CTFrameRef)createFrameRefWithFramesetter:(CTFramesetterRef)framesetter textSize:(CGSize)textSize
//{
//    // 这里你需要创建一个用于绘制文本的路径区域,通过 self.bounds 使用整个视图矩形区域创建 CGPath 引用。
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(self.textInsets.left , self.textInsets.top, textSize.width, textSize.height));
//    
//    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributeString length]), path, NULL);
//    CFRelease(path);
//    return frameRef;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
