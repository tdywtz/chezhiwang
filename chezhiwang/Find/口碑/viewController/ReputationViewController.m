//
//  ReputationViewController.m
//  chezhiwang
//
//  Created by bangong on 16/11/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ReputationViewController.h"
#import "ReputationCell.h"

@interface ReputationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation ReputationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
    [self.view addSubview:_tableView];

    [self loadData];
}

- (void)loadData{
    _dataArray = @[[ReputationModel new],[ReputationModel new],[ReputationModel new],[ReputationModel new],[ReputationModel new]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReputationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ReputationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
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
