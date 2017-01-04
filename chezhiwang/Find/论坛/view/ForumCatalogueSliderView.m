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
        _tableView.rowHeight = 50;
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


- (void)loadData{
    __weak __typeof(self)weakSlef = self;
    [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForSeries],self.brandId];
    [HttpRequest GET:url success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakSlef.parentViewController.view animated:YES];
        [ForumCatalogueModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"title":@"seriesname",@"ID":@"seriesid"};
        }];
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"rel"]) {

            ForumCatalogueSectionModel *sectionModel = [[ForumCatalogueSectionModel alloc] init];
            sectionModel.title = dict[@"brands"];

            sectionModel.roeModels = [ForumCatalogueModel mj_objectArrayWithKeyValuesArray:dict[@"series"]];

            [sections addObject:sectionModel];
        }
        _dataArray = sections;
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSlef.parentViewController.view animated:YES];
    }];
}

- (void)setDataArray:(NSArray<ForumCatalogueSectionModel *> *)dataArray{
    _dataArray = dataArray;

    [_tableView reloadData];
}

- (void)setBrandId:(NSString *)brandId{
    _brandId = [brandId copy];

    [self loadData];
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
        cell.textLabel.textColor = colorBlack;
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
