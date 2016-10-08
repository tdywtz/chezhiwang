//
//  FindModel.m
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName aClass:(NSString *)aClass{
    if (self= [super init]) {
        self.title = title;
        self.imageName = imageName;
        self.aClass = aClass;
    }
    return self;
}
@end
