//
//  ForumCatalogueSectionModel.h
//  chezhiwang
//
//  Created by bangong on 16/11/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ForumCatalogueSectionModel;
@interface ForumCatalogueModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *logo;

@end

@interface ForumCatalogueSectionModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray <ForumCatalogueModel *> *roeModels;

+ (NSArray *)arrayWithArray:(NSArray *)array;
@end
