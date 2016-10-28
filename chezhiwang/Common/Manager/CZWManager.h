//
//  CZWManager.h
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 信息类型
 - NewsTypeNews: <#NewsTypeNews description#>
 */
typedef NS_ENUM(NSInteger, NewsType) {
    NewsTypeNews = 1,//新闻
    NewsTypeComplain = 2,//投诉
    NewsTypeAnswer = 3,//答疑
    NewsTypeForu,//论坛
    NewsTypeResearch = 5//新车调查
};

#define CZWManagerInstance [CZWManager manager]
@interface CZWManager : NSObject

@property (nonatomic,assign,readonly) BOOL isLogin;
@property (nonatomic,copy,readonly) NSString *userName;
@property (nonatomic,copy,readonly) NSString *password;
@property (nonatomic,copy,readonly) NSString *userID;
@property (nonatomic,copy,readonly) NSString *iconUrl;

/**登录账号*/
- (void)loginWithDictionary:(NSDictionary *)dictionary;
/**存储密码*/
- (void)storagePassword:(NSString *)password;
/**退出账号*/
- (void)logoutAccount;

#pragma mark - class method
+ (instancetype)manager;
/**默认展示图片*/
+ (UIImage *)defaultIconImage;
@end
