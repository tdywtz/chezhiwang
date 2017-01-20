//
//  ChartItemModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartItemModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSAttributedString *attribute;
@property (nonatomic,assign) BOOL isborder;//边界线

- (void)releaseData;

@end
