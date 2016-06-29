//
//  AnswerSearchViewController.m
//  auto
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerSearchViewController.h"
#import "AnswerDetailsViewController.h"

@interface AnswerSearchViewController ()

@end

@implementation AnswerSearchViewController

-(void)setUrlWith:(NSString *)string andP:(NSInteger)p andS:(NSInteger)s{
    self.urlString = [NSString stringWithFormat:[URLFile urlStringForZJDYSearch],string,p,s];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    AnswerDetailsViewController *user = [[AnswerDetailsViewController alloc] init];
    user.cid = dic[@"id"];
    user.type = @"3";
    user.textTitle = dic[@"question"];
    
    [self.navigationController pushViewController:user animated:YES];
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
