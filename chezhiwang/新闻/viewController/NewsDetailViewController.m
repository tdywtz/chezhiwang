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

@interface NewsDetailHeaderView : UIView

@property (nonatomic,strong) TTTAttributedLabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *editorLabel;

- (CGFloat)viewHeight;

@end

@implementation NewsDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.lineSpacing = 4;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:PT_FROM_PX(26.5)];

        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(17)];
        self.dateLabel.textColor = RGB_color(153, 153, 153, 1);

        self.editorLabel = [[UILabel alloc] init];
        self.editorLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(17)];
        self.editorLabel.textColor = RGB_color(153, 153, 153, 1);

        [self addSubview:self.titleLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.editorLabel];

        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.lessThanOrEqualTo(WIDTH-26);
            make.top.equalTo(20);
        }];

        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.bottom).offset(20);
            make.right.equalTo(-13);
            make.bottom.equalTo(0);

        }];

        [self.editorLabel makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(13);
            make.bottom.equalTo(self.dateLabel);
        }];

    }
    return self;
}

- (CGFloat)viewHeight{
    [self.dateLabel setNeedsLayout];
    [self.dateLabel layoutIfNeeded];

    return (self.dateLabel.frame.size.height+self.dateLabel.frame.origin.y+40);
}
@end

#pragma mark - &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

@interface NewsDetailViewController ()<UIWebViewDelegate,FootCommentViewDelegate>
{
    NewsDetailHeaderView *headerView;
    UIWebView *_webView;
    FootCommentView *footView;

    UIImage *shareImage;
}

@property (nonatomic,strong) NSDictionary *dictionary;

@end

@implementation NewsDetailViewController

-(void)loadData{


    NSString *url = [NSString stringWithFormat:[URLFile urlStringForNewsinfo],self.ID,@"1"];
    if (self.invest) {
        url = [NSString stringWithFormat:[URLFile urlStringForNewsinfo],self.ID,@"3"];
        // 调查页面过来的
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpRequest GET:url success:^(id responseObject) {

        self.dictionary = [responseObject copy];

        headerView.titleLabel.text = responseObject[@"title"];
        headerView.dateLabel.text = responseObject[@"date"];
        if ([responseObject[@"author"] length]) {
             headerView.editorLabel.text = [NSString stringWithFormat:@"%@   编辑：%@",responseObject[@"source"],responseObject[@"author"]];
        }else{
            headerView.editorLabel.text = responseObject[@"source"]; 
        }

        [footView setReplyConut:responseObject[@"replycount"]];
//重置头部位置
        CGFloat height = [headerView viewHeight];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        [headerView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(-height);
        }];

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
        [_webView loadHTMLString:newsContentHTML baseURL:nil];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新闻";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItem];
    [self createContent];

    [self loadData];
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
    NSString *str = self.dictionary[@"title"] == nil?@"":self.dictionary[@"title"];
    FmdbManager *manager = [FmdbManager shareManager];
    [manager insertIntoReadHistoryWithId:self.ID andTitle:str andType:ReadHistoryTypeNews];
}

-(void)createContent{

    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    _webView.delegate = self;

    footView = [[FootCommentView alloc] initWithFrame:CGRectZero];
    footView.delegate = self;
    
    [self.view addSubview:_webView];
    [self.view addSubview:footView];


    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 49, 0));
    }];

    [footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(49);
    }];

//头部标题
    headerView = [[NewsDetailHeaderView alloc] initWithFrame:CGRectZero];
    [_webView.scrollView addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.width.equalTo(WIDTH);
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
       
        CZWShareViewController *share = [[CZWShareViewController alloc] initWithParentViewController:self];
        share.shareUrl = self.dictionary[@"url"];
        share.shareImage = shareImage;
        NSString *html = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
        if (html.length > 100) html = [html substringToIndex:99];
        share.shareContent = html;
        share.shareTitle = self.dictionary[@"title"];
        NSLog(@"%@",shareImage);
        [self presentViewController:share animated:YES completion:nil];

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
    [dict setObject:content forKey:@"content"];//回复内容
    [dict setObject:self.ID forKey:@"tid"];//回复新闻的id
    //类型（新闻-1、投诉-2、答疑-3,调查-5）
    if (self.invest) {
        dict[@"type"] = @"5";
    }else{
        dict[@"type"] = @"1";
    }

    [dict setObject:appOrigin forKey:@"origin"];

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
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
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
        comment.cid = self.ID;
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
