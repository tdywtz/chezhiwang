//
//  URLFile.m
//  12365auto
//
//  Created by bangong on 16/5/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "URLFile.h"

@implementation URLFile

+ (NSString *)stringWithBasic:(NSString *)actString{

    return [self stringForAppWebServiceWithAct:actString];
}

/**车质网专用*/
+ (NSString *)stringForAppWebServiceWithAct:(NSString *)act{
    return [NSString stringWithFormat:@"%@%@%@",[self prefixString],@"/server/forAppWebService.ashx?",act];
}


+ (NSString *)stringForCZWServiceWithAct:(NSString *)act{
    return [NSString stringWithFormat:@"%@%@%@",[self prefixString],@"/AppServer/forCZWService.ashx?",act];
}

/**公用*/
+ (NSString *)stringForCommonServiceWithAct:(NSString *)act{
    return [NSString stringWithFormat:@"%@%@%@",[self prefixString],@"/AppServer/forCommonService.ashx?",act];
}


/**前缀*/
+ (NSString *)prefixString{
#if DEBUG
    return  @"http://192.168.1.114:8888";
#else
    return  @"http://m.12365auto.com";
#endif
}

#pragma mark - 接口-——————————》》》》》
/**登录*/
+ (NSString *)urlStringForLogin{
    return [self stringForCommonServiceWithAct:@"act=login"];
}

/**注册*/
+ (NSString *)urlStringForRegister{
    return [self stringWithBasic:@"act=reg"];
}

#pragma mark- 车型图片
/**车型图片*/
+ (NSString *)urlString_modelPlicList{
    // attr 车型属性
    // bid  品牌
    // sid  车系
    // mid  车型
    return [self stringWithBasic:@"act=modelPicList"];
}
/**品牌大全*/
+ (NSString *)urlString_picBrand{
    return [self stringForCommonServiceWithAct:@"act=brandlist"];
}
/*车系大全*/
+ (NSString *)urlString_picSeries{
    return [self stringForCommonServiceWithAct:@"act=picSeries&bid=%@"];
}



#pragma mark - homepage
/**首页*/
+ (NSString *)urlStringForLogin_index{
    return [self stringForCZWServiceWithAct:@"act=index"];
}

#pragma mark - 新闻
/**新闻列表*/
+ (NSString *)urlStringForNewsList{
    return [self stringForCZWServiceWithAct:@"act=newslist&style=%@%@"];
}

/**新闻-调查*/
+ (NSString *)urlStringForReport{
    return  [self stringForCZWServiceWithAct:@"act=reportlist&t=%@%@"];
}

/**新闻详情*/
+ (NSString *)urlStringForNewsinfo{
    return [self stringForCZWServiceWithAct:@"act=newsinfo&id=%@&type=%@"];
}

///**新闻详情（新车调查）*/
//+ (NSString *)urlString_carownerinfo{
//    return [self stringWithBasic:@"act=carownerinfo&id=%@"];
//}

/**精品试驾list*/
+ (NSString *)urlString_testDrive{
    return [self stringForCZWServiceWithAct:@"act=testDrive&bid=%@&sid=%@&mattr=%@&battr=%@&dep=%@&p=%ld&s=10"];
}

/**新闻搜索*/
+ (NSString *)urlStringForNewsSearch{
    return [self stringForCZWServiceWithAct:@"act=newslist&style=%@&title=%@&p=%ld&s=%ld"];
}

#pragma mark - 投诉
/**大品牌*/
+ (NSString *)urlStringForLetter{
    return [self stringWithBasic:@"act=letter"];
}


/**车系*/
+ (NSString *)urlStringForSeries{
    return [self stringWithBasic:@"act=series&id=%@"];
}


#pragma mark - 投诉排行
/**选择*/
+ (NSString *)urlString_rankingAct{

    return [self stringForCZWServiceWithAct:@"act=rankingAct"];
}

/**投诉排行列表*/
+ (NSString *)urlString_rankingList{

    return   [self stringForCZWServiceWithAct:@"act=rankingList&startTime=%@&endTime=%@&modelAttr=%@&brandAttr=%@&dep=%@&zlwt=%@&p=%ld"];
}

/**回复率列表*/
+ (NSString *)urlString_rankingBotm{
    return [self stringForCZWServiceWithAct:@"act=rankingBotm"];
}



#pragma mark -投诉
/**投诉列表*/
+ (NSString *)urlStringForZLTS{
    return [self stringForCommonServiceWithAct:@"act=complainlist&p=%ld&s=10"];
}

/**投诉搜索*/
+ (NSString *)urlStringForZLTSWithSearch{
    return [self  stringForCommonServiceWithAct:@"act=complainlist&title=%@&p=%ld&s=%ld"];
}

/**投诉列表->投诉详情*/
+ (NSString *)urlStringForComplain{
    return [self stringForCommonServiceWithAct:@"act=complaininfo&id=%@"];
}

/**评论列表*/
+ (NSString *)urlStringForPL{
    return [self stringForCommonServiceWithAct:@"act=pl&id=%@&type=%@&p=%ld&s=10"];
}

///**评论总数*/
//+ (NSString *)urlStringForPL_total{
//    return [self stringWithBasic:@"act=pl&id=%@&type=%@"];
//}

/**提交评论*/
+ (NSString *)urlStringForAddcomment{
    return [self stringForCommonServiceWithAct:@"act=addpl"];
}

/**车型*/
+ (NSString *)urlStringForModelList{
    return [self stringWithBasic:@"act=modellist&sid=%@"];
}

/**省份*/
+ (NSString *)urlStringForPro{
    return [self stringWithBasic:@"act=pro"];
}

/**城市*/
+ (NSString *)urlStringForDisCity{
    return [self stringWithBasic:@"act=discity&pid=%@"];
}

/**经销商*/
+ (NSString *)urlStringForDis{
  
    return [self stringForCommonServiceWithAct:@"act=dis&pid=%@&cid=%@&sid=%@"];
}

/**投诉*/
+ (NSString *)urlStringForProgressComplain{
    return [self stringWithBasic:@"act=progressComplain"];
}

#pragma mark -答疑
/**答疑列表*/
+ (NSString *)urlStringForZJDY{
    return [self stringForCommonServiceWithAct:@"act=zjdylist&t=%@&p=%ld&s=10"];
}
/**答疑搜索*/
+ (NSString *)urlStringForZJDYSearch{
    return [self stringForCommonServiceWithAct:@"act=zjdylist&title=%@&p=%ld&s=%ld"];
}
/**我要提问*/
+ (NSString *)urlStringForEditZJDY{
    return  [self stringWithBasic:@"act=editZJDY"];
}
/**答疑详情*/
+ (NSString *)urlStringForGetZJDY{
    return [self stringForCommonServiceWithAct:@"act=zjdyinfo&id=%@"];
}

#pragma mark - 论坛
/**论坛列表*/
+ (NSString *)urlStringForPostList{
    return [self stringWithBasic:@"act=postlist&order=%ld&topic=%ld&p=%ld&s=10"];
}
/**帖子内容*/
+ (NSString *)urlStringForPostInfo{
    return [self stringWithBasic:@"act=postinfo&tid=%@"];
}
/**论坛车系品牌*/
+ (NSString *)urlStringForOtherSeries{
    return  [self stringWithBasic:@"act=otherseries"];
}
/**论坛分类->品牌论坛->指定论坛*/
+ (NSString *)urlStringForSeriesForm
{
    return [self stringWithBasic:@"act=seriesform&sid=%@"];
}
/**论坛分类->栏目论坛->指定论坛*/
+ (NSString *)urlString_columnform{
    return [self stringWithBasic:@"act=columnform&cid=%@"];
}
/**回复帖子*/
+ (NSString *)urlStringForReplyPost{
    return [self stringWithBasic:@"act=replypost"];
}
/**回复其中一条评论*/
+ (NSString *)urlStringForReplyFloor{
    return [self stringWithBasic:@"act=replyfloor"];
}
/**申请版主*/
+ (NSString *)urlStringForApplyOwner{
    return [self stringWithBasic:@"act=applyOwner"];
}
/**发表帖子*/
+ (NSString *)urlStringForNewTopic{
    return [self stringWithBasic:@"act=newtopic"];
}
/**下载用户数据*/
+ (NSString *)urlString_getApplyOwner{
    return [self stringWithBasic:@"act=getApplyOwner&uid=%@"];
}
/**论坛分类->品牌论坛->论坛列表*/
+ (NSString *)urlStringForBrand_postlist{
    return [self stringWithBasic:@"act=postlist&sid=%@&order=%ld&topic=%ld&p=%ld&s=%ld"];
}
/**论坛分类->栏目论坛->论坛列表*/
+ (NSString *)urlStringForColumn_postlist{
    return  [self stringWithBasic:@"act=postlist&cid=%@&order=%ld&topic=%ld&p=%ld&s=%ld"];
}

#pragma mark-个人中心
/**获取用户信息*/
+ (NSString *)urlStringForUser{
    return [self stringWithBasic:@"act=user&uid=%@"];
}

/**个人中心*/
+ (NSString *)urlStringForPersonalCount{
    return [self stringWithBasic:@"act=personalCount&uname=%@&psw=%@"];
}


/**个人中心我的投诉列表*/
+ (NSString *)urlStringForMyTS{
    return [self stringWithBasic:@"act=myts&uid=%@&p=%ld&s=10"];
}
/***/
+ (NSString *)urlStringFor_mytsbyid{
    return [self stringWithBasic:@"act=mytsbyid&cpid=%@"];
}


/**个人中心根据cpid获取投诉详情*/
+ (NSString *)urlStringForDetail{
    return [self stringWithBasic:@"act=detail&cpid=%@"];
}
/**插卡撤诉未成功原因*/
+ (NSString *)urlString_delComNoReason{
    return [self stringWithBasic:@"act=delComNoReason&cpid=%@"];
}

/**申请撤诉-原因选择列表*/
+ (NSString *)urlString_delComTypeList{
    return [self stringWithBasic:@"act=delComTypeList"];
}


/**我的评论*/
+ (NSString *)urlStringForComplainScore{
    return [self stringWithBasic:@"act=complainscore&cpid=%@&score=%ld"];
}


/**修改密码*/
+ (NSString *)urlStringForUpdatePWD{
    return [self stringWithBasic:@"act=updatepwd&uid=%@&oldpwd=%@&newpwd=%@"];
}


/**申请撤诉*/
+ (NSString *)urlStringForCancelComplain{
    return [self stringWithBasic:@"act=cancelComplain"];
}


/**获取地区*/
+ (NSString *)urlStringForGetPersonalAddress{
    return [self stringWithBasic:@"act=getPersonalAddress&uid=%@"];
}


/**市*/
+ (NSString *)urlStringForCity{
    return [self stringWithBasic:@"act=city&pid=%@"];
}


/**县*/
+ (NSString *)urlStringForArea{
    return [self stringWithBasic:@"act=area&cid=%@"];
}


/**提交地区*/
+ (NSString *)urlStringForUpdatePersonalAddress{
    return [self stringWithBasic:@"act=updatePersonalAddress&uid=%@&realname=%@&pid=%@&cid=%@&aid=%@&pname=%@&cname=%@&aname=%@&address=%@&postcode=%@"];
}


/**提交用户信息*/
+ (NSString *)urlStringForpersonalInfo{
    return [self stringWithBasic:@"act=personalInfo&uid=%@&realname=%@&gender=%@&birth=%@&email=%@&mobile=%@&qq=%@&telephone=%@&bid=%@&bname=%@&sid=%@&sname=%@&mid=%@&mname=%@"];
}


/**我的评论*/
+ (NSString *)urlStringForDiscuss{
    return [self stringWithBasic:@"act=discuss&uid=%@&p=%ld&s=10"];
}


/**上传头像*/
+ (NSString *)urlStringForUploadAvatar{
    return [self stringWithBasic:@"act=uploadAvatar&uid=%@"];
}

/**我的提问*/
+ (NSString *)urlStringFor_myZJDY{
    return [self stringWithBasic:@"act=myZJDY&uid=%@&p=%ld&s=10"];
}


/** 找回密码*/
+ (NSString *)urlString_sendemail{
    return [self stringWithBasic:@"act=sendemail&username=%@&origin=%@"];
}
#pragma mark - 数据对比
/**对比*/
+ (NSString *)urlString_mConfig{
    //(车系id,车型id)sid=%@&mid=%@
    //不传参数则为左侧第一列名称，传参数则为右边值
    return [self stringForCZWServiceWithAct:@"act=mConfig"];
}
/**头部概括信息*/
+ (NSString *)urlString_dbInfo{
    //bid-品牌，sid-车系，mid-车型
    return [self stringForCZWServiceWithAct:@"act=dbInfo&bid=%@&sid=%@&mid=%@"];
}

@end
