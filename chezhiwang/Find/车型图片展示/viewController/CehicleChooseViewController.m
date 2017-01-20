
//
//  CehicleChooseViewController.m
//  chezhiwang
//
//  Created by bangong on 16/8/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CehicleChooseViewController.h"
#import "ChartChooseModel.h"

@interface CehicleChooseViewController ()

@end

@implementation CehicleChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDataWithTestView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (self.type == ChartChooseTypeBrand) {
        [HttpRequest GET:[URLFile urlString_picBrand] success:^(id responseObject) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject[@"rel"]) {
                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                for (NSDictionary *subDict in dict[@"brandlist"]) {
                    ChartChooseModel * model = [[ChartChooseModel alloc] init];
                    model.tid = subDict[@"bid"];
                    model.title = subDict[@"name"];
                    [subArray addObject:model];
                }
                NSDictionary *saveDict = @{@"name":dict[@"letter"],sectionArray:subArray};
                [mArray addObject:saveDict];
            }
            self.dataArray = [mArray copy];
            [self.tableView reloadData];

        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }else if (self.type == ChartChooseTypeSeries){
        NSString *url = [NSString stringWithFormat:[URLFile urlString_picSeries],self.brandId];

        [HttpRequest GET:url success:^(id responseObject) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];


            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject[@"rel"]) {

                ChartChooseModel * model = [[ChartChooseModel alloc] init];
                model.tid = dict[@"sid"];
                model.title = dict[@"name"];
                [mArray addObject:model];
            }

            self.dataArray = @[
                           @{@"name":@"",sectionArray:mArray}
                           ];

            [self.tableView reloadData];

        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
