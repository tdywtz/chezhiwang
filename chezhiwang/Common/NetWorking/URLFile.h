//
//  URLFile.h
//  12365auto
//
//  Created by bangong on 16/5/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLFile : NSObject

/**注册协议*/
+ (NSString *)urlStringRegistrationAgreement;
//广告
+ (NSString *)url_DTopAdv;
/**登录*/
+ (NSString *)urlStringForLogin;
/**注册*/
+ (NSString *)urlStringForRegister;


#pragma mark- 车型图片
/**车型图片-根据参数获取车型图片列表*/
+ (NSString *)urlString_modelPlicList;
/**车型图片-品牌大全*/
+ (NSString *)urlString_picBrand;
/**车型图片-车系大全*/
+ (NSString *)urlString_picSeries;



#pragma mark - homepage
/**首页*/
+ (NSString *)urlStringForLogin_index;

#pragma mark - 新闻
/**新闻列表*/
+ (NSString *)url_newslistWithStyle:(NSString *)style title:(NSString *)title sid:(NSString *)sid;
/**新闻-调查*/
+ (NSString *)urlStringForReport;
/**新闻详情*/
+ (NSString *)url_newsinfoWithID:(NSString *)ID sid:(NSString *)sid type:(NSString *)type;
/**精品试list*/
+ (NSString *)urlString_testDrive;
/**新闻搜索*/
+ (NSString *)urlStringForNewsSearch;


#pragma mark - 投诉排行
/**排行榜-页面查询条件*/
+ (NSString *)urlString_rankingAct;
/**投诉排行列表*/
+ (NSString *)urlString_rankingList;
/**回复率列表*/
+ (NSString *)urlString_rankingBotm;

#pragma mark - 投诉
/**投诉列表*/
+ (NSString *)url_complainlistWithTitle:(NSString *)title sid:(NSString *)sid p:(NSInteger)p s:(NSInteger)s;
/**投诉搜索*/
+ (NSString *)urlStringForZLTSWithSearch;
/**投诉列表->投诉详情*/
+ (NSString *)urlStringForComplain;



/**评论列表*/
+ (NSString *)urlStringForPL;
/**提交评论*/
+ (NSString *)urlStringForAddcomment;



/**大品牌*/
+ (NSString *)urlStringForLetter;
/**车系*/
+ (NSString *)urlStringForSeries;
/**车型*/
+ (NSString *)urlStringForModelList;
/**获取省份*/
+ (NSString *)urlStringForPro;
/**获取经销商城市*/
+ (NSString *)urlStringForDisCity;
/**获取经销商*/
+ (NSString *)urlStringForDis;
/**提交、修改投诉*/
+ (NSString *)urlStringForProgressComplain;



#pragma mark -答疑
/**答疑列表*/
+ (NSString *)url_zjdylistWithTitle:(NSString *)title sid:(NSString *)sid t:(NSString *)t p:(NSInteger)p;
/**答疑搜索*/
+ (NSString *)urlStringForZJDYSearch;
/**我要提问*/
+ (NSString *)urlStringForEditZJDY;
/**答疑详情*/
+ (NSString *)urlStringForGetZJDY;

#pragma mark - 论坛
/**论坛列表*/
+ (NSString *)urlStringForPostList;
/**帖子内容(web)*/
+ (NSString *)urlStringForBBSContent;

/**论坛分类->品牌论坛->指定论坛*/
+ (NSString *)urlStringForSeriesForm;
/**论坛分类->栏目论坛->指定论坛*/
+ (NSString *)urlString_columnform;
/**回复帖子*/
+ (NSString *)urlStringForReplyPost;
/**回复其中一条评论*/
+ (NSString *)urlStringForReplyFloor;
/**申请版主*/
+ (NSString *)urlStringForApplyOwner;
/**发表帖子*/
+ (NSString *)urlStringForNewTopic;
/**申请版主-下载用户数据*/
+ (NSString *)urlString_getApplyOwner;
/**论坛分类->品牌论坛->论坛列表*/
+ (NSString *)urlStringForBrand_postlist;
/**论坛分类->栏目论坛->论坛列表*/
+ (NSString *)urlStringForColumn_postlist;

#pragma mark - 找车--
/**发现-找车-车系综述 - 车型信息 评分*/
+ (NSString *)urlString_s_index;
/**发现-找车-车系综述 - 车型信息 车型故障统计*/
+ (NSString *)urlString_s_index2;
/**发现-找车-投诉头部 满意度&回复率*/
+ (NSString *)url_s_complainWithSid:(NSString *)sid;

#pragma Mark- 个人中心
/**获取用户信息*/
+ (NSString *)urlStringForUser;

/**个人中心*/
+ (NSString *)urlStringForPersonalCount;

/**我的投诉列表*/
+ (NSString *)urlStringForMyTS;
/**根据cpid获取一条投诉进度信息*/
+ (NSString *)urlStringFor_mytsbyid;
/**个人中心根据cpid获取投诉详情*/
+ (NSString *)urlStringForDetail;
/**查看撤诉未成功原因*/
+ (NSString *)urlString_delComNoReason;
/**申请撤诉-原因选择列表*/
+ (NSString *)urlString_delComTypeList;

/**提交评分*/
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
//+ (NSString *)urlStringForUpdatePersonalAddress;

/**提交用户信息*/
+ (NSString *)urlStringForpersonalInfo;

/**我的评论*/
+ (NSString *)urlStringForDiscuss;

/**上传头像*/
+ (NSString *)urlStringForUploadAvatar;

/**我的提问*/
+ (NSString *)urlStringFor_myZJDY;

/** 找回密码*/
+ (NSString *)urlString_sendemail;

#pragma mark - 数据对比
/**对比-车型参数*/
+ (NSString *)urlString_mConfig;
/**对比-车型故障信息*/
+ (NSString *)urlString_dbInfo;

@end
