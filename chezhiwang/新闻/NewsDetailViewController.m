//
//  NewsDetailViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "UMSocial.h"
#import "LoginViewController.h"
#import "CommentListViewController.h"
#import "CustomCommentView.h"

@interface NewsDetailViewController ()<UIWebViewDelegate,UITextViewDelegate>
{
    UILabel *_titleLabel;
    UILabel *_infoLabel;
    UIWebView *_webView;
    UIView *bgView;
    
    UIView *shareView;
    
    CustomActivity *activity;
}
@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation NewsDetailViewController
- (void)dealloc
{
    [bgView removeFromSuperview];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForNewsinfo],self.ID];
    if (self.invest) {
       // 调查页面过来的
        url = [NSString stringWithFormat:@"http://m.12365auto.com/server/forAppWebService.ashx?act=carownerinfo&id=%@",self.ID];
    }
    [HttpRequest GET:url success:^(id responseObject) {
        
        [activity animationStoping];
        if ([responseObject count] == 0) {
            return ;
        }
        self.dictionary = responseObject[0];
        // NSLog(@"%@",self.dictionary);
        _infoLabel.text = [NSString stringWithFormat:@"时间：%@   编辑：%@", self.dictionary[@"date"], self.dictionary[@"editor"]];
        
        NSMutableString *newsContentHTML = [NSMutableString stringWithFormat:@"<style>body{padding:0 10px;}</style>%@",self.dictionary[@"content"]];
        
        NSRange range = range = [newsContentHTML rangeOfString:@"src=\"/"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"http://www.12365auto.com" atIndex:range.location+range.length-1];
            range = [newsContentHTML rangeOfString:@"src=\"/"];
        }
        
        range = [newsContentHTML rangeOfString:@"<IMG"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"qq" atIndex:range.location+1];
            range = [newsContentHTML rangeOfString:@"<IMG"];
        }
        NSString *width = [[NSString alloc] initWithFormat:@"style='max-width:%fpx'",WIDTH-50];
        
        range = [newsContentHTML rangeOfString:@"<qqIMG"];
        while (range.length != 0) {
            [newsContentHTML deleteCharactersInRange:NSMakeRange(range.location+1, 2)];
            [newsContentHTML insertString:width atIndex:range.location+5];
            range = [newsContentHTML rangeOfString:@"<qqIMG"];
            
        }
        range = [newsContentHTML rangeOfString:@"<img"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"qq" atIndex:range.location+1];
            range = [newsContentHTML rangeOfString:@"<img"];
        }
        
        range = [newsContentHTML rangeOfString:@"<qqimg"];
        while (range.length != 0) {
            [newsContentHTML deleteCharactersInRange:NSMakeRange(range.location+1, 2)];
            [newsContentHTML insertString:width atIndex:range.location+5];
            range = [newsContentHTML rangeOfString:@"<qqimg"];
            
        }
        
        [_webView loadHTMLString:newsContentHTML baseURL:nil];
    } failure:^(NSError *error) {
         [activity animationStoping];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItem];
    [self createContent];
    [self createFootView];
    [self createActivity];
    [self loadData];
    //                                    [LHController getCustomTabBar].hidden = YES;
    [self writeData];
    [self createBGView];
}


-(void)createActivity{
    activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
    [self.view addSubview:activity];
    [activity animationStarting];
}

//浏览记录
-(void)writeData{
    NSString *str = self.titleLabelText == nil?@"":self.titleLabelText;
    FmdbManager *manager = [FmdbManager shareManager];
    [manager insertIntoReadHistoryWithId:self.ID andTitle:str andType:ReadHistoryTypeNews];
}

-(void)createContent{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 74, WIDTH, 20)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:view];
    
    CGSize size =[self.titleLabelText boundingRectWithSize:CGSizeMake(WIDTH-30, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[LHController setFont]]} context:nil].size;
 
    _titleLabel = [LHController createLabelWithFrame:CGRectMake(15, 84, WIDTH-30, size.height)  Font:[LHController setFont] Bold:NO TextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] Text:self.titleLabelText];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
     _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    
   
    _infoLabel = [LHController createLabelWithFrame:CGRectMake(20, 84+size.height+5, WIDTH-40, 20) Font:[LHController setFont]-5 Bold:NO TextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] Text:nil];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLabel];
    
    view.frame = CGRectMake(0, 74, WIDTH, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+5);
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+20, WIDTH, HEIGHT-49-_infoLabel.frame.origin.y-_infoLabel.frame.size.height-20)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}


-(void)createRightItem{
    FmdbManager *fb = [FmdbManager shareManager];
    NSDictionary *dict = [fb selectFromCollectWithId:self.ID andType:collectTypeNews];
    BOOL isSelect = NO;
    if ([dict allKeys].count > 0) {
        isSelect = YES;
    }
    NSMutableArray *btnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i ++) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        
        UIButton *btn = [LHController createButtnFram:CGRectMake(5, 0, 20, 20) Target:self Action:@selector(rightItemClick:) Text:nil];
        btn.tag = 100+i;
        NSString *iamgeName = [NSString stringWithFormat:@"share%d",3-i];
        [btn setBackgroundImage:[UIImage imageNamed:iamgeName] forState:UIControlStateNormal];
        if (i == 1) {
            btn.frame = CGRectMake(0, 0, 25, 25);
            [btn setBackgroundImage:[UIImage imageNamed:@"xin"] forState:UIControlStateSelected];
            btn.selected = isSelect;
        }
        [bg addSubview:btn];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
        [btnArray addObject:item];
        btn.center = CGPointMake(bg.frame.size.width/2, bg.frame.size.height/2);
    }
    self.navigationItem.rightBarButtonItems = btnArray;
}

-(void)rightItemClick:(UIButton *)btn{
    if (btn.tag == 100) {
        [self createShare];
    }else{
        btn.selected = !btn.selected;
        if (btn.selected) {
            [self favorate];
        }else{
            [self deleteFavorate];
        }
    }
}

#pragma mark - 收藏
-(void)favorate{
    
    if (self.titleLabelText && self.dictionary[@"date"] && self.ID) {
        FmdbManager *fb = [FmdbManager shareManager];
        [fb insertIntoCollectWithId:self.ID andTime:self.dictionary[@"date"] andTitle:self.titleLabelText andType:collectTypeNews];
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:self.ID andType:collectTypeNews];
}

#pragma mark - 分享
-(void)createShare{
    if (!shareView) {
         [self createShareView];
    }
    
    bgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = CGRectMake(0, HEIGHT-260, WIDTH, 260);
    }];
}

-(void)createShareView{
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 260)];
    shareView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:shareView];
    
    //NSArray *imageAray = @[];
    NSArray *array = @[@"QQ好友",@"微信朋友圈",@"微信",@"新浪微博",@"QQ空间",@"复制链接"];
    for (int i = 0; i < array.count; i ++) {
        
        UIButton *btn = [LHController createButtnFram:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3), 80, 80) Target:self Action:@selector(shareClick:) Text:nil];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fenxiang%d",i+1]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [shareView addSubview:btn];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3)+80, 80, 20) Font:[LHController setFont]-4 Bold:NO TextColor:nil Text:array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:label];
    }
}


-(void)shareClick:(UIButton *)btn{
    
    NSString *urlString = [NSString stringWithFormat:@"%@\n%@",self.titleLabelText,self.dictionary[@"url"]];
    UIImage *shareImage = [UIImage imageNamed:@"Icon-60"];
    NSString *html = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
    if (html.length > 100) html = [html substringToIndex:99];
    NSString *shareContent = html;
    NSString *shareTitle = self.titleLabelText;
    NSString *shareUrl = self.dictionary[@"url"];
    switch (btn.tag) {
        case 100:
        {
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qqData.title =shareTitle;
           // [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
        }
            break;
            
        case 101:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            //[UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"dasfas";
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;

            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 102:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            //[UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"dasfas";
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
            
        case 103:
        {
            
            [[UMSocialControllerService defaultControllerService] setShareText:urlString shareImage:nil socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
          //  isAhare = YES;
        }
            break;
            
        case 104:
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    // NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 105:
        {
            UIPasteboard *past = [UIPasteboard generalPasteboard];
            past.string = self.dictionary[@"url"];
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"复制成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [al show];
            [UIView animateWithDuration:0.3 animations:^{
                [al dismissWithClickedButtonIndex:0 animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
    
    shareView.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        bgView.hidden = YES;
    });

}


#pragma mark - 底部视图
-(void)createFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    footView.backgroundColor = [UIColor colorWithRed:6/255.0 green:143/255.0 blue:206/255.0 alpha:0.9];
    [self.view addSubview:footView];
    
    UIView *fg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    fg.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0  blue:170/255.0  alpha:1];
    [footView addSubview:fg];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(10, 10, WIDTH-29-50, 29) Target:self Action:@selector(commentClick) Text:@"写评论"];
    button.backgroundColor = [UIColor whiteColor];
    [footView addSubview:button];
    
    [button setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [button setTitle:@"写评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *btn = [LHController createButtnFram:CGRectMake(WIDTH-65, 10, 50, 29) Target:self Action:@selector(listCLick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"share1"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag = 100;
    [footView addSubview:btn];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [self loadDataTotal];
}

#pragma mark - 取得总评论数
-(void)loadDataTotal{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPL_total],self.ID,@"1"];
    [HttpRequest GET:url success:^(id responseObject) {
        NSDictionary *dict = responseObject[0];
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        NSString *num = dict[@"count"] == nil? @"0":dict[@"count"];
        [btn setTitle:num forState:UIControlStateNormal];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击评论条目按钮
-(void)listCLick{
    CommentListViewController *comment = [[CommentListViewController alloc] init];
    comment.type = @"1";
    comment.cid = self.ID;
    [self.navigationController pushViewController:comment animated:YES];
}

#pragma mark - 点击评论按钮
-(void)commentClick{
  
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        CustomCommentView *commentView = [[CustomCommentView alloc] init];
        [commentView show];
        [commentView send:^(NSString *content) {
            [self submitComment:content];
        }];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypePopView;
        [self.navigationController pushViewController:my animated:YES];
    }
}


#pragma mark - 提交评论
-(void)submitComment:(NSString *)content{
    if (![LHController judegmentSpaceChar:content]) {
        [LHController alert:@"评论内容不能为空"];
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:user_id] forKey:@"uid"];
    [dict setObject:@"0" forKey:@"fid"];
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.ID forKey:@"tid"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:appOrigin forKey:@"origin"];
    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [LHController alert:@"评论成功"];
            [self loadDataTotal];
        }else{
            [LHController alert:@"评论失败"];
        }

    } failure:^(NSError *error) {
          [LHController alert:@"发送失败"];
    }];
}

#pragma mark - 创建隔离背景
-(void)createBGView{
    bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    bgView.hidden = YES;
    [win addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [bgView addGestureRecognizer:tap];
}

#pragma mark - 手势
-(void)tap:(UITapGestureRecognizer *)tap{
    bgView.hidden = YES;
    shareView.frame = CGRectMake(0, HEIGHT, WIDTH, 200);
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
    [activity animationStoping];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([LHController stringContainsEmoji:text]){
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
