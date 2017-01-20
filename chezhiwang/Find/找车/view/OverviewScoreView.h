//
//  OverviewScoreView.h
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverviewScoreViewModel : NSObject

@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *reportId;
@property (nonatomic,copy) NSString *pcId;
@property (nonatomic,copy) NSString *minScore;
@property (nonatomic,copy) NSString *avgScore;
@property (nonatomic,copy) NSString *maxScore;
@property (nonatomic,assign) BOOL report;
@property (nonatomic,assign) BOOL pc;


@end


@interface OverviewScoreView : UIView

@property (nonatomic,weak) UIViewController *parentVC;
@property (nonatomic,strong) OverviewScoreViewModel *model;


@end
