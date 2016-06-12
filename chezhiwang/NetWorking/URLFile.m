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
    NSString *basicString = @"http://m.12365auto.com/server/forAppWebService.ashx?";
    return [NSString stringWithFormat:@"%@%@",basicString,actString];
}

/**登录*/
+ (NSString *)urlStringForLogin{
    return [self stringWithBasic:@"act=login&uname=%@&psw=%@"];
}

/**注册*/
+ (NSString *)urlStringForRegister{
    return [self stringWithBasic:@"act=reg"];
}

#pragma mark - 新闻
/**新闻列表*/
+ (NSString *)urlStringForNewsList{
    return [self stringWithBasic:@"act=news&style=%@%@"];
}
/**焦点图片*/
+ (NSString *)urlStringForFocuspic{
    return [self stringWithBasic:@"act=focuspic"];
}
/**焦点新闻*/
+ (NSString *)urlStringForFocusnews{
    return [self stringWithBasic:@"act=focusnews"];
}
/**新闻-调查*/
+ (NSString *)urlStringForReport{
    return  [self stringWithBasic:@"act=report&t=%@%@"];
}

/**新闻详情*/
+ (NSString *)urlStringForNewsinfo{
    return [self stringWithBasic:@"act=newsinfo&id=%@"];
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


///**故障详情*/
//+ (NSString *)urlStringForCarInfo{
//    return [self stringWithBasic:@"act=CarInfo&id=%@"];
//}
//
///**全部故障*/
//+ (NSString *)urlStringForIssue{
//    return [self stringWithBasic:@"act=issue&seriesID=%@&year=%@&count=%@"];
//}

/**投诉列表*/
+ (NSString *)urlStringForZLTS{
    return [self stringWithBasic:@"act=zlts&p=%ld&s=%ld"];
}

/**投诉搜索*/
+ (NSString *)urlStringForZLTSWithSearch{
    return [self  stringWithBasic:@"act=zlts&title=%@&p=%ld&s=%ld"];
}

/**投诉列表->投诉详情*/
+ (NSString *)urlStringForComplain{
    return [self stringWithBasic:@"act=complain&id=%@"];
}

/**评论列表*/
+ (NSString *)urlStringForPL{
    return [self stringWithBasic:@"act=pl&id=%@&type=%@&p=%ld&s=%ld"];
}

/**评论总数*/
+ (NSString *)urlStringForPL_total{
    return [self stringWithBasic:@"act=pl&id=%@&type=%@"];
}

/**提交评论*/
+ (NSString *)urlStringForAddcomment{
    return [self stringWithBasic:@"act=addcomment"];
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
    return  @"http://m.12365auto.com/server/forCommonService.ashx?act=dis&pid=%@&cid=%@&sid=%@";
    //return [self stringWithBasic:@"act=dis&pid=%@&cid=%@&id=%@&bid=%@&sid=%@&name=%@&top=0"];
}


/**投诉*/
+ (NSString *)urlStringForProgressComplain{
    return [self stringWithBasic:@"act=progressComplain"];
}

#pragma mark -答疑
/**答疑列表*/
+ (NSString *)urlStringForZJDY{
    return [self stringWithBasic:@"act=zjdy&t=%@&p=%ld&s=%ld"];
}
/**答疑搜索*/
+ (NSString *)urlStringForZJDYSearch{
    return [self stringWithBasic:@"act=zjdy&title=%@&p=%ld&s=%ld"];
}
/**我要提问*/
+ (NSString *)urlStringForEditZJDY{
    return  [self stringWithBasic:@"act=editZJDY"];
}
/**答疑详情*/
+ (NSString *)urlStringForGetZJDY{
    return [self stringWithBasic:@"act=getzjdy&id=%@"];
}

#pragma mark - 论坛
/**论坛列表*/
+ (NSString *)urlStringForPostList{
    return [self stringWithBasic:@"act=postlist&order=%ld&topic=%ld&p=%ld&s=%ld"];
}
/**帖子内容*/
+ (NSString *)urlStringForPostInfo{
    return [self stringWithBasic:@"act=postinfo&tid=%@"];
}
/**论坛车系品牌*/
+ (NSString *)urlStringForOtherSeries{
    return  [self stringWithBasic:@"act=otherseries"];
}
/**指定论坛*/
+ (NSString *)urlStringForSeriesForm
{
    return [self stringWithBasic:@"act=seriesform&sid=%@"];
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
    return [self stringWithBasic:@"act=myts&uid=%@&p=%ld&s=%ld"];
}
/***/
+ (NSString *)urlStringFor_mytsbyid{
    return [self stringWithBasic:@"act=mytsbyid&cpid=%@"];
}


/**个人中心根据cpid获取投诉详情*/
+ (NSString *)urlStringForDetail{
    return [self stringWithBasic:@"act=detail&cpid=%@"];
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
    return [self stringWithBasic:@"act=discuss&uid=%@&p=%ld&s=%ld"];
}


/**上传头像*/
+ (NSString *)urlStringForUploadAvatar{
    return [self stringWithBasic:@"act=uploadAvatar&uid=%@"];
}

/**我的提问*/
+ (NSString *)urlStringFor_myZJDY{
    return [self stringWithBasic:@"act=myZJDY&uid=%@&p=%ld&s=%ld"];
}

@end
