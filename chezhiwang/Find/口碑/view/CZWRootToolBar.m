//
//  CZWRootToolBar.m
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CZWRootToolBar.h"

@interface CZWRootToolBar ()
{
    /**
     *  状态
     */
    UIButton *staleButton;
    /**
     *  地区
     */
    UIButton *areaButton;
    /**
     *  车品牌
     */
    UIButton *brandButon;
    
    UIImageView *staleImageView;
    UIImageView *areaImamgeVIew;
    UIImageView *brandImageView;
}
@end
@implementation CZWRootToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    
    return self;
}



-(void)makeUI{

    CGFloat width = (self.frame.size.width-30)/3;
    NSArray *nameArray = @[@"品牌",@"车系",@"车型"];
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [LHController createButtnFram:CGRectMake(18+(width)*i, 5, width-5, self.frame.size.height-10) Target:self Action:@selector(toolbarClick:) Text:nameArray[i]];
        [btn setTitleColor:colorBlack forState:UIControlStateNormal];
        [btn setTitleColor:colorYellow forState:UIControlStateSelected];
        [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];

        UIImageView *iamgeView = [LHController createImageViewWithFrame:CGRectMake(width/2+10, 0, 7, btn.frame.size.height) ImageName:@"auto_toolbarRightTriangle"];
        iamgeView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addSubview:iamgeView];
        [btn setBackgroundImage:[UIImage imageNamed:@"auto_toolbarBackImage"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        if (i == 0) {
            staleButton = btn;
            staleImageView = iamgeView;
        }else if (i == 1){
            areaButton = btn;
            areaButton.enabled = NO;
            areaImamgeVIew = iamgeView;
        }else{
            brandButon = btn;
            brandButon.enabled = NO;
            brandImageView = iamgeView;
        }
    }
    [self setButtonState:staleButton select:NO];
}

-(void)toolbarClick:(UIButton *)btn{

    BOOL select = btn.selected;

    if (select) {
       [self setButtonState:btn select:NO];
    }
    NSInteger number;
    if (btn == staleButton) number = 0;
    else if (btn == areaButton) number = 1;
    else number = 2;
    
    if (self.block) {
        self.block(btn, number, select);
    }
}

-(void)chooseClickButton:(chooseClick)block{
    self.block = block;
}

/**
 *  设置UIButton状态、更改UIButton上图片显示与否、修改UIButton标题位子
 *
 *  @param button <#button description#>
 */
-(void)setButtonState:(UIButton *)button select:(BOOL)select{
    button.selected = select;
    if (select) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        if (button == staleButton) {
            staleImageView.hidden = YES;
            areaButton.enabled = YES;
            areaButton.alpha = 1;
        }else if (button == areaButton){
            areaImamgeVIew.hidden = YES;
            brandButon.enabled = YES;
            brandButon.alpha = 1;
        }else{
            brandImageView.hidden = YES;
        }
    }else{
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        if (button == staleButton) {
            staleImageView.hidden = NO;
            areaButton.enabled = NO;
            areaButton.alpha = 0.5;
            areaButton.selected = NO;
            brandButon.enabled = NO;
            brandButon.alpha = 0.5;
            brandButon.selected = NO;

        }else if (button == areaButton){
            areaImamgeVIew.hidden = NO;
            brandButon.enabled = NO;
            brandButon.alpha = 0.5;
            brandButon.selected = NO;
        }else{
            brandImageView.hidden = NO;
        }
    }
}

-(void)setTitle:(NSString *)text andButton:(UIButton *)button{

    [button setTitle:text forState:UIControlStateSelected];
    [self setButtonState:button select:YES];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画一条底部线
    CGContextSetRGBStrokeColor(context, 220/255.0,  220/255.0, 220/255.0, 1);//线条颜色
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
