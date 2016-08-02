//
//  ComplainDetailsViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainDetailsViewController.h"
#import "CommentListViewController.h"
#import "LoginViewController.h"
#import "CustomCommentView.h"
#import "CZWShareViewController.h"


@interface ComplainDetailsViewController ()
{
    UIScrollView *scrollView;
    UIView *sview;
    CustomCommentView *_commentView;

    UILabel *numLabel;
    NSString *http;
    BOOL isAhare;
    
    CGFloat B;
    
    CZWLabel *titleLabel;//标题
    CZWLabel *parameterLabel;//参数
    CZWLabel *questionContent;//问题内容
    CZWLabel *answerContent;//回复内容
}
@property (strong,nonatomic) UIView *contentView;

@end

@implementation ComplainDetailsViewController

- (void)dealloc
{

    [sview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadDataOne{
    
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForComplain],_cid];
   [HttpRequest GET:url success:^(id responseObject) {
       if ([responseObject count] == 0) {
           return ;
       }
       self.dict = responseObject[0];
       
       [self setData];
      
   } failure:^(NSError *error) {
       
   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    B = [LHController setFont];
    http = @"";
    
    [self createRightItems];
    [self createBgView];
    [self createScrollView];
    [self createScrollViewSubViews];
    [self createFootView];
   
    [self loadDataOne];
}

- (void)createBgView{
    sview = [[UIView alloc] initWithFrame:self.view.bounds];
    sview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    sview.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:sview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [sview addGestureRecognizer:tap];
}

#pragma mark - 背景界面手势
-(void)tap:(UIGestureRecognizer *)tap{
    sview.hidden = YES;
}

-(void)createRightItems{
    FmdbManager *fb = [FmdbManager shareManager];
    collectType type;
    if ([self.type isEqualToString:@"2"]) {
        type = collectTypeCompalin;
    }else{
        type = collectTypeAnswer;
    }
    NSDictionary *dict = [fb selectFromCollectWithId:_cid andType:type];
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
        btn.center = CGPointMake(bg.frame.size.width/2, bg.frame.size.height/2);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
        [btnArray addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems = btnArray;
}

-(void)rightItemClick:(UIButton *)btn{

    if (btn.tag == 101) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [self favorate];
        }else{
            [self deleteFavorate];
        }
    }else{
        CZWShareViewController *share = [[CZWShareViewController alloc] initWithParentViewController:self];
        share.shareUrl = self.dict[@"url"]== nil?self.dict[@"FilePath"]:self.dict[@"url"];
        share.shareImage = [UIImage imageNamed:@"Icon-60"];
        NSString *html = self.dict[@"content"] == nil?self.dict[@"Content"]:self.dict[@"content"];
        if (html.length > 100) html = [html substringToIndex:99];
        share.shareContent = html;
        share.shareTitle = self.textTitle;
        [share setBluffImageWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        [self presentViewController:share animated:YES completion:nil];
    }
}

#pragma mark - 滚动视图
-(void)createScrollView{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = YES;
    [self.view addSubview:scrollView];
}

#pragma mark -
-(void)createScrollViewSubViews{
    
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(WIDTH);
    }];
    
    titleLabel = [[CZWLabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    parameterLabel = [[CZWLabel alloc] init];
    parameterLabel.font = [UIFont systemFontOfSize:13];
    parameterLabel.textColor = colorLightGray;
    parameterLabel.backgroundColor = colorLineGray;
    parameterLabel.linesSpacing = 4;
    parameterLabel.textInsets = UIEdgeInsetsMake(10, 5, 10, 5);
    
    UILabel *complainTitle = [LHController createLabelWithFrame:CGRectZero Font:B-3 Bold:NO TextColor:colorLightGray Text:@"投诉内容："];
    
    questionContent = [[CZWLabel alloc] init];
    questionContent.firstLineHeadIndent = 28;
    questionContent.textColor = colorDeepGray;
    questionContent.linesSpacing = 4;
    questionContent.font = [UIFont systemFontOfSize:14];
    
    UILabel *answerTitle = [LHController createLabelWithFrame:CGRectZero Font:B-3 Bold:NO TextColor:colorLightGray Text:@"投诉回复："];
    
    answerContent = [[CZWLabel alloc] init];
    answerContent.linesSpacing = 4;
    answerContent.firstLineHeadIndent = 28;
    answerContent.textColor = colorDeepGray;
    answerContent.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:parameterLabel];
    [self.contentView addSubview:complainTitle];
    [self.contentView addSubview:questionContent];
    [self.contentView addSubview:answerTitle];
    [self.contentView addSubview:answerContent];
   
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.centerX.equalTo(0);
        make.width.lessThanOrEqualTo(WIDTH-30);
    }];
    

    [parameterLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.bottom).offset(20);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    [complainTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parameterLabel);
        make.top.equalTo(parameterLabel.bottom).offset(20);
    }];
    
    [questionContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(complainTitle.bottom).offset(10);
        make.right.equalTo(-15);
    }];
    
    [answerTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(questionContent.bottom).offset(20);
    }];
    
    [answerContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(answerTitle.bottom).offset(10);
        make.right.equalTo(-15);
        make.bottom.equalTo(-20);
    }];
    
}


- (void)setData{
    titleLabel.text = _textTitle;

    NSArray *array = @[@"投诉编号：",@"投诉品牌：",@"投诉车系：",@"投诉车型：",@"投诉时间："];
    NSArray *arr = @[@"id",@"brand",@"series",@"model",@"date"];

    NSString *text = nil;
    for (int i = 0; i < arr.count; i ++) {
        NSString *str = _dict[arr[i]];
        if (i == 0) {
            str = [NSString stringWithFormat:@"[%@]",str];
            text = [NSString stringWithFormat:@"%@%@",array[i],str];
        }else{
            str = [NSString stringWithFormat:@"%@%@",array[i],str];
            text = [NSString stringWithFormat:@"%@\n%@",text,str];
        }
    }
    
    parameterLabel.text = text;
    for (int i = 0; i < array.count; i ++) {
        NSString *str = array[i];
        [parameterLabel addColor:colorDeepGray range:[parameterLabel.text rangeOfString:str]];
    }

    
    answerContent.text =  _dict[@"answer"];;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray:[self.dict[@"image"] componentsSeparatedByString:@"||"]];
    [imageArray removeObject:@""];
  
    if (imageArray.count == 0) {
        questionContent.text =  _dict[@"content"];
        return;
    }else{
        NSString *textString = nil;
        for (int i = 0; i < imageArray.count;  i ++) {
            if (i == 0) {
                textString = [NSString stringWithFormat:@"%d",i];
            }else{
                textString = [NSString stringWithFormat:@"%@\n\n%d",textString,i];
            }
        }
        questionContent.text = [NSString stringWithFormat:@"%@\n\n%@",textString,_dict[@"content"]];
    }
   
    

    for (int i = 0; i < imageArray.count; i ++) {
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[self urlString:imageArray[i]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (image) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    CGFloat sx = (WIDTH-20)/image.size.width;
                    CGSize size = CGSizeMake(WIDTH-20, image.size.height*sx);
                    NSString *str = [NSString stringWithFormat:@"%d",i];
                    [questionContent addImage:image size:size range:[questionContent.text rangeOfString:str]];
                });
            }
        }];
    }
}


-(NSURL *)urlString:(NSString *)str{
    NSString *string = str;
    
    if (![str hasPrefix:@"http"]) {
        string = [NSString stringWithFormat:@"http://www.12365auto.com%@",str];
    }
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:string];
}


#pragma mark - 底部横条
-(void)createFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1];
    [self.view addSubview:view];
   
    UIButton *write =  [LHController createButtnFram:CGRectMake(10, 10,WIDTH-80, 28) Target:self Action:@selector(writeClick) Text:nil];
    write.backgroundColor = [UIColor whiteColor];
    [view addSubview:write];

    [write setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [write setTitle:@"写评论" forState:UIControlStateNormal];
    [write setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [write setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    write.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *btn = [LHController createButtnFram:CGRectMake(write.frame.origin.x+write.frame.size.width+10, 9, 30, 30) Target:self Action:@selector(btnClick:) Text:nil];
     [btn setImage:[UIImage imageNamed:@"share1"] forState:UIControlStateNormal];
    [view addSubview:btn];
    numLabel = [LHController createLabelWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width, btn.frame.origin.y, 20, 30) Font:B-3 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    numLabel.textColor = [UIColor whiteColor];
    [view addSubview:numLabel];
    [self loadDataTotal];
}
//


#pragma mark - 取得总评论数
-(void)loadDataTotal{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPL_total],_cid,self.type];
    [HttpRequest GET:url success:^(id responseObject) {
        NSDictionary *dict = responseObject[0];
        numLabel.text = dict[@"count"] == nil?@"0":dict[@"count"];
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
    }];
}

#pragma mark - 底部右侧按钮响应方法
-(void)btnClick:(UIButton *)btn{
    
    CommentListViewController *uct = [[CommentListViewController alloc] init];
    uct.cid = _cid;
    uct.type = self.type;
    uct.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:uct animated:YES];
        
}

#pragma mark - 收藏
-(void)favorate{
    
    if (self.textTitle && self.dict[@"date"] && self.cid) {
        FmdbManager *fb = [FmdbManager shareManager];
        [fb insertIntoCollectWithId:self.cid andTime:self.dict[@"date"] andTitle:self.textTitle andType:collectTypeCompalin];
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:_cid andType:collectTypeCompalin];
}

#pragma mark - 点击评论按钮
-(void)writeClick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        _commentView = [[CustomCommentView alloc] init];
        [_commentView show];
        [_commentView send:^(NSString *content) {
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
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:user_id] forKey:@"uid"];
    [dict setObject:@"0" forKey:@"fid"];
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.cid forKey:@"tid"];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:appOrigin forKey:@"origin"];
    
        [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {
            [self loadDataTotal];
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [LHController alert:@"评论成功"];
                [self loadDataTotal];
            }else{
                [LHController alert:@"评论失败"];
            }

        } failure:^(NSError *error) {
             [LHController alert:@"评论失败"];
        }];
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
