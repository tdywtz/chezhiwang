//
//  ComplainDrawView.h
//  chezhiwang
//
//  Created by bangong on 16/12/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

@property (nonatomic,copy) void(^click)(NSString *title);
@property (nonatomic,copy) NSArray *titles;

@end

#pragma mark - ListModel
@interface ListModel : NSObject

@property (nonatomic,assign) CGRect textFrame;
@property (nonatomic,assign) CGRect lineFrame;
@property (nonatomic,strong) NSAttributedString *attribute;


- (instancetype)initWithTextFrame:(CGRect)textFrame attribute:(NSAttributedString *)attribute;
@end

#pragma mark - ComplainDrawView

@interface ComplainDrawView : UIView

@property (nonatomic,assign)   CGFloat leftSpace;//文字左侧间隔
@property (nonatomic,assign)   CGFloat rightSpace;//文字右侧间隔
@property (nonatomic,assign)   CGFloat lineSpace;//步骤上下间隔
@property (nonatomic,assign)   BOOL isDrawCircle;
@property (nonatomic,strong) NSArray *listModels;

- (void)setSteps:(NSArray *)steps;

@end
