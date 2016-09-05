//
//  LHLabelTextStorage.h
//  LHLabel
//
//  Created by bangong on 16/7/7.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageAlignment) {
    ImageAlignmentTop,
    ImageAlignmentCenter,
    ImageAlignmentBottom
};
//CTRun的回调，销毁内存的回调
void LHTextRunDelegateDeallocCallback( void* refCon );
//CTRun的回调，获取上行高度
CGFloat LHTextRunDelegateGetAscentCallback(void *refCon);
//CTRun的回调，获取下行高度
CGFloat LHTextRunDelegateGetDescentCallback(void *refCon);
//CTRun的回调，获取宽度
CGFloat LHTextRunDelegateGetWidthCallback(void *refCon);

@interface LHLabelTextStorage : NSObject

@property (nonatomic,strong) id returnData;

@property (nonatomic,strong) id draw;//添加的view、image
@property (nonatomic,assign) CGSize drawSize;//绘画尺寸
@property (nonatomic,assign) CGRect drawRect;//绘画区域
@property (nonatomic,assign) ImageAlignment imageAlignment;//
@property (nonatomic,assign) UIEdgeInsets insets;//四周空白间距
@property (nonatomic,assign) NSRange range;//绘画区间


@property (nonatomic,assign) CGFloat fontAscent;
@property (nonatomic,assign) CGFloat fontDescent;

- (CGFloat)getAscent;
- (CGFloat)getDescent;
- (CGFloat)getWidth;

- (instancetype)initWithData:(id)data;
+ (instancetype)initWithData:(id)data draw:(id)draw size:(CGSize)size;



@end
