//
//  MyComplainModel.m
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (NSString *)content{
    if (_content == nil) {
        _content = @"";
    }

    return _content;
}

@end
