//
//  BrandCollectionView.h
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BrandCollectionView : UICollectionView

@property (nonatomic,copy) NSString *bid;
@property (nonatomic,weak) UIViewController *parentViewController;

- (void)loadData;
@end
