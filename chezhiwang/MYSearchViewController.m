//
//  MYSearchViewController.m
//  chezhiwang
//
//  Created by bangong on 17/2/4.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "MYSearchViewController.h"
#import "BasicNavigationController.h"
@interface MYSearchViewController ()<UISearchResultsUpdating>
{
    UISearchController *_searchConroller;
}
@end

@implementation MYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _searchConroller = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchConroller.searchResultsUpdater = self;
    _searchConroller.dimsBackgroundDuringPresentation = YES;
    _searchConroller.hidesNavigationBarDuringPresentation = YES;
      self.definesPresentationContext = YES;
    [_searchConroller.searchBar sizeToFit];

//    _searchConroller.searchBar.frame = CGRectMake(100, 300, 100, 30);
//    [self.view addSubview:_searchConroller.searchBar];

    [((BasicNavigationController *)self.navigationController) bengingAlph];


    UITableView *tabelview = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tabelview];

    tabelview.tableHeaderView = _searchConroller.searchBar;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
  
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
