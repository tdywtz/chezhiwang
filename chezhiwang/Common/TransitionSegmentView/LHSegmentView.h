//
//  LHSegmentView.h
//  chezhiwang
//
//  Created by bangong on 16/12/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHSegmentView : UIView


@property (nonatomic,strong) UIColor *highlightColor;// 高亮字体颜色
@property (nonatomic,strong) UIColor *textColor;//普通字体颜色
@property (nonatomic,strong) UIFont *font;//字体大小
@property (readonly) CGSize contentSize;//scrollview滚动范围

@property (nonatomic,copy) void (^setScrollClosure)(NSInteger index);//点击选项block


/**
 滑动高亮区域
 根据进度设置高亮区域frame
 @param progress 【-1，1】小于向左左滑，大于零向右
 */
- (void)progress:(CGFloat)progress;
//- (void)progress:(CGFloat)progress toIndex:(NSInteger)index;

/**
 滑动到指定选项

 @param current 指定选项的下标
 @param animer 是否带动画
 */
- (void)scrollTo:(NSInteger)current animer:(BOOL)animer;
- (void)resetToIndex:(CGFloat)progress;


+ (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<__kindof NSString *> *)titles textColor:(UIColor *)textColor highlightColor:(UIColor *)highlightColor;


@end
