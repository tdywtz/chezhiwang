//
//  ComplainDetailsView.h
//  chezhiwang
//
//  Created by bangong on 16/12/6.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyComplainModel.h"

@class MyComplainDetailsViewController;

#pragma mark - ComplainPromptView

@interface ComplainPromptView : UIView

@property (nonatomic,weak) MyComplainModel *model;
@property (nonatomic,weak) MyComplainDetailsViewController *perentViewController;

@end

#pragma mark - ComplainDetailsView
@interface ComplainDetailsView : UIView

- (void)setDetailsDict:(NSDictionary *)detailsDict;

@end
