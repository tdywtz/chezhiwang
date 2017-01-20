//
//  OverviewStatisticsView.h
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^updateFrame)(CGRect frame);

/**典型故障*/
@interface OverviewStatisticsExampleModel : NSObject

@property (nonatomic,copy) NSString *bw;
@property (nonatomic,copy) NSString *count;
@property (nonatomic,copy) NSString *ques;

@end

@interface OverviewStatisticsModel : NSObject

@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *A;
@property (nonatomic,copy) NSString *B;
@property (nonatomic,copy) NSString *C;
@property (nonatomic,copy) NSString *D;
@property (nonatomic,copy) NSString *E;
@property (nonatomic,copy) NSString *F;
@property (nonatomic,copy) NSString *G;
@property (nonatomic,copy) NSString *H;
@property (nonatomic,copy) NSString *total;
@property (nonatomic,strong) NSArray <OverviewStatisticsExampleModel *> *exampleModels;

@end

@interface OverviewStatisticsView : UIView

@property (nonatomic,strong) NSArray <OverviewStatisticsModel *> *models;
@property (nonatomic,copy) updateFrame block;

@end
