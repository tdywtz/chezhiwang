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
#import "FootCommentView.h"

@interface ComplainDetailsViewController ()<FootCommentViewDelegate>
{
    UIView *sview;
    CustomCommentView *_commentView;

    CGFloat B;

    CZWLabel *titleLabel;//标题
    //参数
    UILabel  *idLabel;
    UILabel  *brandLabel;
    UILabel  *seriesLabel;
    UILabel  *modelLabel;
    UILabel  *dateLabel;
    CZWLabel *questionContent;//问题内容
    CZWLabel *answerContent;//回复内容

    FootCommentView *footView;
    UIImage *shareImage;
}
@property (nonatomic,assign) NewsType type;//类型
@property (nonatomic,strong) NSDictionary *dict;
@end

@implementation ComplainDetailsViewController

- (void)dealloc
{

    [sview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadDataOne{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForComplain],_cid];
    [HttpRequest GET:url success:^(id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        self.dict = responseObject;

        [self setData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"投诉";
    B = [LHController setFont];

    self.type = NewsTypeComplain;
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
    }];

    [self createRightItems];
    [self createBgView];
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
    NSDictionary *dict = [fb selectFromCollectWithId:_cid andType:collectTypeCompalin];
    BOOL isSelect = NO;
    if ([dict allKeys].count > 0) {
        isSelect = YES;
    }

    NSMutableArray *btnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i ++) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];

        UIButton *btn = [LHController createButtnFram:CGRectMake(5, 0, 20, 20) Target:self Action:@selector(rightItemClick:) Text:nil];
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
        share.shareUrl = self.dict[@"filepath"];
        share.shareImage = shareImage;
        share.shareContent = self.dict[@"content"];
        share.shareTitle = self.dict[@"title"];
        [self presentViewController:share animated:YES completion:nil];
    }
}

#pragma mark -
-(void)createScrollViewSubViews{

    titleLabel = [[CZWLabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.contentView addSubview:titleLabel];

    NSArray *leftTitles = @[@"投诉编号：",@"投诉品牌：",@"投诉车系：",@"投诉车型：",@"投诉时间："];

    NSArray *objectsString = @[@"idLabel",@"brandLabel",@"seriesLabel",@"modelLabel",@"dateLabel"];

    UIView *temp;
    for (int i = 0; i < 5; i ++) {
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.text = leftTitles[i];
        leftLabel.textColor = colorLightGray;

        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.textColor = colorDeepGray;

        [self setValue:rightLabel forKey:objectsString[i]];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB_color(240, 240, 240, 1);

        [self.contentView addSubview:leftLabel];
        [self.contentView addSubview:rightLabel];
        [self.contentView addSubview:lineView];
        
        if (temp == nil) {
            [leftLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.bottom).offset(30);
                make.left.equalTo(10);
                make.height.lessThanOrEqualTo(20);
            }];
        }else{
            [leftLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(temp.bottom).offset(15);
                make.left.equalTo(10);
                make.height.lessThanOrEqualTo(20);
            }];
        }

        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.right).offset(10);
            make.top.equalTo(leftLabel);
        }];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(leftLabel.bottom).offset(7);
            make.height.equalTo(1);
        }];
        if (i == 4) {
            [lineView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(5);
            }];
        }

        temp = leftLabel;
    }

    CZWLabel *complainTitle = [[CZWLabel alloc] init];
    complainTitle.font = [UIFont systemFontOfSize:14];
    complainTitle.textColor = colorLightGray;
    complainTitle.text = @"  投诉内容：";
    UIImage *acomplainTitleImage = [UIImage imageNamed:@"auto_投诉详情_提问"];
    [complainTitle insertImage:acomplainTitleImage frame:CGRectMake(0, -3, 17, 17) index:0];

    questionContent = [[CZWLabel alloc] init];
    questionContent.textColor = colorDeepGray;
    questionContent.linesSpacing = 4;
    questionContent.font = [UIFont systemFontOfSize:14];

    
    CZWLabel *answerTitle = [[CZWLabel alloc] init];
    answerTitle.font = [UIFont systemFontOfSize:14];
    answerTitle.textColor = colorLightGray;
    answerTitle.text = @"  投诉回复：";
    UIImage *answerTitleImage = [UIImage imageNamed:@"auto_answerDetail_answer"];
    [answerTitle insertImage:answerTitleImage frame:CGRectMake(0, -3, 17, 17) index:0];

    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = RGB_color(240, 240, 240, 1);

    UIView *lineView3 = [UIView new];
    lineView3.backgroundColor = RGB_color(240, 240, 240, 1);


    answerContent = [[CZWLabel alloc] init];
    answerContent.linesSpacing = 4;
    answerContent.textColor = colorDeepGray;
    answerContent.font = [UIFont systemFontOfSize:14];

    [self.contentView addSubview:complainTitle];
    [self.contentView addSubview:questionContent];
    [self.contentView addSubview:answerTitle];
    [self.contentView addSubview:answerContent];
    [self.contentView addSubview:lineView2];
    [self.contentView addSubview:lineView3];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.centerX.equalTo(0);
        make.width.lessThanOrEqualTo(WIDTH-20);
    }];

    [complainTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(temp.bottom).offset(40);
    }];

    [questionContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(complainTitle.bottom).offset(10);
        make.right.equalTo(-10);
    }];

    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(questionContent.bottom).offset(20);
        make.height.equalTo(5);
    }];

    [answerTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(lineView2.bottom).offset(20);
    }];

    [answerContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(answerTitle.bottom).offset(10);
        make.right.equalTo(-10);
    }];

    [lineView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(answerContent.bottom).offset(20);
        make.height.equalTo(5);
        make.bottom.equalTo(0);
    }];
}


- (void)setData{

    titleLabel.text = self.dict[@"title"];
    idLabel.text = self.dict[@"id"];
     brandLabel.text = self.dict[@"brand"];
     seriesLabel.text = self.dict[@"series"];
     modelLabel.text = self.dict[@"model"];
     dateLabel.text = self.dict[@"date"];
    [footView setReplyConut:self.dict[@"replycount"]];

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
            if (i == 0) {
                shareImage = image;
            }
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
    footView = [[FootCommentView alloc] initWithFrame:CGRectZero];
    footView.delegate = self;
    [self.view addSubview:footView];

    [footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(49);
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

    if (titleLabel.text && dateLabel.text && self.cid) {
        FmdbManager *fb = [FmdbManager shareManager];
        [fb insertIntoCollectWithId:self.cid andTime:dateLabel.text andTitle:titleLabel.text andType:collectTypeCompalin];
         [LHController alert:@"收藏成功"];
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:_cid andType:collectTypeCompalin];
     [LHController alert:@"取消收藏成功"];
}

#pragma mark - 点击评论按钮
-(void)writeClick{
    if ([CZWManager manager].isLogin) {
        _commentView = [[CustomCommentView alloc] init];
        [_commentView show];
        [_commentView send:^(NSString *content) {
            [self submitComment:content];
        }];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        [self presentViewController:my animated:YES completion:nil];
    }
}


#pragma mark - 提交评论
-(void)submitComment:(NSString *)content{

    if (![LHController judegmentSpaceChar:content]) {
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[CZWManager manager].userID forKey:@"uid"];
    [dict setObject:@"0" forKey:@"fid"];
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.cid forKey:@"tid"];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",self.type];
    [dict setObject:appOrigin forKey:@"origin"];

    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {

        if (responseObject[@"success"]) {
            [LHController alert:responseObject[@"success"]];
            [footView addReplyCont];

        }else{
            [LHController alert:@"评论失败"];
        }

    } failure:^(NSError *error) {
        [LHController alert:@"评论失败"];
    }];
}

#pragma mark - FootCommentViewDelegate
- (void)clickButton:(NSInteger)slected{
    if (slected == 0) {
        if ([CZWManager manager].isLogin) {
            CustomCommentView *commentView = [[CustomCommentView alloc] init];
            [commentView show];
            [commentView send:^(NSString *content) {
                [self submitComment:content];
            }];
        }else{

            [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        }
    }else{
        CommentListViewController *comment = [[CommentListViewController alloc] init];
        comment.type = self.type;
        comment.cid = self.cid;
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
