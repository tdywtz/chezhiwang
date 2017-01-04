//
//  CommentViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentCell.h"
#import "MyCommentModel.h"
#import "AnswerDetailsViewController.h"
#import "NewsDetailViewController.h"
#import "ComplainDetailsViewController.h"

@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView *_tableView;
    NSMutableArray *_dataArray;

    NSInteger _count;
}
@end

@implementation MyCommentViewController


-(void)loadData{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForDiscuss],[CZWManager manager].userID,_count];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {

            [_dataArray removeAllObjects];
        }
    
        [_tableView.mj_header endRefreshing];

        if ([responseObject[@"rel"] count] == 0) {
        
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dict in responseObject[@"rel"]) {
            MyCommentModel *model = [MyCommentModel mj_objectWithKeyValues:dict];
            [_dataArray addObject:model];
        }

        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的评论";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTabelView];

}

-(void)createTabelView{
    _dataArray = [[NSMutableArray alloc] init];

    self.navigationController.modalPresentationCapturesStatusBarAppearance = NO;
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tabelView.separatorInset = UIEdgeInsetsMake(0, -100, 0, 0);
    [self.view addSubview:_tableView];


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

-(void)createSpace{
    self.backgroundView.contentLabel.text = @"暂无评论";
    self.backgroundView.hidden = NO;
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

    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyCommentModel *model = _dataArray[indexPath.row];

    NSInteger type = [model.type integerValue];
    if (type == 3) {
        AnswerDetailsViewController *an = [[AnswerDetailsViewController alloc] init];
        an.cid = model.ID;
        [self.navigationController pushViewController:an animated:YES];

    }else if (type == 2){
        ComplainDetailsViewController *user = [[ComplainDetailsViewController alloc] init];
        user.cid = model.ID;
        [self.navigationController pushViewController:user animated:YES];

    }else if (type == 1){
        NewsDetailViewController *new = [[NewsDetailViewController alloc] init];
        new.ID = model.ID;
        [self.navigationController pushViewController:new animated:YES];
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
