//
//  NewsTestTableView.h
//  chezhiwang
//
//  Created by bangong on 16/5/31.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTestTableView : UIView

- (instancetype)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parent;
- (void)setScrollToTop:(BOOL)toTop;
@end
