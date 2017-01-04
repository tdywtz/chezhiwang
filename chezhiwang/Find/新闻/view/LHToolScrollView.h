//
//  LHToolScrollView.h
//  autoService
//
//  Created by bangong on 16/5/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHToolScrollViewDelegate <NSObject>

@required
-(void)clickLeft:(NSInteger)index;
-(void)clickRight:(NSInteger)index;

@optional
- (void)chooseButtonClick:(BOOL)open;

@end


@interface LHToolButton : UIButton

@property (nonatomic,assign) CGFloat scale;
-(void)setScale:(CGFloat)scale anima:(BOOL)boll;

@end

@interface LHToolScrollView : UIView

@property (nonatomic,weak) id<LHToolScrollViewDelegate> LHDelegate;
@property (nonatomic,strong) NSArray <__kindof NSString *> *titles;
@property (nonatomic,assign) NSInteger current;


-(void)setProgressLeft:(CGFloat)progress;
-(void)setProgressRight:(CGFloat)progress;
@end
