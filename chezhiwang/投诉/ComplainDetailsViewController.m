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
#import "UMSocial.h"
#import "CustomCommentView.h"


@interface ComplainDetailsViewController ()
{
    UIScrollView *scrollView;
    UIView *sview;
    CustomCommentView *_commentView;
    UIView *shareView;
    UILabel *numLabel;
    NSString *http;
    BOOL isAhare;
    
    CGFloat B;
    CustomActivity *activity;
    
    CZWLabel *titleLabel;
    CZWLabel *parameterLabel;//参数
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (strong,nonatomic) UIView *contentView;

@end

@implementation ComplainDetailsViewController

- (void)dealloc
{
    [shareView removeFromSuperview];
    [sview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)loadDataOne{
    

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForComplain],_cid];
   [HttpRequest GET:url success:^(id responseObject) {
 
       self.dict = responseObject[0];
       
       [self createScrollViewSubViews];
       [activity animationStoping];
   } failure:^(NSError *error) {
        [activity animationStoping];
   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    B = [LHController setFont];
    http = @"";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
  
    [self createRightItems];
     [self createBgView];
    [self createScrollView];
    [self createFootView];
    
    [self createActivity];
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
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = CGRectMake(0, HEIGHT, WIDTH, 260);
       
    }];
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
        [self createShare];
    }
}

-(void)createActivity{
    activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
    [self.view addSubview:activity];
    [activity animationStarting];
}

#pragma mark - 滚动视图
-(void)createScrollView{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
}

#pragma mark - 数据显示
-(void)createScrollViewSubViews{
    
    CGSize textSize =[_textTitle boundingRectWithSize:CGSizeMake(WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B]} context:nil].size;
    
    UILabel *titleLabel = [LHController createLabelWithFrame:CGRectMake(10, 30, WIDTH-20, textSize.height) Font:B Bold:NO TextColor:nil Text:_textTitle];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [scrollView addSubview:titleLabel];
    
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.frame.size.height+20, WIDTH-20, 120)];
    viewBG.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [scrollView addSubview:viewBG];
    
    NSArray *array = @[@"投诉编号:",@"投诉品牌:",@"投诉车系:",@"投诉车型:",@"投诉时间:"];
    NSArray *arr = @[@"id",@"brand",@"series",@"model",@"date"];
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i ++) {
        NSString *str = _dict[arr[i]];
        if (i == 0) {
            str = [NSString stringWithFormat:@"【%@】",str];
        }
        if (str) {
            [mArray addObject:str];
        }else{
            [mArray addObject:@""];
        }
    }
    
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(5, 10+20*i, 70, 20) Font:B-4 Bold:NO TextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] Text:array[i]];
        [viewBG addSubview:label];
        
        UILabel *labelRight = [LHController createLabelWithFrame:CGRectMake(65, 10+20*i, 200, 20) Font:B-4 Bold:NO TextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] Text:mArray[i]];
        [viewBG addSubview:labelRight];
        if (i > 0) {
            labelRight.frame = CGRectMake(67, 10+20*i, WIDTH-90, 20);
        }
    }
    
    UILabel *complainTitle = [LHController createLabelWithFrame:CGRectMake(15, viewBG.frame.size.height+viewBG.frame.origin.y+10, 90, 20) Font:B-3 Bold:NO TextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] Text:@"投诉内容:"];
    [scrollView addSubview:complainTitle];
    
//    UIView *fg1 = [[UIView alloc] initWithFrame:CGRectMake(0, complainTitle.frame.origin.y+complainTitle.frame.size.height+10, WIDTH, 1)];
//    fg1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    [scrollView addSubview:fg1];
    
    [self createImage:complainTitle.frame.origin.y+complainTitle.frame.size.height+10];
}

//展示图片以下部分内容
-(void)createer:(CGFloat)y{
    NSString *str1 = _dict[@"content"];
    NSAttributedString *att1 = [self attString:str1 Font:B-3];
    //计算高度
    CGSize size = [att1 boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    UILabel *complainContent = [LHController createLabelWithFrame:CGRectMake(15, y+5, WIDTH-30, size.height) Font:B-3 Bold:NO TextColor:nil Text:nil];
    complainContent.attributedText = att1;
    [complainContent sizeToFit];
    [scrollView addSubview:complainContent];
    
    
    UIView *fg2 = [[UIView alloc] initWithFrame:CGRectMake(0, complainContent.frame.size.height+complainContent.frame.origin.y+20, WIDTH, 1)];
    fg2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [scrollView addSubview:fg2];
    
    UILabel *answer = [LHController createLabelWithFrame:CGRectMake(15, fg2.frame.origin.y+10, 80, 20)  Font:B-3 Bold:NO TextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] Text:@"投诉回复:"];
    [scrollView addSubview:answer];
//    
//    UIView *fg3 = [[UIView alloc] initWithFrame:CGRectMake(0, answer.frame.origin.y+30, WIDTH, 1)];
//    fg3.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    [scrollView addSubview:fg3];
    
    NSString *str2 = _dict[@"answer"];
    
    NSAttributedString *att2 = [self attString:str2 Font:B-3];
    CGSize size2 = [att2 boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    UILabel *answerContent = [LHController createLabelWithFrame:CGRectMake(15, answer.frame.origin.y+answer.frame.size.height+10, WIDTH-30, size2.height) Font:B-3 Bold:NO TextColor:nil Text:nil];
    answerContent.attributedText = att2;
    [answerContent sizeToFit];
    [scrollView addSubview:answerContent];
    
    scrollView.contentSize = CGSizeMake(0, answerContent.frame.origin.y+answerContent.frame.size.height+40);
}

//展示图片***************************
-(void)createImage:(CGFloat)y{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.dict[@"image"] componentsSeparatedByString:@"||"]];
    [array removeObject:@""];
    if (array.count == 0) {
        [self createer:y];
        return;
    }
    __block CGFloat _yy = y;
    __block int count = 0;
    for (int i = 0; i < array.count; i ++) {
        
        SDWebImageDownloader *sd =[SDWebImageDownloader sharedDownloader];
        __weak __typeof(self)weakSelf = self;
        [sd downloadImageWithURL:[self urlString:array[i]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
           
            if (image) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    CGFloat sx = (WIDTH-20)/image.size.width;
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _yy, WIDTH-20, image.size.height*sx)];
                    imageView.image = image;
                    [scrollView addSubview:imageView];
                    
                    if(sx > 1){
                        imageView.frame = CGRectMake(10, _yy, image.size.width, image.size.height);
                        _yy = _yy+image.size.height+10;
                    }else{
                        _yy = _yy+image.size.height*sx+10;
                    }
                });
                
            }
           count++;
            if (count == array.count) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                      [weakSelf createer:_yy];
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

#pragma mark - 属性化字符串
-(NSAttributedString *)attString:(NSString *)str Font:(CGFloat)size{
    if (!str) {
        return nil ;
    }
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
    NSMutableParagraphStyle *syyle = [[NSMutableParagraphStyle alloc] init];
    [syyle setLineSpacing:8];
    [syyle setLineBreakMode:NSLineBreakByWordWrapping];
    syyle.firstLineHeadIndent = 30;
    
    [att addAttribute:NSParagraphStyleAttributeName value:syyle range:NSMakeRange(0, str.length)];
    //[att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0,str.length)];
    return att;
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

#pragma mark - 分享
-(void)createShare{
    if (shareView) {
        sview.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            shareView.frame = CGRectMake(0, HEIGHT-260, WIDTH, 260);
        }];
    }else{
        
        [self createShareView];
        sview.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            shareView.frame = CGRectMake(0, HEIGHT-260, WIDTH, 260);
        }];
    }
}

-(void)createShareView{
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 260)];
    shareView.backgroundColor = [UIColor whiteColor];
    [sview addSubview:shareView];
    
    //NSArray *imageAray = @[];
    NSArray *array = @[@"QQ好友",@"微信朋友圈",@"微信",@"新浪微博",@"QQ空间",@"复制链接"];
    for (int i = 0; i < array.count; i ++) {
        
        UIButton *btn = [LHController createButtnFram:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3), 80, 80) Target:self Action:@selector(shareClick:) Text:nil];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fenxiang%d",i+1]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [shareView addSubview:btn];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3)+80, 80, 20) Font:B-4 Bold:NO TextColor:nil Text:array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:label];
    }
}


-(void)shareClick:(UIButton *)btn{
   
    NSString *urlString = [NSString stringWithFormat:@"%@\n%@",self.textTitle,self.dict[@"url"]];
    
    UIImage *shareImage = [UIImage imageNamed:@"Icon-60"];
    NSString *content = self.dict[@"content"] == nil?self.dict[@"Content"]:self.dict[@"content"];
    if (content.length > 100) content = [content substringToIndex:99];
    NSString *shareContent = content;
    NSString *shareTitle = self.textTitle;
    NSString *shareUrl = self.dict[@"url"]== nil?self.dict[@"FilePath"]:self.dict[@"url"];
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
           // [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareContent;
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
            past.string = self.dict[@"url"];
            
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
}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{  NSLog(@"%@",response);
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//    }
//}

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

#pragma mark - 返回
-(void)blockClick{
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
