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
#import "LoginViewController.h"


@interface IconCell : UITableViewCell

@end

@implementation IconCell

- (void)layoutSubviews{
    [super  layoutSubviews];

    CGFloat width = self.frame.size.height-20;
    self.imageView.frame = CGRectMake(10, 10, width,width);
    // self.imageView.contentMode = UIViewContentModeCenter;

    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 10+width+10;
    self.textLabel.frame = tmpFrame;

    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = 10+width+10;
    self.detailTextLabel.frame = tmpFrame;
}

@end


@interface MyViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_tableView;
    NSArray *_dataArray;
    NSDictionary *numDictonary;//存放各类数量的字典
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createItem];
    [self createTableView];
    [self reloadData];
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //每次页面出现刷新页面数据
    [[SDImageCache sharedImageCache] removeImageForKey:[[NSUserDefaults standardUserDefaults] objectForKey:user_iconImage] fromDisk:YES];

    [self updateNumber];
    [self reloadData];

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
    if (![[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        //数量字典置空
        numDictonary = nil;
        _dataArray = @[
                       @[
                           @{@"class":@"LoginViewController",@"title":@"登录|注册",@"imageName":@"defaultImage_icon"}
                           ],
                       @[
                           @{@"class":@"MyComplainViewController",@"title":@"我的投诉",@"imageName":@"center_complain"},
                           @{@"class":@"MyAskViewController",@"title":@"我的提问",@"imageName":@"center_answer"},
                           @{@"class":@"MyCommentViewController",@"title":@"我的评论",@"imageName":@"center_comment"},
                           @{@"class":@"FavouriteViewController",@"title":@"我的收藏",@"imageName":@"center_favorite"}
                           ],
                       ];
        _tableView.tableFooterView.hidden = YES;

    }else{
        _tableView.tableFooterView.hidden = NO;
        _dataArray = @[
                       @[
                           @{@"class":@"MyCarViewController",@"title":@"",@"imageName":@"defaultImage_icon"}
                           ],
                       @[
                           @{@"class":@"MyComplainViewController",@"title":@"我的投诉",@"imageName":@"center_complain"},
                           @{@"class":@"MyAskViewController",@"title":@"我的提问",@"imageName":@"center_answer"},
                           @{@"class":@"MyCommentViewController",@"title":@"我的评论",@"imageName":@"center_comment"},
                           @{@"class":@"FavouriteViewController",@"title":@"我的收藏",@"imageName":@"center_favorite"}
                           ],
                       @[
                           @{@"class":@"PasswordViewController",@"title":@"密码修改",@"imageName":@"center_password"}
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


    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    UIButton *btn = [LHController createButtnFram:CGRectZero Target:self Action:@selector(logoutClick) Font:15 Text:@"退出登录"];
    [tableFootView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(20, 15, 20, 15));
    }];
    _tableView.tableFooterView = tableFootView;
}



#pragma mark -更新数目
-(void)updateNumber{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPersonalCount],[[NSUserDefaults standardUserDefaults] objectForKey:user_name],[[NSUserDefaults standardUserDefaults] objectForKey:user_passWord]] ;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        [df removeObjectForKey:user_name];
        [df removeObjectForKey:user_id];
        [df synchronize];

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

    if (indexPath.section == 0) {
        IconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
        if (!cell) {
            cell = [[IconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }

        NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
        cell.textLabel.text = dict[@"title"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:user_iconImage]] placeholderImage:[UIImage imageNamed:dict[@"imageName"]]];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
            cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:user_name];
        }
        return cell;
    }


    //
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
        //            [UIFont asynchronouslySetFontName:[UIFont fontNameSTXingkai_SC_Bold] success:^(NSString *name) {
        //                cell.textLabel.font = [UIFont fontWithName:name size:18];
        //            }];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-4);
            make.centerY.equalTo(0);
        }];
    }
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    cell.textLabel.text = dict[@"title"];

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    if (indexPath.section == 1) {
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

- (void)logoutClick{
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:user_name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadData];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
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
