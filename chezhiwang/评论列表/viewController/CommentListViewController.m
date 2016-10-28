//
//  CommentListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListCell.h"
#import "CommentListInitialCell.h"
#import "LoginViewController.h"
#import "WriteViewController.h"
#import "FootCommentView.h"

typedef enum {
    commentTypeComment = 1,//评论
    commentTypeAnswer = 2//回复
}commentType;



@interface CommentHeadView : UIView

@property (nonatomic,strong) UILabel *numLabel;
@end

@implementation CommentHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = RGB_color(239, 95, 96, 1);
        _numLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:_numLabel];

        [_numLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
        }];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB_color(240, 240, 240, 1);
        [self addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return self;
}

@end

@interface CommentListViewController ()<UITableViewDataSource,UITableViewDelegate,FootCommentViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;
    
    CGFloat _height;
    NSString *_fid;//被回复id
    CGFloat B;
    commentType commentORanswer;
    CommentHeadView *headerView;
    
    UIView *spaceView;
     FootCommentView *footView;
}
@property (assign) BOOL isLogin;
@end

@implementation CommentListViewController

-(void)loadData{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPL],_cid,[NSString stringWithFormat:@"%ld",self.type],_count];
    [HttpRequest GET:url success:^(id responseObject) {
        if (responseObject[@"count"]) {
            headerView.numLabel.text = [NSString stringWithFormat:@"全部评论（%@）",responseObject[@"count"]];
        }

        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dic in responseObject[@"rel"]) {
            CommentListModel *model = [[CommentListModel alloc] initWithDictionary:dic];
            CommentListInitialModel *initialModel = [[CommentListInitialModel alloc] initWithDictionary:dic[@"huifu"]];
            if (initialModel.h_id.length) {
                //有数据，赋值
                model.initialModel = initialModel;
            }
            [_dataArray addObject:model];
        }
        if (_dataArray.count == 0) {
            [self createSpace];
        }else{
            spaceView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    B = [LHController setFont];
    _dataArray = [[NSMutableArray alloc] init];

    [self createTableView];
    [self createFootView];
}


-(void)createSpace{
    if (spaceView) {
        spaceView.hidden = NO;
        return;
    }
    spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 140)];
    spaceView.center = CGPointMake(WIDTH/2, HEIGHT/2-100);
    [self.view addSubview:spaceView];
    
    UIImageView *subImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    subImageView.image = [UIImage imageNamed:@"90"];
    [spaceView addSubview:subImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    label.text = @"暂无评论内容";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [spaceView addSubview:label];
}

//tabelview
-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.estimatedRowHeight = 100;
    [self.view addSubview:_tableView];

    headerView = [[CommentHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    _tableView.tableHeaderView = headerView;

    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];

    _count = 1;
    [_tableView.mj_header beginRefreshing];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    _tableView.mj_footer.automaticallyHidden = YES;

}

#pragma mark - 底部横条
-(void)createFootView{
    footView = [[FootCommentView alloc] initWithFrame:CGRectZero];
    footView.delegate = self;
    [footView oneButton];
    [self.view addSubview:footView];

    [footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(49);
    }];
}


#pragma mark - 发送
-(void)submitComment:(NSString *)content{
    if (![LHController judegmentSpaceChar:content]) {
        if (commentORanswer == commentTypeComment) {
            [LHController alert:@"评论内容不能为空"];
        }else{
            [LHController alert:@"回复内容不能为空"];
        }
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    dict[@"uid"] = [CZWManager manager].userID;
    if (commentORanswer == commentTypeComment) {
        [dict setObject:@"0" forKey:@"fid"];
    }else if (commentORanswer == commentTypeAnswer){
        dict[@"fid"] =_fid;
    }
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.cid forKey:@"tid"];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",self.type];
    [dict setObject:appOrigin forKey:@"origin"];
    
    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {

        if (responseObject[@"success"]) {
            [LHController alert:responseObject[@"success"]];
            //刷新数据
            _count = 1;
            [self loadData];
        }
        
    } failure:^(NSError *error) {
        [LHController alert:@"评论失败"];
    }];
}


#pragma mark - 返回
-(void)blockClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentListModel *model = _dataArray[indexPath.row];
    if (model.initialModel) {
        CommentListInitialCell *initialCell = [tableView dequeueReusableCellWithIdentifier:@"initialCell"];
        if (!initialCell) {
            initialCell = [[CommentListInitialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"initialCell"];
        }
        __weak __typeof(self)weakSelf = self;
        [initialCell getPid:^(NSString *pid) {
            [weakSelf pushComment:pid];
        }];
        initialCell.model = model;
        return initialCell;
    }
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }

    __weak __typeof(self)weakSelf = self;
    [cell getPid:^(NSString *pid) {
        [weakSelf pushComment:pid];
    }];
    
    cell.model = model;

    return cell;
}

- (void)pushComment:(NSString *)pid{
    _fid = pid;
    NSLog(@"%@",pid);
    commentORanswer = commentTypeAnswer;
    WriteViewController *comment = [[WriteViewController alloc] init];
    comment.title = @"回复";
    __weak __typeof(self)weakSelf = self;
    [comment send:^(NSString *content) {
        [weakSelf submitComment:content];
    }];
    [self presentViewController:comment animated:YES completion:nil];

}

#pragma mark - FootCommentViewDelegate
- (void)clickButton:(NSInteger)slected{
    if (slected == 0) {
        if ([CZWManager manager].isLogin) {
            WriteViewController *commentView = [[WriteViewController alloc] init];
            __weak __typeof(self)weakSelf = self;
            [commentView send:^(NSString *content) {
                [weakSelf submitComment:content];
            }];
            [self presentViewController:commentView animated:YES completion:nil];

        }else{

            [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        }
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
