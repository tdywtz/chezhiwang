//
//  TakeViewController.m
//  auto
//
//  Created by bangong on 15/6/17.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "TakeViewController.h"
#import "NewsDetailViewController.h"

@interface TakeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation TakeViewController

-(void)readData{
    FmdbManager *manager = [FmdbManager shareManager];
    _dataArray = [[NSMutableArray alloc] initWithArray:[manager selectAllFromReadHistory:ReadHistoryTypeNews]];
    [_tableView reloadData];
    if (_dataArray.count == 0) {
        [self createSpace];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

   
    [self createTableView];
    [self readData];
}

-(void)createSpace{

   UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 140)];
    spaceView.center = CGPointMake(WIDTH/2, HEIGHT/2-100);
    [self.view addSubview:spaceView];
    
    UIImageView *subImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    subImageView.image = [UIImage imageNamed:@"90"];
    [spaceView addSubview:subImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    label.text = @"暂无浏览内容";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [spaceView addSubview:label];
}


-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"take"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"take"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, WIDTH-15, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [cell.contentView addSubview:view];
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *details = [[NewsDetailViewController alloc] init];
    details.ID = _dataArray[indexPath.row][@"id"];
    details.titleLabelText = _dataArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:details animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    return YES;
//    
//}
//定义编辑样式

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    [tableView setEditing:YES animated:YES];
//    
//    return UITableViewCellEditingStyleDelete;
//    
//}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"919";
//}

//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction *ac = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"nono" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"%@",indexPath);
//        [_dataArray removeObjectAtIndex:indexPath.row];
//        [_tableView reloadData];
//    }];
//    UITableViewRowAction *bc = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"yy" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"0000");
//    }];
//    return @[ac,bc];
//    
//}

//进入编辑模式，按下出现的编辑按钮后

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    NSLog(@"666");
//   // [tableView setEditing:NO animated:YES];
//    
//}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
