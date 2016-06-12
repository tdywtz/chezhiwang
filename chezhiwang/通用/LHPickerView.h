//
//  LHPickerView.h
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnResult)(NSString *title, NSString *ID);
@interface LHPickerView : UIView

@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) returnResult block;
@property (nonatomic,strong) NSArray *dataArray;

-(void)returnResult:(returnResult)block;
-(void)showPickerView;
-(void)dismissView;

@end
