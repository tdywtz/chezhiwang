//
//  FindModel.h
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *aClass;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName aClass:(NSString *)aClass;
@end
