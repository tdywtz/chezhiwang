//
//  ComplainDetailsViewController.m
//  auto
//
//  Created by bangong on 15/6/11.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyComplainDetailsViewController.h"
#import "ComplainViewController.h"
#import "RevokeComplainViewController.h"
#import "MyComplainModel.h"
#import "ComplainDrawView.h"
#import "MyComplainHeaderView.h"
#import "ComplainDetailsView.h"

#define L 10
#define space 20

@interface  MyComplainDetailsHeaderView : UIView

@property (nonatomic,weak) MyComplainDetailsViewController *parentViewController;

@end

@implementation MyComplainDetailsHeaderView
{
    UILabel *titleLabel;
    YYLabel *styleLabel;
    UILabel *dateLabel;
    UILabel *stateLabel;
    MyComplainHeaderView *headerView;
    ComplainDrawView *stepView;
    ButtonView *btnView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        titleLabel  = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = colorBlack;

        styleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        styleLabel.font = [UIFont systemFontOfSize:14];
        styleLabel.textContainerInset = UIEdgeInsetsMake(2, 4, 2, 4);
        styleLabel.layer.cornerRadius = 3;
        styleLabel.layer.masksToBounds = YES;
        styleLabel.layer.borderWidth = 1;
        styleLabel.textColor = RGB_color(237, 27, 36, 1);
        styleLabel.layer.borderColor = RGB_color(237, 27, 36, 1).CGColor;
        styleLabel.preferredMaxLayoutWidth = 300;

        dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = colorLightGray;

        stateLabel = [[UILabel alloc] init];
        stateLabel.textColor = colorBlack;
        stateLabel.font = [UIFont systemFontOfSize:15];
        stateLabel.numberOfLines = 0;

        headerView = [[MyComplainHeaderView alloc] initWithFrame:CGRectZero];
        headerView.backgroundColor = [UIColor clearColor];

        stepView = [[ComplainDrawView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];

        btnView = [[ButtonView alloc] init];

        __weak __typeof(self)weakSelf = self;
        btnView.click = ^(NSString *title){
            //点击修改，再次投诉
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.parentViewController changeClick:title];

        };

        [self addSubview:titleLabel];
        [self addSubview:styleLabel];
        [self addSubview:dateLabel];
        [self addSubview:stateLabel];
        [self addSubview:stepView];
        [self addSubview:headerView];
        [self addSubview:btnView];
    }
    return self;
}

- (void)setModel:(MyComplainModel *)model{

    titleLabel.text = model.title;
    styleLabel.text = model.status;
    dateLabel.text = model.date;
    headerView.current = [model.stepid integerValue];

    NSString *text = [NSString stringWithFormat:@"当前投诉状态：%@",model.status];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:model.status];
    if (range.length) {
        [att setLh_colorWithColor:RGB_color(237, 27, 36, 1) range:range];
    }

    stateLabel.attributedText = att;



    stepView.lh_width = WIDTH;
    [stepView setSteps:model.steps];
    if ([model.show integerValue] == 3) {
        btnView.titles = @[@"再次投诉",@"申请撤诉"];
    }else if ([model.show integerValue] == 4){
        btnView.titles = @[@"再次投诉",@"查看原因"];
    }else if ([model.show integerValue] == 5){
        btnView.titles = @[@"再次投诉"];
    }else{
        btnView.titles = nil;
    }
  
    titleLabel.lh_width = WIDTH - 20;
    [titleLabel sizeToFit];
    titleLabel.lh_left = 10;
    titleLabel.lh_top = 15;

    [styleLabel sizeToFit];
    styleLabel.lh_left = titleLabel.lh_left;
    styleLabel.lh_top = titleLabel.lh_bottom + 10;

    [dateLabel sizeToFit];
    dateLabel.lh_left = styleLabel.lh_right + 10;
    dateLabel.lh_centerY = styleLabel.lh_centerY;

    stateLabel.lh_width = WIDTH - 20;
    [stateLabel sizeToFit];
    stateLabel.lh_left = titleLabel.lh_left;
    stateLabel.lh_top = styleLabel.lh_bottom + 20;

    headerView.lh_left = stateLabel.lh_left;
    headerView.lh_top = stateLabel.lh_bottom+10;
    headerView.lh_width = WIDTH - 20;
    headerView.lh_height = 42;
    [headerView setNeedsDisplay];

    stepView.lh_left = 0;
    stepView.lh_top = headerView.lh_bottom + 10;

    NSInteger step = [model.show integerValue];
    if (step == 3 || step == 4 || step == 5) {
        btnView.lh_centerX = WIDTH/2;
        btnView.lh_top = stepView.lh_bottom + 10;
        btnView.lh_size = btnView.bounds.size;

        self.lh_width = WIDTH;
        self.lh_height = btnView.lh_bottom + 10;
    }else{
        self.lh_width = WIDTH;
        self.lh_height = stepView.lh_bottom;
    }

    self.backgroundColor = [UIColor whiteColor];

}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGB_color(240, 240, 240, 1).CGColor);
    CGContextAddRect(context, CGRectMake(0, stateLabel.lh_top - 10, WIDTH, rect.size.height));
    CGContextFillPath(context);
    [super drawRect:rect];
}

@end

#pragma mark -  ChooseView

@interface ChooseView : UIView
{
    UIButton *leftButton;
    UIButton *rightButton;
    UIView *moveView;
}
@property (nonatomic,weak) MyComplainDetailsViewController *parentViewController;
@end

@implementation ChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        leftButton = [self buttonWithTitle:@"即时操作"];
        rightButton = [self buttonWithTitle:@"投诉详情"];

        moveView = [[UIView alloc] initWithFrame:CGRectZero];
        moveView.backgroundColor = colorYellow;
        [self addSubview:moveView];

        [self restting];
    }
    return self;
}

- (void)restting{
    [leftButton sizeToFit];
    leftButton.lh_width = 90;
    leftButton.lh_left = (WIDTH-180)/4;
    leftButton.lh_bottom = self.lh_height-5;

    rightButton.lh_size = leftButton.lh_size;
    rightButton.lh_right = WIDTH - leftButton.lh_left;
    rightButton.lh_bottom = leftButton.lh_bottom;

    moveView.lh_width = leftButton.lh_width;
    moveView.lh_height = 2;
    moveView.lh_centerX = leftButton.lh_centerX;
    moveView.lh_bottom = self.lh_height;
}

- (UIButton *)buttonWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:colorBlack forState:UIControlStateNormal];
    [btn setTitleColor:colorYellow forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

    return btn;
}

- (void)buttonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }

    if (button == leftButton) {
        leftButton.selected = YES;
        rightButton.selected = NO;
        [self.parentViewController updateLayout:YES];
    }else{
        leftButton.selected = NO;
        rightButton.selected = YES;
         [self.parentViewController updateLayout:NO];
    }

    moveView.lh_centerX = button.lh_centerX;
}

@end

#pragma mark - MyComplainDetailsViewController
@interface MyComplainDetailsViewController ()<UIAlertViewDelegate>
{

    MyComplainDetailsHeaderView *detailsHeaderView;
    ChooseView *chooseView;
    ComplainPromptView *promtView;
    ComplainDetailsView *detailsView;
    UILabel *bottomLabel;

}

@property (nonatomic,strong) MyComplainModel *model;

@end

@implementation MyComplainDetailsViewController

-(void)loadData{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForDetail],self.Cpid];
    [HttpRequest GET:url success:^(id responseObject) {

        [detailsView setDetailsDict:responseObject];

    } failure:^(NSError *error) {
        
    }];
}

-(void)loadHeaderData{
    __weak __typeof(self)weakSelf = self;
    NSString *url  =[NSString stringWithFormat:[URLFile urlStringFor_mytsbyid],self.Cpid];
    [HttpRequest GET:url success:^(id responseObject) {

        if ([responseObject[@"rel"] isKindOfClass:[NSArray class]] == NO) {
            return ;
        }
        if ([responseObject[@"rel"] count] == 0) {
            return;
        }

        weakSelf.model = [MyComplainModel mj_objectWithKeyValues:responseObject[@"rel"][0]];
        [detailsHeaderView setModel:weakSelf.model];
        [promtView setModel:weakSelf.model];
        [weakSelf updateLayout:YES];

    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"投诉详情";


    detailsHeaderView = [[MyComplainDetailsHeaderView alloc] initWithFrame:self.view.frame];
    detailsHeaderView.parentViewController = self;

    chooseView = [[ChooseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    chooseView.parentViewController = self;

    promtView = [[ComplainPromptView alloc] initWithFrame:CGRectZero];
    promtView.perentViewController = self;

    detailsView = [[ComplainDetailsView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];

    bottomLabel = [[UILabel alloc] init];
    bottomLabel.font = [UIFont systemFontOfSize:13];
    bottomLabel.backgroundColor = RGB_color(240, 240, 240, 1);
    bottomLabel.text = @"投诉热线：010-65994868";
    bottomLabel.textColor = RGB_color(237, 27, 36, 1);
    bottomLabel.textAlignment = NSTextAlignmentCenter;


    [self.scrollView addSubview:detailsHeaderView];
    [self.scrollView addSubview:chooseView];
    [self.scrollView addSubview:promtView];
    [self.scrollView addSubview:detailsView];
    [self.scrollView addSubview:bottomLabel];

    [self loadHeaderData];
    [self loadData];
}

- (void)updateLayout:(BOOL)showLeft{
    detailsHeaderView.lh_left = 0;
    detailsHeaderView.lh_top = 0;

    chooseView.lh_left = 0;
    chooseView.lh_top = detailsHeaderView.lh_bottom;

    detailsView.lh_left = 0;
    detailsView.lh_top = chooseView.lh_bottom;

    promtView.lh_left = 0;
    promtView.lh_top = chooseView.lh_bottom;
    if (showLeft) {
        promtView.hidden = NO;
        detailsView.hidden = YES;

        bottomLabel.lh_left = 0;
        bottomLabel.lh_top = promtView.lh_bottom;
        bottomLabel.lh_size = CGSizeMake(WIDTH, 45);
    }else{
        promtView.hidden = YES;
        detailsView.hidden = NO;

        bottomLabel.lh_left = 0;
        bottomLabel.lh_top = detailsView.lh_bottom;
        bottomLabel.lh_size = CGSizeMake(WIDTH, 45);

    }

    self.scrollView.contentSize = CGSizeMake(0, bottomLabel.lh_bottom);
}

#pragma mark - 注册通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 点击修改/再次投诉按钮
- (void)changeClick:(NSString *)title{
    if ([title isEqualToString:@"再次投诉"]) {
        ComplainViewController *complain =[[ComplainViewController alloc] init];
        complain.Cpid = self.Cpid;
        complain.siChange = NO;
        complain.again = YES;

        [self.navigationController pushViewController:complain animated:YES];
    }else if ([title isEqualToString:@"修改"]){
        ComplainViewController *complain =[[ComplainViewController alloc] init];
        complain.Cpid = self.Cpid;
        complain.siChange = YES;
        complain.again = NO;

        [self.navigationController pushViewController:complain animated:YES];
    }
    else if([title isEqualToString:@"申请撤诉"]){
    
       // [self createWriteView];
        RevokeComplainViewController *revoke = [[RevokeComplainViewController alloc] init];
        revoke.cpid = self.Cpid;
        __weak __typeof(self)weakSelf = self;
        revoke.success = ^{
            [weakSelf loadHeaderData];
        };
        [self.navigationController pushViewController:revoke animated:YES];
    }else if([title isEqualToString:@"查看原因"]){

        NSString *url = [NSString stringWithFormat:[URLFile urlString_delComNoReason],self.Cpid];
        [HttpRequest GET:url success:^(id responseObject) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"申请撤诉未成功原因"
                                                            message:responseObject[@"reason"]
                                                           delegate:self
                                                  cancelButtonTitle:@"再次申请撤诉"
                                                  otherButtonTitles:@"取消", nil];
            [alert show];

        } failure:^(NSError *error) {
            
        }];
    }

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


/**提交评分*/
-(void)submitStar:(NSInteger)star{


    NSString *url = [NSString stringWithFormat:[URLFile urlStringForComplainScore],self.Cpid,star];
    [HttpRequest GET:url success:^(id responseObject) {

        [self loadHeaderData];

    } failure:^(NSError *error) {

        [self alert:@"数据请求失败"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        RevokeComplainViewController *revoke = [[RevokeComplainViewController alloc] init];
        revoke.cpid = self.Cpid;
        __weak __typeof(self)weakSelf = self;
        revoke.success = ^{
            [weakSelf loadHeaderData];
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
