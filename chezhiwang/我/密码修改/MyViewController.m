//
//  MyViewController.m
//  auto
//
//  Created by bangong on 15/6/1.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
#import "MyComplainViewController.h"
#import "MyAskViewController.h"
#import "MyCommentViewController.h"
#import "FavouriteViewController.h"
#import "PasswordViewController.h"
#import "MyCarViewController.h"

#import "MyHeaderView.h"
#import "BasicNavigationController.h"


@interface MyViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_tableView;
    NSArray *_dataArray;
    NSDictionary *numDictonary;//存放各类数量的字典
    MyHeaderView *headerView;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:[UIView new]];
    
    [self createItem];
    [self createTableView];
    [self reloadData];
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    if([CZWManager manager].isLogin){
        //每次页面出现刷新页面数据
        [[SDImageCache sharedImageCache] removeImageForKey:[CZWManager manager].iconUrl fromDisk:YES];

        [self updateNumber];
        [self reloadData];
    }

    BasicNavigationController *nvc = (BasicNavigationController *)self.navigationController;
    [nvc bengingAlph];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    BasicNavigationController *nvc = (BasicNavigationController *)self.navigationController;
    [nvc endAlph];
}


#pragma mark - 设置
-(void)createItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 17, 17) Target:self Action:@selector(itemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"center_settring"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)itemClick{

    SettingViewController *set = [[SettingViewController alloc] init];
    set.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
}


- (void)reloadData{
    if (![CZWManager manager].isLogin) {
        //数量字典置空
        numDictonary = nil;
        _dataArray = @[
                       @[
                           @{@"class":@"MyComplainViewController",@"title":@"我的投诉",@"imageName":@"centre_complain"},
                           @{@"class":@"MyAskViewController",@"title":@"我的提问",@"imageName":@"centre_answer"},
                           @{@"class":@"MyCommentViewController",@"title":@"我的评论",@"imageName":@"centre_comment"},
                           @{@"class":@"FavouriteViewController",@"title":@"我的收藏",@"imageName":@"centre_favorite"}
                           ],
                       ];
        _tableView.tableFooterView.hidden = YES;
        [headerView setTitle:@"  登录/注册  " imageUrl:nil login:NO];

    }else{
        _tableView.tableFooterView.hidden = NO;
         [headerView setTitle:[CZWManager manager].userName imageUrl:[CZWManager manager].iconUrl login:YES];
        _dataArray = @[
                       @[
                           @{@"class":@"MyComplainViewController",@"title":@"我的投诉",@"imageName":@"centre_complain"},
                           @{@"class":@"MyAskViewController",@"title":@"我的提问",@"imageName":@"centre_answer"},
                           @{@"class":@"MyCommentViewController",@"title":@"我的评论",@"imageName":@"centre_comment"},
                           @{@"class":@"FavouriteViewController",@"title":@"我的收藏",@"imageName":@"centre_favorite"}
                           ],
                       @[
                           @{@"class":@"PasswordViewController",@"title":@"密码修改",@"imageName":@"centre_password"}
                           ],
                       ];


    }

    [_tableView reloadData];

}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];


    headerView = [[MyHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 230)];
    headerView.parentVC = self;
    _tableView.tableHeaderView = headerView;

    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    _tableView.tableFooterView = tableFootView;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
     btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:colorOrangeRed forState:UIControlStateNormal];
    [tableFootView addSubview:btn];

    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(20);
        make.height.equalTo(40);
    }];

}

- (void)logoutClick{
   UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"是否确定退出当前账号？"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"确定", nil];
    al.delegate = self;
    [al show];
}


#pragma mark -更新数目
-(void)updateNumber{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPersonalCount],[CZWManager manager].userName,[CZWManager manager].password];
    [HttpRequest GET:url success:^(id responseObject) {
        NSDictionary *dict = responseObject[0];
        if (dict[@"complain"]) {
            numDictonary = dict;
            [self reloadData];
        }

    } failure:^(NSError *error) {

    }];
}


#pragma mark - UIAlertViewDelegate <NSObject>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[CZWManager manager] logoutAccount];
        [self reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"centerCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc ] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = colorLightGray;
        label.tag = 100;
        [cell.contentView addSubview:label];

        [label makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-4);
            make.centerY.equalTo(0);
        }];
    }
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    cell.textLabel.text = dict[@"title"];

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            label.text = numDictonary[@"complain"];
        }else if (indexPath.row == 1){
            label.text = numDictonary[@"question"];
        }else if (indexPath.row == 2){
            label.text = numDictonary[@"discuss"];
        }else if (indexPath.row == 3){
            label.text = [NSString stringWithFormat:@"%ld",(long)[[FmdbManager shareManager] selectCollectNumber]];

        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        if (![CZWManager manager].isLogin) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"您还未登录，您可以登录后进行操作"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
                [alert show];


            });
            return;
        }
    
    Class cls = NSClassFromString(_dataArray[indexPath.section][indexPath.row][@"class"]);
    if (!cls) {
        return;
    }
    UIViewController *vc = [[cls alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
