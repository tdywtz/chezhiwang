//
//  ComplainListCell.h
//  chezhiwang
//
//  Created by bangong on 15/9/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^myBlock)(CGFloat gao);

@interface ComplainListCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dictionary;
@property (nonatomic,copy) myBlock block;
@property (nonatomic,assign) CGPoint point;
@property (nonatomic,strong) NSArray *readArray;

-(void) setCellHeight:(myBlock)block;
+(instancetype)manager;
+(CGFloat)returnCellHeight:(NSDictionary *)dict;
@end
