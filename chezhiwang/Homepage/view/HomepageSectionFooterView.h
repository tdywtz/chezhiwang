//
//  HomepageSectionFooterView.h
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomepageSectionModel;

@interface HomepageSectionFooterView : UIView

@property (nonatomic,strong) HomepageSectionModel *sectionModel;
@property (nonatomic,weak) UIViewController *parentVC;
@property (nonatomic,copy) void (^click)();

- (void)noSpace;
@end
