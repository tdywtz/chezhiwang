//
//  URLFile.h
//  12365auto
//
//  Created by bangong on 16/5/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

#define auto_car_brand @"http://m.12365auto.com/server/forCommonService.ashx?act=letter"
//获取车系
#define auto_car_series @"http://m.12365auto.com/server/forCommonService.ashx?act=serieslist&id=%@"
//注册协议
#define xieyi @"http://m.12365auto.com/user/agreeForIOS.shtml"

@interface URLFile : NSObject

/**登录*/
+ (NSString *)urlStringForLogin;
/**注册*/
+ (NSString *)urlStringForRegister;

#pragma mark - 新闻
/**新闻列表*/
+ (NSString *)urlStringForNewsList;
/**焦点图片*/
+ (NSString *)urlStringForFocuspic;
/**焦点新闻*/
+ (NSString *)urlStringForFocusnews;
/**新闻-调查*/
+ (NSString *)urlStringForReport;
/**新闻详情*/
+ (NSString *)urlStringForNewsinfo;



///**故障详情*/
//+ (NSString *)urlStringForCarInfo;
//
///**全部故障*/
//+ (NSString *)urlStringForIssue;

#pragma mark - 投诉
/**投诉列表*/
+ (NSString *)urlStringForZLTS;
/**投诉搜索*/
+ (NSString *)urlStringForZLTSWithSearch;
/**投诉列表->投诉详情*/
+ (NSString *)urlStringForComplain;



/**评论列表*/
+ (NSString *)urlStringForPL;
/**评论总数*/
+ (NSString *)urlStringForPL_total;
/**提交评论*/
+ (NSString *)urlStringForAddcomment;



/**大品牌*/
+ (NSString *)urlStringForLetter;
/**车系*/
+ (NSString *)urlStringForSeries;
/**车型*/
+ (NSString *)urlStringForModelList;
/**省份*/
+ (NSString *)urlStringForPro;
/**城市*/
+ (NSString *)urlStringForDisCity;
/**经销商*/
+ (NSString *)urlStringForDis;
/**提交投诉*/
+ (NSString *)urlStringForProgressComplain;



#pragma mark -答疑
/**答疑列表*/
+ (NSString *)urlStringForZJDY;
/**答疑搜索*/
+ (NSString *)urlStringForZJDYSearch;
/**我要提问*/
+ (NSString *)urlStringForEditZJDY;
/**答疑详情*/
+ (NSString *)urlStringForGetZJDY;

#pragma mark - 论坛
/**论坛列表*/
+ (NSString *)urlStringForPostList;
/**帖子内容*/
+ (NSString *)urlStringForPostInfo;
/**论坛车系品牌*/
+ (NSString *)urlStringForOtherSeries;
/**指定论坛*/
+ (NSString *)urlStringForSeriesForm;
/**回复帖子*/
+ (NSString *)urlStringForReplyPost;
/**回复其中一条评论*/
+ (NSString *)urlStringForReplyFloor;
/**申请版主*/
+ (NSString *)urlStringForApplyOwner;
/**发表帖子*/
+ (NSString *)urlStringForNewTopic;


#pragma Mark- 个人中心
/**获取用户信息*/
+ (NSString *)urlStringForUser;

/**个人中心*/
+ (NSString *)urlStringForPersonalCount;

/**我的投诉列表*/
+ (NSString *)urlStringForMyTS;
/***/
+ (NSString *)urlStringFor_mytsbyid;
/**个人中心根据cpid获取投诉详情*/
+ (NSString *)urlStringForDetail;

/**我的评论*/
+ (NSString *)urlStringForComplainScore;

/**修改密码*/
+ (NSString *)urlStringForUpdatePWD;

/**申请撤诉*/
+ (NSString *)urlStringForCancelComplain;

/**获取地区*/
+ (NSString *)urlStringForGetPersonalAddress;

/**市*/
+ (NSString *)urlStringForCity;

/**县*/
+ (NSString *)urlStringForArea;

/**提交地区*/
+ (NSString *)urlStringForUpdatePersonalAddress;

/**提交用户信息*/
+ (NSString *)urlStringForpersonalInfo;

/**我的评论*/
+ (NSString *)urlStringForDiscuss;

/**上传头像*/
+ (NSString *)urlStringForUploadAvatar;

/**我的提问*/
+ (NSString *)urlStringFor_myZJDY;

@end
