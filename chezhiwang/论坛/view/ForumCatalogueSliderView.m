//
//  ForumCatalogueSliderView.m
//  chezhiwang
//
//  Created by bangong on 16/11/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumCatalogueSliderView.h"
#import "ForumCatalogueSectionModel.h"
#import "ForumClassifyListViewController.h"

@interface ForumCatalogueSliderView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ForumCatalogueSliderView
{
    UITableView *_tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView  = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 30;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];       
        [self addSubview:_tableView];

    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    }
    return self;
}

- (void)setDataArray:(NSArray<ForumCatalogueSectionModel *> *)dataArray{
    _dataArray = dataArray;

    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ForumCatalogueSectionModel *sectionModel = _dataArray[section];

    return sectionModel.roeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ForumCatalogueSectionModel *sectionModel = _dataArray[indexPath.section];
    ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];
    cell.textLabel.text = model.title;
  
    return cell;
}

#pragma mark- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       ForumClassifyListViewController *list = [[ForumClassifyListViewController alloc] init];
       ForumCatalogueSectionModel *sectionModel = _dataArray[indexPath.section];
       ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];

        list.sid = model.ID;
        list.forumType = forumClassifyBrand;
        [self.parentViewController.navigationController pushViewController:list animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ForumCatalogueSectionModel *sectionModel = _dataArray[section];
    return sectionModel.title;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
