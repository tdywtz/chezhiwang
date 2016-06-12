//
//  SearchHistoryView.h
//  auto
//
//  Created by bangong on 15/11/12.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    historyTypeComplain,
    historyTypeANswer,
    historyTypeNews
}historyType;

typedef void(^selectSring)(NSString *string);

@interface SearchHistoryView : UIView

@property (nonatomic,copy) selectSring block;

-(instancetype)initWithFrame:(CGRect)frame Type:(historyType)type;

-(void)selectSring:(selectSring)block;

-(void)reloadDataOFtableview:(NSString *)string;
-(void)updataOFhistory:(NSString *)string;
@end
