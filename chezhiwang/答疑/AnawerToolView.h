//
//  ToolView.h
//  12365auto
//
//  Created by bangong on 16/3/21.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnawerToolViewDelegate <NSObject>
@optional
//**点击按钮*/
-(void)selectedButton:(NSInteger)index;
@end

@interface AnawerToolView : UIView

@property (nonatomic,weak) id<AnawerToolViewDelegate> delegate;
/** 标题数组 */
@property (nonatomic,strong) NSArray<__kindof NSString *> *titleArray;
/** 索引 */
@property (nonatomic,assign) NSInteger currentIndex;
@end
