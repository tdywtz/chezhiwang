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


#define bidui @"bidui"//tiwen
#define bidui_com @"biduiComolain"//toshu

@interface MyViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_tableView;
    NSArray *_dataArray;
    NSDictionary *numDictonary;
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

    }else{
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
                       @[
                           @{@"class":@"退出按钮",@"title":@"",@"imageName":@"退出按钮"}
                           ]
                       ];

    }
    
    [_tableView reloadData];
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
        cell.textLabel.text = dict[@"title"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:user_iconImage]] placeholderImage:[UIImage imageNamed:dict[@"imageName"]]];

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
    }else{
        label.text = @"";
    }

    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还未登陆，您可以登陆后进行操作"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
    }
    Class cls = NSClassFromString(_dataArray[indexPath.section][indexPath.row][@"class"]);
    UIViewController *vc = [[cls alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
