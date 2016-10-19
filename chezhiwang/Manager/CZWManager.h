//
//  CZWManager.h
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NewsType) {
    NewsTypeNews = 1,//新闻
    NewsTypeComplain = 3,//投诉
    NewsTypeAnswer = 2,//答疑
    NewsTypeForum//论坛
};

@interface CZWManager : NSObject

@property (nonatomic,assign,readonly) BOOL isLogin;
@property (nonatomic,copy,readonly) NSString *userName;
@property (nonatomic,copy,readonly) NSString *password;
@property (nonatomic,copy,readonly) NSString *userID;
@property (nonatomic,copy,readonly) NSString *iconUrl;

/**登录账号*/
- (void)loginWithDictionary:(NSDictionary *)dictionary;
/**退出账号*/
- (void)logoutAccount;

+ (instancetype)manager;

+ (UIImage *)defaultIconImage;
@end
