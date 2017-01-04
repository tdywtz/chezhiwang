//
//  MyCardChooseViewController.m
//  chezhiwang
//
//  Created by bangong on 16/12/20.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyCardChooseViewController.h"

@interface MyCardChooseViewController ()

@end

@implementation MyCardChooseViewController

- (void)loadData{
    if (_urlString == nil) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest GET:_urlString success:^(id responseObject) {
        [weakSelf setData:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)setData:(id)data{
    if (self.type == MyCardChooseTypeBrand) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data[@"rel"]) {

            ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
            sectionModel.title = dict[@"letter"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"brand"]) {
                ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
                model.ID = subDic[@"id"];
                model.title = subDic[@"name"];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
        self.sectionModels = mArray;
        [self.tableView reloadData];

    }else if (self.type == MyCardChooseTypeSeries){
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data[@"rel"]) {

            ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
            sectionModel.title = dict[@"brands"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"series"]) {
                ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
                model.ID = subDic[@"seriesid"];
                model.title = subDic[@"seriesname"];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
        self.sectionModels = mArray;
        [self.tableView reloadData];

    }else if (self.type == MyCardChooseTypeModel){
        ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
        NSMutableArray *rowModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data[@"rel"]) {
            ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
            model.ID = dict[@"mid"];
            model.title = dict[@"modelname"];
            [rowModels addObject:model];
        }
        sectionModel.rowModels = rowModels;
        self.sectionModels = @[sectionModel];
        [self.tableView reloadData];

    }else if (self.type == MyCardChooseTypeProvince){
        ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
        NSMutableArray *rowModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data[@"rel"]) {
            ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
            model.ID = dict[@"id"];
            model.title = dict[@"name"];
            [rowModels addObject:model];
        }
        sectionModel.rowModels = rowModels;
        self.sectionModels = @[sectionModel];
        [self.tableView reloadData];

    }else if (self.type == MyCardChooseTypeCity){
        ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
        NSMutableArray *rowModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data[@"rel"]) {
            ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
            model.ID = dict[@"cid"];
            model.title = dict[@"cityname"];
            [rowModels addObject:model];
        }
        sectionModel.rowModels = rowModels;
        self.sectionModels = @[sectionModel];
        [self.tableView reloadData];

    }else if (self.type == MyCardChooseTypeArea){
        ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
        NSMutableArray *rowModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data[@"rel"]) {
            ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
            model.ID = dict[@"id"];
            model.title = dict[@"name"];
            [rowModels addObject:model];
        }
        sectionModel.rowModels = rowModels;
        self.sectionModels = @[sectionModel];
        [self.tableView reloadData];

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == MyCardChooseTypeBrand) {
        _urlString = [URLFile urlStringForLetter];
    }else if (self.type == MyCardChooseTypeProvince){
        _urlString = [URLFile urlStringForPro];
    }

    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)setType:(MyCardChooseType)type{
    _type = type;

    self.title = [self titleWithType:type];
}

- (NSString *)titleWithType:(MyCardChooseType)type{
    switch (type) {
        case MyCardChooseTypeBrand:
            return @"品牌";
        case MyCardChooseTypeSeries:
            return @"车系";
        case MyCardChooseTypeModel:
            return @"车型";
        case MyCardChooseTypeProvince:
            return @"省份";
        case MyCardChooseTypeCity:
            return @"城市";
        case MyCardChooseTypeArea:
            return @"县区";
        default:
            return @"";
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseTableViewSectionModel *sectionModel = self.sectionModels[indexPath.section];
    ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];

    if (self.type == MyCardChooseTypeBrand) {
        MyCardChooseViewController *vc = [[MyCardChooseViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.type = MyCardChooseTypeSeries;
        vc.isShowSection = YES;
        vc.urlString = [NSString stringWithFormat:[URLFile urlStringForSeries],model.ID];
        vc.aModel = model;
        vc.endChoose = self.endChoose;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.type == MyCardChooseTypeSeries){
        MyCardChooseViewController *vc = [[MyCardChooseViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.type = MyCardChooseTypeModel;
        vc.urlString = [NSString stringWithFormat:[URLFile urlStringForModelList],model.ID];
        vc.aModel = self.aModel;
        vc.bModel = model;
        vc.endChoose = self.endChoose;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (self.type == MyCardChooseTypeModel){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"bid"] = self.aModel.ID;
        dict[@"bname"] = self.aModel.title;
        dict[@"sid"] = self.bModel.ID;
        dict[@"sname"] = self.bModel.title;
        dict[@"mid"] = model.ID;
        dict[@"mname"] = model.title;

        __weak __typeof(self)weakSelf = self;
        NSString *url = [NSString stringWithFormat:[URLFile urlStringForpersonalInfo],[CZWManager manager].userID];
        [HttpRequest POST:url parameters:dict success:^(id responseObject) {
            if (responseObject[@"success"]) {
                if (weakSelf.endChoose) {
                    weakSelf.endChoose(model.title);
                }
                [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count-1 - 3] animated:YES];
            }else{
                [LHController alert:responseObject[@"error"]];
            }

        } failure:^(NSError *error) {

        }];


    }else if (self.type == MyCardChooseTypeProvince){
        MyCardChooseViewController *vc = [[MyCardChooseViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.type = MyCardChooseTypeCity;
        vc.urlString = [NSString stringWithFormat:[URLFile urlStringForCity],model.ID];
        vc.aModel = model;
        vc.endChoose = self.endChoose;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (self.type == MyCardChooseTypeCity){
        MyCardChooseViewController *vc = [[MyCardChooseViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.type = MyCardChooseTypeArea;
        vc.urlString = [NSString stringWithFormat:[URLFile urlStringForArea],model.ID];
        vc.aModel = self.aModel;
        vc.bModel = model;
        vc.endChoose = self.endChoose;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (self.type == MyCardChooseTypeArea){

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"pid"] = self.aModel.ID;
        dict[@"pname"] = self.aModel.title;
        dict[@"cid"] = self.bModel.ID;
        dict[@"cname"] = self.bModel.title;
        dict[@"aid"] = model.ID;
        dict[@"aname"] = model.title;
        
        __weak __typeof(self)weakSelf = self;
        NSString *url = [NSString stringWithFormat:[URLFile urlStringForpersonalInfo],[CZWManager manager].userID];
        [HttpRequest POST:url parameters:dict success:^(id responseObject) {
          
            if (responseObject[@"success"]) {
                if (weakSelf.endChoose) {
                    weakSelf.endChoose([NSString stringWithFormat:@"%@%@%@",self.aModel.title,self.bModel.title,model.title]);
                }
                [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count-1 - 3] animated:YES];

            }else {
                [LHController alert:responseObject[@"error"]];
            }

        } failure:^(NSError *error) {

        }];
    }
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
