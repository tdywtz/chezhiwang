//
//  CustomCommentView.m
//  chezhiwang
//
//  Created by bangong on 16/1/13.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CustomCommentView.h"

@implementation CustomCommentView
{
    UITextView *_textView;
    UIView *_bgView;
    CGFloat textFont;
    
    UILabel *titleLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        textFont = [LHController setFont]-2;
        self.frame = [UIScreen mainScreen].bounds;

        [self createNotification];
        [self makeUI];
    }
    return self;
}

#pragma mark - 通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect frame = _bgView.frame;
    frame.origin.y = HEIGHT-height-frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.frame = frame;
    }];
}

-(void)keyboardHide:(NSNotification *)notification
{
    [self close];
}


-(void)makeUI{
 
   
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 200)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    UIButton *cancel = [LHController createButtnFram:CGRectMake(10, 10, 40, 20) Target:self Action:@selector(cancelClick) Text:@"取消"];
    cancel.titleLabel.font = [UIFont systemFontOfSize:textFont];
    [cancel setTitleColor:[UIColor colorWithRed:5/255.0 green:143/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    [_bgView addSubview:cancel];
    
    UIButton *certain =  [LHController createButtnFram:CGRectMake(WIDTH-50, 10, 40, 20) Target:self Action:@selector(certainClick) Text:@"发送"];
    certain.titleLabel.font = [UIFont systemFontOfSize:textFont];
    [certain setTitleColor:[UIColor colorWithRed:5/255.0 green:143/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    [_bgView addSubview:certain];
    
    titleLabel =  [LHController createLabelWithFrame:CGRectMake(WIDTH/2-20, 10, 40, 20) Font:textFont+1 Bold:NO TextColor:nil Text:@"评论"];
    [_bgView addSubview:titleLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, WIDTH, 1)];
    bgView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [_bgView addSubview:bgView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 34, WIDTH, 150)];
    _textView.font = [UIFont systemFontOfSize:16];
    //_textView.delegate = self;
    [_bgView addSubview:_textView];
}

-(void)cancelClick{
    [self close];
}

-(void)certainClick{
  
        if (self.sendBlick) {
            self.sendBlick(_textView.text);
        }
        [self close];

}

-(void)setTitle:(NSString *)title{
    titleLabel.text = title;
}

-(void)send:(void (^)(NSString *))block{
    self.sendBlick = block;
}

-(void)close{
    [_textView resignFirstResponder];

        CGRect frame = _bgView.frame;
        frame.origin.y = HEIGHT;
        _bgView.frame = frame;
 
    [self removeFromSuperview];
}

-(void)show{
 
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [_textView becomeFirstResponder];
}
/*close
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
