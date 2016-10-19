//
//  NewsSearchViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/13.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "NewsSearchViewController.h"
#import "NewsDetailViewController.h"

@interface NewsSearchViewController ()

@end

@implementation NewsSearchViewController

-(void)setUrlWith:(NSString *)string andP:(NSInteger)p andS:(NSInteger)s{
    self.urlString = [NSString stringWithFormat:[URLFile urlStringForNewsSearch],self.style,string,p,s];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
    detail.ID = dic[@"id"];
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
