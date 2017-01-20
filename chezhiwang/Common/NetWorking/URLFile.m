//
//  URLFile.m
//  12365auto
//
//  Created by bangong on 16/5/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "URLFile.h"

@implementation URLFile


/**车质网专用*/
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
   // return  @"http://m.12365auto.com";
    return  @"http://192.168.1.114:8888";
#else
    return  @"http://m.12365auto.com";
#endif
}

#pragma mark - 接口-——————————》》》》》
/**注册协议*/
+ (NSString *)urlStringRegistrationAgreement{
    return [NSString stringWithFormat:@"%@%@",[self prefixString],@"/user/agreeForIOS.shtml"];
}

//广告
+ (NSString *)url_DTopAdv{
    return [NSString stringWithFormat:@"%@%@",[self prefixString],@"/AppServer/forAdvService.ashx?act=czw_dt"];
}

/**登录*/
+ (NSString *)urlStringForLogin{
    
    return [self stringForCommonServiceWithAct:@"act=login"];
}

/**注册*/
+ (NSString *)urlStringForRegister{
    return [self stringForCommonServiceWithAct:@"act=reg"];
}

#pragma mark- 车型图片
/**车型图片-根据参数获取车型图片列表*/
+ (NSString *)urlString_modelPlicList{
    // attr 车型属性
    // bid  品牌
    // sid  车系
    // mid  车型
    return [self stringForCZWServiceWithAct:@"act=modelPicList"];
}
/**车型图片-品牌大全*/
+ (NSString *)urlString_picBrand{
    return [self stringForCZWServiceWithAct:@"act=picBrand"];
}
/*车型图片-车系大全*/
+ (NSString *)urlString_picSeries{
    return [self stringForCZWServiceWithAct:@"act=picSeries&bid=%@"];
}

#pragma mark - homepage
/**首页*/
+ (NSString *)urlStringForLogin_index{
    return [self stringForCZWServiceWithAct:@"act=index"];
}

#pragma mark - 新闻
/**新闻列表*/
+ (NSString *)url_newslistWithStyle:(NSString *)style title:(NSString *)title sid:(NSString *)sid{
    //style : 新闻分类
    //title :  搜索时使用
    //sid : 查找车系下新闻
    NSString *url = [self stringForCZWServiceWithAct:@"act=newslist"];
    if (style) {
        url = [NSString stringWithFormat:@"%@&style=%@",url,style];
    }
    if (title) {
        url = [NSString stringWithFormat:@"%@&title=%@",url,title];
    }
    if (sid) {
        url = [NSString stringWithFormat:@"%@&sid=%@",url,sid];
    }
    return url;
}

/**新闻-调查*/
+ (NSString *)urlStringForReport{
    //t : 车型属性
    return  [self stringForCZWServiceWithAct:@"act=reportlist&t=%@%@"];
}

/**新闻详情、type: 调查新闻3，其他新闻1 */
+ (NSString *)url_newsinfoWithID:(NSString *)ID sid:(NSString *)sid type:(NSString *)type{
    NSString *parameter = @"act=newsinfo";
    if (ID) {
        parameter = [NSString stringWithFormat:@"%@&id=%@",parameter,ID];
    }
    if (sid) {
        parameter = [NSString stringWithFormat:@"%@&sid=%@",parameter,sid];
    }
    parameter = [NSString stringWithFormat:@"%@&type=%@",parameter,type];

    return [self stringForCZWServiceWithAct:parameter];
}

/**精品试驾list*/
+ (NSString *)urlString_testDrive{
    return [self stringForCZWServiceWithAct:@"act=testDrive&bid=%@&sid=%@&mattr=%@&battr=%@&dep=%@&p=%ld&s=10"];
}

/**新闻搜索*/
+ (NSString *)urlStringForNewsSearch{
    return [self stringForCZWServiceWithAct:@"act=newslist&style=%@&title=%@&p=%ld&s=%ld"];
}

#pragma mark - 投诉排行
/**排行榜-页面查询条件*/
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
+ (NSString *)url_complainlistWithTitle:(NSString *)title sid:(NSString *)sid p:(NSInteger)p s:(NSInteger)s{

    NSString *parameter = @"act=complainlist";
    if (title) {
        parameter = [NSString stringWithFormat:@"%@&title=%@",parameter,title];
    }
    if (sid) {
        parameter = [NSString stringWithFormat:@"%@&sid=%@",parameter,sid];
    }
    parameter = [NSString stringWithFormat:@"%@&p=%ld&s=%ld",parameter,p,s];
    return [self stringForCommonServiceWithAct:parameter];
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
    //id：   文章编号
    //type :   1：新闻，2：投诉，3：答疑  5：新车调查
    return [self stringForCommonServiceWithAct:@"act=pl&id=%@&type=%@&p=%ld&s=10"];
}

/**提交评论*/
+ (NSString *)urlStringForAddcomment{
    return [self stringForCommonServiceWithAct:@"act=addpl"];
}

/**大品牌*/
+ (NSString *)urlStringForLetter{
    return [self stringForCommonServiceWithAct:@"act=brandlist"];
}


/**车系*/
+ (NSString *)urlStringForSeries{
    //id ： 品牌id
    return [self stringForCommonServiceWithAct:@"act=serieslist&id=%@"];
}

/**车型*/
+ (NSString *)urlStringForModelList{
    //sid ： 车系id
    return [self stringForCommonServiceWithAct:@"act=modellist&sid=%@"];
}

/**获取省份*/
+ (NSString *)urlStringForPro{
    return [self stringForCommonServiceWithAct:@"act=pro"];
}

/**获取经销商城市*/
+ (NSString *)urlStringForDisCity{
    return [self stringForCommonServiceWithAct:@"act=discity&pid=%@"];
}

/**获取经销商*/
+ (NSString *)urlStringForDis{
    return  [self stringForCommonServiceWithAct:@"act=dis&pid=%@&cid=%@&sid=%@"];
}

/**提交、修改投诉*/
+ (NSString *)urlStringForProgressComplain{
    return [self stringForCommonServiceWithAct:@"act=addcomplain"];
}

#pragma mark -答疑
/**答疑列表*/
+ (NSString *)url_zjdylistWithTitle:(NSString *)title sid:(NSString *)sid t:(NSString *)t p:(NSInteger)p{
    //title : 搜索时使用
    //t     : 答疑分类
    //sid   : 车系答疑
    NSString *parameter =@"act=zjdylist";
    if (title) {
        parameter = [NSString stringWithFormat:@"%@&title=%@",parameter,title];
    }
    if (sid) {
        parameter = [NSString stringWithFormat:@"%@&sid=%@",parameter,sid];
    }
    if (t) {
        parameter = [NSString stringWithFormat:@"%@&t=%@",parameter,t];
    }
    parameter = [NSString stringWithFormat:@"%@&p=%ld&s=10",parameter,p];

    return [self stringForCommonServiceWithAct:parameter];
}


/**答疑搜索*/
+ (NSString *)urlStringForZJDYSearch{
    return [self stringForCommonServiceWithAct:@"act=zjdylist&title=%@&p=%ld&s=%ld"];
}

/**我要提问*/
+ (NSString *)urlStringForEditZJDY{
    return  [self stringForCommonServiceWithAct:@"act=editZJDY"];
}

/**答疑详情*/
+ (NSString *)urlStringForGetZJDY{
    return [self stringForCommonServiceWithAct:@"act=zjdyinfo&id=%@"];
}

#pragma mark - 论坛
/**论坛列表*/
+ (NSString *)urlStringForPostList{
    return [self stringForCZWServiceWithAct:@"act=bbslist&order=%ld&topic=%ld&p=%ld&s=10"];
}
/**帖子内容*/
+ (NSString *)urlStringForBBSContent{
    return [NSString stringWithFormat:@"%@%@",[self prefixString],@"/AppServer/forBBSContent.aspx?tid=%@"];
}

/**论坛分类->品牌论坛->指定论坛*/
+ (NSString *)urlStringForSeriesForm
{
    return [self stringForCZWServiceWithAct:@"act=bbsseries&sid=%@"];
}
/**论坛分类->栏目论坛->指定论坛*/
+ (NSString *)urlString_columnform{
    return [self stringForCZWServiceWithAct:@"act=bbscolumn&cid=%@"];
}
/**回复帖子*/
+ (NSString *)urlStringForReplyPost{
    return [self stringForCZWServiceWithAct:@"act=replypost"];
}
/**回复其中一条评论*/
+ (NSString *)urlStringForReplyFloor{
    return [self stringForCZWServiceWithAct:@"act=replyfloor"];
}
/**申请版主*/
+ (NSString *)urlStringForApplyOwner{
    return [self stringForCZWServiceWithAct:@"act=applyOwner"];
}
/**发表帖子*/
+ (NSString *)urlStringForNewTopic{
    return [self stringForCZWServiceWithAct:@"act=newtopic"];
}
/**申请版主-下载用户数据*/
+ (NSString *)urlString_getApplyOwner{
    return [self stringForCZWServiceWithAct:@"act=getApplyOwner&uid=%@"];
}
/**论坛分类->品牌论坛->论坛列表*/
+ (NSString *)urlStringForBrand_postlist{
    return [self stringForCZWServiceWithAct:@"act=bbslist&sid=%@&order=%ld&topic=%ld&p=%ld&s=10"];
}
/**论坛分类->栏目论坛->论坛列表*/
+ (NSString *)urlStringForColumn_postlist{
    return  [self stringForCZWServiceWithAct:@"act=bbslist&cid=%@&order=%ld&topic=%ld&p=%ld&s=10"];
}

#pragma mark - 找车--
/**发现-找车-车系综述 - 车型信息 评分*/
+ (NSString *)urlString_s_index{
    return [self stringForCommonServiceWithAct:@"act=s_index&sid=%@"];
}
/**发现-找车-车系综述 - 车型信息 车型故障统计*/
+ (NSString *)urlString_s_index2{
    return [self stringForCommonServiceWithAct:@"act=s_index2&sid=%@"];
}

/**发现-找车-投诉头部 满意度&回复率*/
+ (NSString *)url_s_complainWithSid:(NSString *)sid{
    NSString *parameter = [NSString stringWithFormat:@"act=s_complain&sid=%@",sid];
    return [self stringForCommonServiceWithAct:parameter];
}

#pragma mark-个人中心
/**获取用户信息*/
+ (NSString *)urlStringForUser{
    return [self stringForCommonServiceWithAct:@"act=user&uid=%@"];
}

/**个人中心*/
+ (NSString *)urlStringForPersonalCount{
    return [self stringForCommonServiceWithAct:@"act=personalCount&uid=%@"];
}


/**个人中心我的投诉列表*/
+ (NSString *)urlStringForMyTS{
    return [self stringForCommonServiceWithAct:@"act=mytslist&uid=%@&p=%ld&s=10"];
}
/**根据cpid获取一条投诉进度信息*/
+ (NSString *)urlStringFor_mytsbyid{
    return [self stringForCommonServiceWithAct:@"act=mytslist&cpid=%@"];
}

/**个人中心根据cpid获取投诉详情*/
+ (NSString *)urlStringForDetail{
    return [self stringForCommonServiceWithAct:@"act=tsdetail&cpid=%@"];
}

/**查看撤诉未成功原因*/
+ (NSString *)urlString_delComNoReason{
    return [self stringForCommonServiceWithAct:@"act=delComNoReason&cpid=%@"];
}

/**申请撤诉-原因选择列表*/
+ (NSString *)urlString_delComTypeList{
    return [self stringForCommonServiceWithAct:@"act=delComTypeList"];
}


/**提交评分*/
+ (NSString *)urlStringForComplainScore{
    return [self stringForCommonServiceWithAct:@"act=complainscore&cpid=%@&score=%ld"];
}


/**修改密码*/
+ (NSString *)urlStringForUpdatePWD{
    return [self stringForCommonServiceWithAct:@"act=updatepwd&uid=%@&oldpwd=%@&newpwd=%@"];
}


/**申请撤诉*/
+ (NSString *)urlStringForCancelComplain{
    return [self stringForCommonServiceWithAct:@"act=cancelComplain"];
}


/**获取地区*/
+ (NSString *)urlStringForGetPersonalAddress{
    return [self stringForCommonServiceWithAct:@"act=getMyAddress&uid=%@"];
}


/**市*/
+ (NSString *)urlStringForCity{
    return [self stringForCommonServiceWithAct:@"act=city&pid=%@"];
}


/**县*/
+ (NSString *)urlStringForArea{
    return [self stringForCommonServiceWithAct:@"act=area&cid=%@"];
}


/**提交地区*/
//+ (NSString *)urlStringForUpdatePersonalAddress{
//    return [self stringForCommonServiceWithAct:@"act=updateMyAddress&uid=%@&realname=%@&pid=%@&cid=%@&aid=%@&pname=%@&cname=%@&aname=%@&address=%@&postcode=%@"];
//}


/**提交用户信息*/
+ (NSString *)urlStringForpersonalInfo{
    //&uid=%@&realname=%@&gender=%@&birth=%@&email=%@&mobile=%@&qq=%@&telephone=%@&bid=%@&bname=%@&sid=%@&sname=%@&mid=%@&mname=%@"
    return [self stringForCommonServiceWithAct:@"act=u_updateinfo&uid=%@"];
}


/**我的评论*/
+ (NSString *)urlStringForDiscuss{
    return [self stringForCommonServiceWithAct:@"act=mypl&uid=%@&p=%ld&s=10"];
}


/**上传头像*/
+ (NSString *)urlStringForUploadAvatar{
    return [self stringForCommonServiceWithAct:@"act=uploadAvatar&uid=%@"];
}

/**我的提问*/
+ (NSString *)urlStringFor_myZJDY{
    return [self stringForCommonServiceWithAct:@"act=myzjdy&uid=%@&p=%ld&s=10"];
}


/** 找回密码*/
+ (NSString *)urlString_sendemail{
    return [self stringForCommonServiceWithAct:@"act=sendemail&username=%@&origin=%@"];
}

#pragma mark - 数据对比
/**对比-车型参数*/
+ (NSString *)urlString_mConfig{
    //(车系id,车型id)sid=%@&mid=%@
    //不传参数则为左侧第一列名称，传参数则为右边值
    return [self stringForCZWServiceWithAct:@"act=mConfig"];
}
/**对比-车型故障信息*/
+ (NSString *)urlString_dbInfo{
    //bid-品牌，sid-车系，mid-车型
    return [self stringForCZWServiceWithAct:@"act=dbInfo&bid=%@&sid=%@&mid=%@"];
}

@end
