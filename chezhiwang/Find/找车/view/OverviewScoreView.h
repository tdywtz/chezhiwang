//
//  OverviewScoreView.h
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverviewViewCotextViewModel : NSObject

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *name;

@end



@interface OverviewViewCotextView : UIView

@property (nonatomic,assign) CGPoint origin;//坐标原点
@property (nonatomic,assign) CGFloat minValue;//最小值
@property (nonatomic,assign) CGFloat maxValue;//最大值
@property (nonatomic,assign) NSInteger spanNumber;//跨度数量
@property (nonatomic,strong) NSArray<OverviewViewCotextViewModel *> *KlineArray;//

@end


@interface OverviewScoreView : UIView

@end
