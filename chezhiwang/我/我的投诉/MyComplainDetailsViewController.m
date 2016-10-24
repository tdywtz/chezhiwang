//
//  ComplainDetailsViewController.m
//  auto
//
//  Created by bangong on 15/6/11.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyComplainDetailsViewController.h"
#import "ComplainView.h"
#import "RevokeComplainViewController.h"

#define L 10
#define space 20

@interface MyComplainDetailsViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *scrollView;
    CGFloat y;
    UIView *headerView;
    UIImageView *headerImageView;
    UIView *leftView;
    UIView *rightView;
    CGFloat B;
    NSInteger star;
    UIButton *starButton;
    UILabel *starLabel;
    UIView *bgView;
    UIView *writeView;
    UITextView *textView;
    UIView *fatherView;
    UILabel *placeholder;
}

@property (nonatomic,strong) NSMutableArray *oneArray;
@property (nonatomic,strong) NSMutableArray *twoArray;
@property (nonatomic,strong) NSMutableArray *threeArray;
@property (nonatomic,strong) NSDictionary *dict;
@end

@implementation MyComplainDetailsViewController
- (void)dealloc
{
    [bgView removeFromSuperview];
    [writeView removeFromSuperview];
    [fatherView removeFromSuperview];
}



-(void)loadData{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForDetail],_model.Cpid];
    [HttpRequest GET:url success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        _dict = responseObject;
        
        NSArray *arr1 = @[@"uname",@"age",@"sex",@"mobile",@"email",@"phone",@"address",@"occ"];
        NSArray *arr2 = @[@"brand",@"series",@"model",@"engine",@"carriage",@"sign",@"buytime",@"lname",@"issuetime",@"mileage"];
        NSArray *arr3 = @[@"type",@"attribute",@"question",@"content"];
        _oneArray = [[NSMutableArray alloc] init];
        _twoArray = [[NSMutableArray alloc] init];
        _threeArray = [[NSMutableArray alloc] init];
        for (NSString *string in arr1) {
            NSString *str = dict[string];
            if (str) {
                [_oneArray addObject:str];
            }else{
                [_oneArray addObject:@""];
            }
        }
        for (NSString *string in arr2) {
            NSString *str = dict[string];
            if (str) {
                [_twoArray addObject:str];
            }else{
                [_twoArray addObject:@""];
            }
        }
        for (NSString *string in arr3) {
            NSString *str = dict[string];
            if (str) {
                [_threeArray addObject:str];
            }else{
                [_threeArray addObject:@""];
            }
        }
        
        [self createRightView];

    } failure:^(NSError *error) {
        
    }];
}

-(void)loadDataHeader{
    NSString *url  =[NSString stringWithFormat:[URLFile urlStringFor_mytsbyid],_model.Cpid];
    [HttpRequest GET:url success:^(id responseObject) {
        NSDictionary *dict = responseObject[0];
        MyComplainModel *model = [[MyComplainModel alloc] initWithDictionary:dict];
        _model = model;
        [scrollView removeFromSuperview];
        [self createScrollView];
        [self createHeader];
        [self createButton];
        [self createLeftView];
        [self createRightView];

    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
    B = [LHController setFont];
    self.navigationItem.title = @"投诉详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createScrollView];
    [self createHeader];
    [self createButton];
    [self createLeftView];
    
    [self createFootView];
    [self loadData];
    [self createNotification];
}
#pragma mark - 注册通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
   CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
  
    [UIView animateWithDuration:0.3 animations:^{
        writeView.frame = CGRectMake(0, HEIGHT-height-200, WIDTH, 200);
    }];
    placeholder.hidden = YES;
}

-(void)keyboardHide:(NSNotification *)notification
{
    writeView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT/2);
}

-(void)createScrollView{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-40)];
    [self.view addSubview:scrollView];
}

-(void)createHeader{
    
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, WIDTH-20, 80*(WIDTH-20)/614.0)];
    [scrollView addSubview:headerImageView];
    headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tous%@",_model.stepid]];
    
    if (headerView) {
        [headerView removeFromSuperview];
    }
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.frame.origin.y+headerImageView.frame.size.height+15, WIDTH, 110+20*5)];
    headerView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:238/255.0];
    [scrollView addSubview:headerView];
    
    UILabel *labelName = [LHController createLabelWithFrame:CGRectMake(10, 15, WIDTH-20, 20) Font:B Bold:YES TextColor:nil Text:_model.title];
    [headerView addSubview:labelName];
    
    UILabel *labelState = [LHController createLabelWithFrame:CGRectMake(10, 40, 60, 20) Font:B-5 Bold:NO TextColor:[UIColor colorWithRed:5/255.0 green:143/255.0 blue:206/255.0 alpha:1] Text:_model.status];
    [headerView addSubview:labelState];
    
    UILabel *labelDate = [LHController createLabelWithFrame:CGRectMake(70, 40, 130, 20) Font:B-5 Bold:NO TextColor:nil Text:_model.date];
    [headerView addSubview:labelDate];
    
    UILabel *fg = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, WIDTH, 1)];
    fg.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:fg];
  
    CGSize size = [_model.common boundingRectWithSize:CGSizeMake(WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-3]} context:nil].size;
    UILabel *labelPace = [LHController createLabelWithFrame:CGRectMake(10, 83, WIDTH-20, size.height) Font:B-3 Bold:NO TextColor:nil Text:_model.common];
    labelPace.numberOfLines = 0;
    [headerView addSubview:labelPace];
    
    UIButton *btn;
    UIButton *freeBtn;
    if ([_model.show integerValue] == 0) {
        btn = [LHController createButtnFram:CGRectMake(WIDTH/2-30, headerView.frame.size.height-30, 100, 30) Target:self Action:@selector(changeClick:) Font:B+2 Text:@"修  改"];
        [headerView addSubview:btn];
    }else if([_model.stepid integerValue] == 5){
        btn = [LHController createButtnFram:CGRectMake(WIDTH/2-30, headerView.frame.size.height-30, 100, 30) Target:self Action:@selector(changeClick:) Font:B-1 Text:@"再次投诉"];
        [headerView addSubview:btn];
        if ([_model.cs isEqualToString:@"可申请撤诉"]) {
            freeBtn = [LHController createButtnFram:CGRectMake(WIDTH/2-30, headerView.frame.size.height-30, 100, 30) Target:self Action:@selector(changeClick:) Font:B-1 Text:@"申请撤诉"];
            [headerView addSubview:freeBtn];
        }
        if ([_model.cs isEqualToString:@"查看原因"]) {
            freeBtn = [LHController createButtnFram:CGRectMake(WIDTH/2-30, headerView.frame.size.height-30, 100, 30) Target:self Action:@selector(changeClick:) Font:B-1 Text:@"查看原因"];
            [headerView addSubview:freeBtn];
        }
    }
   
    CGFloat gao = labelPace.frame.origin.y+labelPace.frame.size.height+10;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 6; i ++) {
        NSString *str = [NSString stringWithFormat:@"step%d",i];
        if (_model.step[str]) {
            [arr addObject:_model.step[str]];
        }
    }
    for (int i = 0; i < arr.count; i ++) {
        UILabel *label = [self createGrayLabelWithFrame:CGRectMake(10, gao+20*i, WIDTH-20, 20) andText:arr[i]];
        [headerView addSubview:label];
        
        if (i == 3) {
            label.frame = CGRectMake(10, gao+20*i, WIDTH-20, 35);
        }
        if (i >= 4) {
            label.frame = CGRectMake(10, gao+20*i+15, WIDTH-20, 20);
        }
        if (i == arr.count-1) {
            headerView.frame = CGRectMake(0, headerView.frame.origin.y, WIDTH, label.frame.origin.y+label.frame.size.height+60);
        }
    }
    if ([_model.stepid integerValue] != 5 && [_model.show integerValue] != 0) {
        headerView.frame = CGRectMake(0, headerView.frame.origin.y, WIDTH, headerView.frame.size.height-40);
    }
    btn.center = CGPointMake(WIDTH/2, headerView.frame.size.height-30);
    if (freeBtn) {
        btn.center = CGPointMake(WIDTH/2-btn.frame.size.width/2-15,  headerView.frame.size.height-30);
        freeBtn.center = CGPointMake(WIDTH/2+freeBtn.frame.size.width/2+15, headerView.frame.size.height-30);
    }
    y = headerView.frame.origin.y+headerView.frame.size.height+20;
}

#pragma mark - label
-(UILabel *)createGrayLabelWithFrame:(CGRect)frame andText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:B-5];
    return label;
}

#pragma mark - 即时操作/投诉详情
-(void)createButton{
    UIButton *btnLeft = [LHController createButtnFram:CGRectMake(0, y, WIDTH/2, 20) Target:self Action:@selector(btnClick:) Text:@"即时操作"];
    [btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont boldSystemFontOfSize:B];
    [scrollView addSubview:btnLeft];
    
    UIButton *btnRight = [LHController createButtnFram:CGRectMake(WIDTH/2, y, WIDTH/2, 20) Target:self Action:@selector(btnClick:) Text:@"投诉详情"];
    [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont boldSystemFontOfSize:B];
    [scrollView addSubview:btnRight];
 
    y = y+20;
}

#pragma mark - 点击修改/再次投诉按钮
-(void)changeClick:(UIButton *)btn{
 
    ComplainView *cp2 =[[ComplainView alloc] init];
    cp2.dictionary = _dict;
    if ([btn.titleLabel.text isEqualToString:@"再次投诉"]) {
        cp2.siChange = NO;
        cp2.again = YES;
        [self.navigationController pushViewController:cp2 animated:YES];
    }else if([btn.titleLabel.text isEqualToString:@"申请撤诉"]){
    
       // [self createWriteView];
        RevokeComplainViewController *revoke = [[RevokeComplainViewController alloc] init];
        revoke.cpid = self.model.Cpid;
        __weak __typeof(self)weakSelf = self;
        revoke.success = ^{
            [weakSelf loadDataHeader];
        };
        [self.navigationController pushViewController:revoke animated:YES];
    }else if([btn.titleLabel.text isEqualToString:@"查看原因"]){

        NSString *url = [NSString stringWithFormat:[URLFile urlString_delComNoReason],self.model.Cpid];
        [HttpRequest GET:url success:^(id responseObject) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撤诉未成功原因"
                                                            message:responseObject[@"reason"]
                                                           delegate:self
                                                  cancelButtonTitle:@"再次申请撤诉"
                                                  otherButtonTitles:@"取消", nil];
            [alert show];

        } failure:^(NSError *error) {
            
        }];
    }
    else{
        cp2.siChange = YES;
        [self.navigationController pushViewController:cp2 animated:YES];
    }
}

-(void)createTishi{
    fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    fatherView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    [[UIApplication sharedApplication].keyWindow addSubview:fatherView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    view.alpha = 0.85;
    view.backgroundColor = [UIColor whiteColor];
    [fatherView addSubview:view];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(20, 30, view.frame.size.width-40, 60) Font:B-2 Bold:YES TextColor:[UIColor blackColor] Text:@"您的撤诉申请已经提交至车质网，请您耐心等待审批。"];
    label.textAlignment = NSTextAlignmentCenter;
    [fatherView addSubview:label];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(30, 120,view.frame.size.width-60, 30) Target:self Action:@selector(yesClick) Font:B Text:@"确  定"];
    [fatherView addSubview:button];

}
-(void)yesClick{
    [fatherView removeFromSuperview];
}

#pragma mark - 提示框alertView
-(void)alert:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
           [al dismissWithClickedButtonIndex:0 animated:YES];
    });
}

#pragma mark - 点击即时操作/投诉详情按钮
-(void)btnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"即时操作"]) {
        leftView.hidden = NO;
        rightView.hidden = YES;
        scrollView.contentSize = CGSizeMake(0, y+leftView.frame.size.height);
    }else{
        CGSize size;
        if (_threeArray.count > 0) {
             size =[[_threeArray lastObject] boundingRectWithSize:CGSizeMake(WIDTH-65, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-3]} context:nil].size;
        }
        
        scrollView.contentSize = CGSizeMake(0, rightView.frame.size.height+rightView.frame.origin.y);
        leftView.hidden = YES;
        rightView.hidden = NO;
    }
}

#pragma mark - 即时操作
-(void)createLeftView{
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIDTH, 200)];
    //leftView.backgroundColor = [UIColor blackColor];
    [scrollView addSubview:leftView];
    
    
    scrollView.contentSize = CGSizeMake(0, y+120);
    UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 20) ImageName:@"jscz"];
    [leftView addSubview:imageView];
    
    UIImageView *imageVeiw1 = [LHController createImageViewWithFrame:CGRectMake(10, 30, 20, 20) ImageName:@"cjhh"];
    [leftView addSubview:imageVeiw1];
    
    UILabel *label1 = [LHController createLabelWithFrame:CGRectMake(35, 30, 100, 20) Font:B-1 Bold:NO TextColor:nil Text:@"厂家回复"];
    [leftView addSubview:label1];
    UILabel *subLabel1 = [LHController createLabelWithFrame:CGRectMake(35, label1.frame.origin.y+label1.frame.size.height+10, WIDTH-60, 20) Font:B-3 Bold:NO TextColor:[UIColor grayColor] Text:@"对不起，该投诉还未进行到此步"];
    if (_model.huifu.length > 0) {
        CGSize size =[_model.huifu boundingRectWithSize:CGSizeMake(subLabel1.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-3]} context:nil].size;
        subLabel1.frame = CGRectMake(35, label1.frame.origin.y+label1.frame.size.height+10, WIDTH-60, size.height);
        subLabel1.text = _model.huifu;
    }
    [leftView addSubview:subLabel1];
    
    UIImageView *imageView2 = [LHController createImageViewWithFrame:CGRectMake(10, subLabel1.frame.size.height+subLabel1.frame.origin.y+15, 20, 20) ImageName:@"mypf"];
    [leftView addSubview:imageView2];
  
    UILabel *label2 = [LHController createLabelWithFrame:CGRectMake(35, imageView2.frame.origin.y, 130, 20) Font:B-1 Bold:NO TextColor:nil Text:@"满意度评分"];
    [leftView addSubview:label2];
    
    UILabel *subLabel2;
    if ([_model.stepid integerValue] < 4) {
        if ([_model.ispf isEqualToString:@"flase"]) {
            subLabel2 = [LHController createLabelWithFrame:CGRectMake(35, label2.frame.origin.y+label2.frame.size.height+10, WIDTH-60, 20) Font:B-3 Bold:NO TextColor:[UIColor grayColor] Text:@"对不起，该投诉还未进行到此步"];
            [leftView addSubview:subLabel2];
        }else{
            [self createStarView:label2.frame.origin.y+label2.frame.size.height+10];
        }
        
    }else if([_model.stepid integerValue] == 4){
        [self createStarView:label2.frame.origin.y+label2.frame.size.height+10];
        CGRect frame = leftView.frame;
        frame.size.height += 100;
        leftView.frame = frame;
    }else if([_model.stepid integerValue] == 5){
        for (int i = 0; i < 5; i ++) {
            UIImageView *im = [LHController createImageViewWithFrame:CGRectMake(35+i*40, label2.frame.origin.y+label2.frame.size.height+10 , 30, 30) ImageName:@"star"];
            if (i < [_model.stars integerValue]) {
                im.image = [UIImage imageNamed:@"stary"];
            }
            [leftView addSubview:im];
           
            if (i == 4) {
                subLabel2 = [LHController createLabelWithFrame:CGRectMake(im.frame.origin.x+50, im.frame.origin.y,100, im.frame.size.height) Font:B-3 Bold:NO TextColor:[UIColor colorWithRed:255/255.0 green:96/255.0 blue:0/255.0 alpha:1] Text:_model.pingfen];
                subLabel2.textAlignment = NSTextAlignmentCenter;
                [leftView addSubview:subLabel2];

            }
        }
    }
    
    scrollView.contentSize = CGSizeMake(0, y+leftView.frame.size.height);
}

#pragma mark - star
-(void)createStarView:(CGFloat)initial{
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [LHController createButtnFram:CGRectMake(35+i*40, initial , 30, 30) Target:self Action:@selector(xingxingClick:) Text:nil];
        [btn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [leftView addSubview:btn];
        
    }
    starLabel = [LHController createLabelWithFrame:CGRectMake(35+5*40+20, initial , 80, 30) Font:B-3 Bold:NO TextColor:[UIColor colorWithRed:255/255.0 green:96/255.0 blue:0/255.0 alpha:1] Text:nil];
    [leftView addSubview:starLabel];
    
    starButton = [LHController createButtnFram:CGRectMake(0,  0, 100, 30) Target:self Action:@selector(starClick) Font:B-1 Text:@"提交评分"];
    starButton.center = CGPointMake(WIDTH/2, initial+70);
    leftView.frame = CGRectMake(0, leftView.frame.origin.y, WIDTH, leftView.frame.size.height+40);
    [leftView addSubview:starButton];
}

#pragma mark - 点击评论星星按钮
-(void)xingxingClick:(UIButton *)btn{;
    
    star = btn.tag - 100;
    NSArray *arr = @[@"不满意",@"一般",@"较好",@"满意",@"非常满意"];
    starLabel.text = arr[star];
    
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:100+i];
        if (i <= star) {
              [btn setImage:[UIImage imageNamed:@"stary"] forState:UIControlStateNormal];
        }else{
              [btn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 提交评分
-(void)starClick{
    [starButton setTitle:@"正在提交" forState:UIControlStateNormal];
   // starButton.backgroundColor = [UIColor grayColor];
    starButton.enabled = NO;
    [self createHeader];

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForComplainScore],_model.Cpid,star+1];
    [HttpRequest GET:url success:^(id responseObject) {
        [starButton removeFromSuperview];
        [self loadDataHeader];
        if (self.commont) {
            self.commont(YES);
        }
       // starButton.enabled = YES;
        [starButton setTitle:@"提交完成" forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        starButton.enabled = YES;
        [starButton setTitle:@"提交评分" forState:UIControlStateNormal];
        [self alertShow:@"数据请求失败"];
    }];
}

#pragma mark -
-(void)alertShow:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    [UIView animateWithDuration:0.3 animations:^{
        [al dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

#pragma mark - 投诉详情
-(void)createRightView{
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIDTH, 400)];
    rightView.hidden = YES;
    [scrollView addSubview:rightView];
    UIImage *fgImage = [UIImage imageNamed:@"jscz"];
    fgImage = [UIImage imageWithCGImage:fgImage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];
    UIImageView *fgImageView = [LHController createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 20) ImageName:nil];
    fgImageView.image = fgImage;
    [rightView addSubview:fgImageView];
    
   
    
    NSArray *noeArray = @[@"姓名:",@"年龄:",@"性别:",@"移动电话:",@"电子邮箱:",@"固定电话:",@"通讯地址:",@"车主职业:"];
    NSArray *twoArray = @[@"投诉品牌:",@"车系:",@"车型:",@"发动机号:",@"车架号:",@"车牌号:",@"购车日期:",@"经销商名称:",@"问题日期:",@"已行驶里程(km):"];
    NSArray *threeArray = @[@"投诉类型:",@"投诉属性:",@"问题描述:",@"投诉详情:"];
 
    UIImageView *oneImgeView = [LHController createImageViewWithFrame:CGRectMake(L, 20, 20, 20) ImageName:@"tss_07.gif"];
    [rightView addSubview:oneImgeView];
   
    UILabel *oneLabel = [LHController createLabelWithFrame:CGRectMake(L+30, 20, 80, 20) Font:B-1 Bold:NO TextColor:nil Text:@"车主信息"];
    [rightView addSubview:oneLabel];
    for (int i = 0; i < 8; i ++) {
        
        UILabel *gray = [self createGrayColocLabelWithFrame:CGRectMake(10, space*i+50, 70, 20) andText:noeArray[i]];
        UILabel *label = [self createBlackLabelWithFrmae:CGRectMake(80, gray.frame.origin.y, WIDTH-90, 20) andText:_oneArray[i]];
        if (i < 3) {
            label.frame = CGRectMake(50, gray.frame.origin.y, WIDTH-60, 20);
        }
    }
    
    UIImageView *twoImageView = [LHController createImageViewWithFrame:CGRectMake(L, space*8+70, 25, 20) ImageName:@"tss_13.gif"];
    [rightView addSubview:twoImageView];
    UILabel *twoLabel = [LHController createLabelWithFrame:CGRectMake(L+35, space*8+70, 80, 20) Font:B-1 Bold:NO TextColor:nil Text:@"车辆信息"];
    [rightView addSubview:twoLabel];
    
    for (int i = 0; i < twoArray.count; i ++) {
        UILabel *gray = [self createGrayColocLabelWithFrame:CGRectMake(10, twoLabel.frame.origin.y+twoLabel.frame.size.height+10+space*i, 70, 20) andText:twoArray[i]];
       UILabel *black = [self createBlackLabelWithFrmae:CGRectMake(80, gray.frame.origin.y, WIDTH-90, 20) andText:_twoArray[i]];
        if (i == 7) {
            gray.frame = CGRectMake(10, gray.frame.origin.y, 85, 20);
            black.frame = CGRectMake(95, gray.frame.origin.y, WIDTH-90, 20);
        }else if (i == 9){
            gray.frame = CGRectMake(10, gray.frame.origin.y, 110, 20);
            black.frame = CGRectMake(120, gray.frame.origin.y, WIDTH-125, 20);
            if ([_twoArray[i] length] == 0) {
                black.text = @"0";
            }
        }
    }
    
    UIImageView *threeImageView = [LHController createImageViewWithFrame:CGRectMake(L, space*19+100, 20, 20) ImageName:@"tss_10.gif"];
    [rightView addSubview:threeImageView];
    UILabel *threeLabel = [LHController createLabelWithFrame:CGRectMake(L+25, space*19+100, 80, 20) Font:B-1 Bold:NO TextColor:nil Text:@"投诉内容"];
    [rightView addSubview:threeLabel];
    
    for (int i = 0; i < 4; i ++) {
        UILabel *gray = [self createGrayColocLabelWithFrame:CGRectMake(10, threeLabel.frame.origin.y+threeLabel.frame.size.height+10+space*i, 70, 20) andText:threeArray[i]];
        UILabel *label = [self createBlackLabelWithFrmae:CGRectMake(80, gray.frame.origin.y, WIDTH-90, 20) andText:_threeArray[i]];
        if (i == 3) {
           
             CGSize size =[_threeArray[i] boundingRectWithSize:CGSizeMake(WIDTH-90, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-3]} context:nil].size;
           // label.attributedText = [self attributeSize:_threeArray[i]];
            //CGSize size = [[self attributeSize:_threeArray[i]] boundingRectWithSize:CGSizeMake(WIDTH-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            label.frame = CGRectMake(80,gray.frame.origin.y+2, WIDTH-90, size.height);
          
            rightView.frame = CGRectMake(rightView.frame.origin.x, rightView.frame.origin.y, WIDTH, label.frame.origin.y+label.frame.size.height);
        }
    }
}
#pragma mark - 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:B-3] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0,att.length)];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 5);
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 10;
    
    [att addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, att.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    style.paragraphSpacing = 20;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
    return att;
}

#pragma mark - createFootView
-(void)createFootView{
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, HEIGHT-40, WIDTH, 40) Font:9 Bold:NO TextColor:nil Text:@"投诉热线：010-65994868"];
    label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark  - 控创建
//黑底
-(UILabel *)createBlackLabelWithFrmae:(CGRect)frame andText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:B-3];
    label.numberOfLines = 0;
    [rightView addSubview:label];
    
    return label;
}

//灰底
-(UILabel *)createGrayColocLabelWithFrame:(CGRect)frame andText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:B-3];
    label.textColor = [UIColor grayColor];
    [rightView addSubview:label];
    return label;
}

#pragma mark - block回调
-(void)blockCommont:(void(^)(BOOL yesORno))block{
    self.commont = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        RevokeComplainViewController *revoke = [[RevokeComplainViewController alloc] init];
        revoke.cpid = self.model.Cpid;
        __weak __typeof(self)weakSelf = self;
        revoke.success = ^{
            [weakSelf loadDataHeader];
        };
        [self.navigationController pushViewController:revoke animated:YES];
    }
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
