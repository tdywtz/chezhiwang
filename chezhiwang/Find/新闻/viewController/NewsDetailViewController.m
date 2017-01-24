//
//  NewsDetailViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "LoginViewController.h"
#import "CommentListViewController.h"
#import "WriteViewController.h"
#import "FootCommentView.h"
#import "CZWShareViewController.h"//分享


@interface NewsDetailViewController ()<UIWebViewDelegate,FootCommentViewDelegate>
{
    UIWebView *_webView;
    FootCommentView *footView;

    UIImage *shareImage;
}

@property (nonatomic,strong) NSDictionary *dictionary;

@end

@implementation NewsDetailViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
-(void)loadData{

    NSString *type = @"1";
    if (_invest) {
         // 调查
        type = @"3";
    }
    NSString *url = [URLFile url_newsinfoWithID:_ID sid:_sid type:type];
 
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];

    [HttpRequest GET:url success:^(id responseObject) {
     
        self.dictionary = [responseObject copy];
        [footView setReplyConut:responseObject[@"replycount"]];
        if (responseObject[@"content"] == nil) {
            self.backgroundView.hidden = NO;
            self.backgroundView.contentLabel.text = @"暂无数据";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        NSMutableString *newsContentHTML = [NSMutableString stringWithFormat:@"<style>body{padding:0 5px;}</style>%@",responseObject[@"content"]];

        NSRange range = range = [newsContentHTML rangeOfString:@"src=\"/"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"http://www.12365auto.com" atIndex:range.location+range.length-1];
            range = [newsContentHTML rangeOfString:@"src=\"/"];
        }

        NSString *width = [[NSString alloc] initWithFormat:@" style='max-width:%fpx'",WIDTH-30];
        range = [newsContentHTML rangeOfString:@"<IMG" options:NSCaseInsensitiveSearch range:NSMakeRange(0, newsContentHTML.length)];
        while (range.length != 0) {
            [newsContentHTML insertString:width atIndex:range.location+range.length];
         NSRange tempRange = NSMakeRange(range.location+range.length, newsContentHTML.length-range.location-range.length);
          range = [newsContentHTML rangeOfString:@"<IMG" options:NSCaseInsensitiveSearch range:tempRange];
        }
        range = [newsContentHTML rangeOfString:@"<img" options:NSCaseInsensitiveSearch range:NSMakeRange(0, newsContentHTML.length)];
        while (range.length != 0) {
            [newsContentHTML insertString:width atIndex:range.location+range.length];
            NSRange tempRange = NSMakeRange(range.location+range.length, newsContentHTML.length-range.location-range.length);
            range = [newsContentHTML rangeOfString:@"<img" options:NSCaseInsensitiveSearch range:tempRange];
        }


        [_webView loadHTMLString:newsContentHTML baseURL:nil];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新闻";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItem];
    [self createContent];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self writeData];
}


- (void)setShareImageUrl:(NSString *)shareImageUrl{
    _shareImageUrl = shareImageUrl;

    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:shareImageUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {

        shareImage = image;
    }];
}

//浏览记录
-(void)writeData{
    if (self.ID) {
        NSString *str = self.dictionary[@"title"] == nil?@"":self.dictionary[@"title"];
        FmdbManager *manager = [FmdbManager shareManager];
        [manager insertIntoReadHistoryWithId:self.ID andTitle:str andType:ReadHistoryTypeNews];
    }
}

-(void)createContent{

    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;

    footView = [[FootCommentView alloc] initWithFrame:CGRectZero];
    footView.delegate = self;
    
    [self.view addSubview:_webView];
    [self.view addSubview:footView];


    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake( self.contentInsets.top, 0, 49, 0));
    }];

    [footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(49);
    }];
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
        btn.contentMode = UIViewContentModeScaleAspectFit;
        btn.tag = 100+i;

        if (i == 1) {
            btn.frame = CGRectMake(0, 0, 23, 23);
            [btn setBackgroundImage:[UIImage imageNamed:@"comment_收藏"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"comment_收藏_yes"] forState:UIControlStateSelected];
            btn.selected = isSelect;
        }else{

            [btn setBackgroundImage:[UIImage imageNamed:@"comment_转发"] forState:UIControlStateNormal];
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
       
        [self shareWeb];

    }else{
        btn.selected = !btn.selected;
        if (btn.selected) {
            [self favorate];
        }else{
            [self deleteFavorate];
        }
    }
}

- (void)shareWeb{
    CZWShareViewController *share = [[CZWShareViewController alloc] initWithParentViewController:self];
    share.shareUrl = self.dictionary[@"url"];
    share.shareImage = shareImage;
    NSString *html = [_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    share.shareContent = html;
    share.shareTitle = self.dictionary[@"title"];

    [self presentViewController:share animated:YES completion:nil];
}


#pragma mark - 收藏
-(void)favorate{

    if (self.dictionary[@"title"] && self.dictionary[@"date"] && self.ID) {
        FmdbManager *fb = [FmdbManager shareManager];
        [fb insertIntoCollectWithId:self.ID andTime:self.dictionary[@"date"] andTitle:self.dictionary[@"title"] andType:collectTypeNews];
        [LHController alert:@"收藏成功"];
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:self.ID andType:collectTypeNews];
     [LHController alert:@"取消收藏成功"];
}


#pragma mark - 提交评论
-(void)submitComment:(NSString *)content{
    if (![LHController judegmentSpaceChar:content]) {
        [LHController alert:@"评论内容不能为空"];
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"uid"] = [CZWManager manager].userID;//用户id
    dict[@"fid"] = @"0";//回复的评论对象id（若是回复当前新闻为0或不设置）
    dict[@"content"] = content;//回复内容
    dict[@"tid"] = self.ID?self.ID:self.dictionary[@"id"];//回复新闻的id
    dict[@"origin"] = appOrigin;
    //类型（新闻-1、投诉-2、答疑-3,调查-5）
    if (self.invest) {
        dict[@"type"] = @"5";
    }else{
        dict[@"type"] = @"1";
    }

    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {

        if (responseObject[@"success"]) {
            [LHController alert:responseObject[@"success"]];
            [footView addReplyCont];

        }else{
            [LHController alert:@"评论失败"];
        }

    } failure:^(NSError *error) {
        [LHController alert:@"发送失败"];
    }];
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('hscolor')[0].style.webkitTextFillColor='#999'"];
     [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('divmargin')[0].style.marginBottom='70px'"];
   // [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('p').style.lineHeight='180%'"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
      [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - FootCommentViewDelegate
- (void)clickButton:(NSInteger)slected{
    if (slected == 0) {

        if ([CZWManager manager].isLogin) {
            WriteViewController *commentView = [[WriteViewController alloc] init];
            [commentView send:^(NSString *content) {
                [self submitComment:content];
            }];
     
            [self presentViewController:commentView animated:YES completion:nil];
        }else{

            [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        }
    }else{
        CommentListViewController *comment = [[CommentListViewController alloc] init];
        comment.type = self.invest?NewsTypeResearch:NewsTypeNews;
        comment.cid = self.ID?self.ID:self.dictionary[@"id"];
        [self.navigationController pushViewController:comment animated:YES];
    }
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
