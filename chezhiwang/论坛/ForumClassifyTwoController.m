//
//  ForumClassifyTwoController.m
//  chezhiwang
//
//  Created by bangong on 15/10/14.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumClassifyTwoController.h"
#import "ForumClassifyListViewController.h"
#import "WritePostViewController.h"

@interface ForumClassifyTwoController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation ForumClassifyTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"栏目论坛";
    [self createLeftItem];
    [self createTableView];
    
    [self createData];
}

-(void)createData{
    NSArray *array1 = @[@"故障交流",@"用车心得",@"人车生活",@"汽车文化",@"七嘴八舌",@"汽车召回与三包"];
    NSArray *array2 = @[@"2",@"381",@"1",@"5",@"4",@"6"];
    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array1.count; i ++) {
        [_dataArray addObject:@{@"name":array1[i],@"cid":array2[i]}];
    }
    [_tableView reloadData];
}

-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(leftItemClick)];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotcell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [cell.contentView addSubview:view];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"column%ld",indexPath.row]];
    cell.imageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    cell.textLabel.text = _dataArray[indexPath.row][@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.nextType == classifyNextPop) {
        if ( self.block) {
            self.block(_dataArray[indexPath.row][@"cid"],_dataArray[indexPath.row][@"name"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.pushtype == twoPushTypeList) {
        ForumClassifyListViewController *post = [[ForumClassifyListViewController alloc] init];
        post.sid = _dataArray[indexPath.row][@"cid"];
        post.forumType = forumClassifyColumn;
        [self.navigationController pushViewController:post animated:YES];
    }else{
        WritePostViewController *write = [[WritePostViewController alloc] init];
        write.cid = _dataArray[indexPath.row][@"cid"];
        [self.navigationController pushViewController:write animated:YES];
    }
   
}

//回调
-(void)returnCid:(returnCid)block{
    self.block = block;
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
