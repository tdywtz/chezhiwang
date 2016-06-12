//
//  CommentListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListCell.h"
#import "LoginViewController.h"
#import "CustomCommentView.h"

typedef enum {
    commentTypeComment = 1,//评论
    commentTypeAnswer = 2//回复
}commentType;

@interface CommentListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    
    CustomCommentView *_commentView;
    CGFloat _height;
    NSString *_fid;//被回复id
    CGFloat B;
    commentType commentORanswer;
    
    UIView *spaceView;
}
@end

@implementation CommentListViewController

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPL],_cid,self.type,(long)p,(long)s];
    [HttpRequest GET:url success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[0][@"list"]) {
            if ([dic allKeys].count == 0) continue;
            [_dataArray addObject:dic];
        }
        if (_dataArray.count == 0) {
            [self createSpace];
        }else{
            spaceView.hidden = YES;
        }
        [_tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    B = [LHController setFont];
    _dataArray = [[NSMutableArray alloc] init];
    [self createLeftItem];
    [self createTableView];
    [self createFootView];
    
    [self loadDataWithP:1 andS:10];
}

-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(leftItemClick)];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-49-64) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabelView];
}

#pragma mark - 底部横条
-(void)createFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1];
    [self.view addSubview:view];
    
    UIButton *write = [LHController createButtnFram:CGRectMake(10, 10, WIDTH-20, 28) Target:self Action:@selector(writeClick) Text:nil];
    write.backgroundColor = [UIColor whiteColor];
    [view addSubview:write];
    
    [write setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [write setTitle:@"写评论" forState:UIControlStateNormal];
    [write setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [write setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    write.titleLabel.font = [UIFont systemFontOfSize:14];
}

#pragma mark - 点击评论按钮
-(void)writeClick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        
        commentORanswer = commentTypeComment;
        CustomCommentView *commentView = [[CustomCommentView alloc] init];
        commentView.title =  @"评论";
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
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:user_id] forKey:@"uid"];
    if (commentORanswer == commentTypeComment) {
        [dict setObject:@"0" forKey:@"fid"];
    }else if (commentORanswer == commentTypeAnswer){
        [dict setObject:_fid forKey:@"fid"];
    }
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.cid forKey:@"tid"];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:@"7" forKey:@"origin"];
    
    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [LHController alert:@"评论成功"];
            //刷新数据
            [self loadDataWithP:1 andS:10];
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
    
    
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    [cell getHeight:^(CGFloat gao) {
        _height = gao;
    }];
    [cell getPid:^(NSString *pid) {
        _fid = pid;
        commentORanswer = commentTypeAnswer;
        CustomCommentView *comment = [[CustomCommentView alloc] init];
        comment.title = @"回复";
        [comment show];
        [comment send:^(NSString *content) {
            [self submitComment:content];
        }];
        
    }];
    
    cell.dictionary = _dataArray[indexPath.row];
    //设置右侧的提示样式
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _height;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([LHController stringContainsEmoji:text]) {
        
        return NO;
    }
    return YES;
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
