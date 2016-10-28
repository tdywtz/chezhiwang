//
//  HomepageTableViewController.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageTableViewController.h"

#import "HomepageSectionModel.h"

#import "HomepageNewsTextCell.h"
#import "HomepageNewsImageCell.h"
#import "HomepageComplainCell.h"
#import "HomepageResearchCell.h"
#import "HomepageAnswerCell.h"
#import "HomepageForumCell.h"

#import "HomepageSectionHeaderView.h"
#import "HomepageSectionFooterView.h"
#import "NewsTableHeaderView.h"

#import "NewsDetailViewController.h"
#import "ComplainDetailsViewController.h"
#import "AnswerDetailsViewController.h"
#import "PostViewController.h"

@interface HomepageTableViewController ()
{
    NSArray *_dataArray;
    NewsTableHeaderView *hearView;
}
@end

@implementation HomepageTableViewController

+ (instancetype)init{

    return [[self alloc] initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    hearView = [[NewsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 69+207*(WIDTH/375))];
    hearView.parentViewController = self;
    self.tableView.tableHeaderView = hearView;


    self.tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData{

    __weak __typeof(self)weakSelf  = self;
    [HttpRequest GET:[URLFile urlStringForLogin_index] success:^(id responseObject) {

        hearView.pointImages = responseObject[@"focuspic"];
        hearView.pointNews = responseObject[@"headlines"];
        _dataArray = [HomepageSectionModel arrryWithDictionary:responseObject];
        [weakSelf.tableView reloadData];

        [weakSelf.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomepageSectionModel *sectionModel = _dataArray[section];
    return sectionModel.rowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomepageSectionModel *sectionModel = _dataArray[indexPath.section];
    BasicObject *obj = sectionModel.rowModels[indexPath.row];

    if ([obj isKindOfClass:[HomepageNewsModel class]]) {
        //有图
        if (((HomepageNewsModel *)obj).image.length) {
            HomepageNewsImageCell *newsImageCell = [tableView dequeueReusableCellWithIdentifier:@"newsImageCell"];
            if (!newsImageCell) {
                newsImageCell = [[HomepageNewsImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsImageCell"];
            }
            newsImageCell.newsModel = (HomepageNewsModel *)obj;
            return newsImageCell;
        }

        //无图
        HomepageNewsTextCell *newsTextCell = [tableView dequeueReusableCellWithIdentifier:@"newsTextCell"];
        if (!newsTextCell) {
            newsTextCell = [[HomepageNewsTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsTextCell"];
        }
        newsTextCell.newsModel = (HomepageNewsModel *)obj;
        return newsTextCell;
    }

    if ([obj isKindOfClass:[HomepageComplainModel class]]) {
        HomepageComplainCell *complainCell = [tableView dequeueReusableCellWithIdentifier:@"complainCell"];
        if (!complainCell) {
            complainCell = [[HomepageComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"complainCell"];
        }
        complainCell.complainModel = (HomepageComplainModel *)obj;
        return complainCell;
    }


    if ([obj isKindOfClass:[HomepageResearchModel class]]) {
        HomepageResearchCell *researchCell = [tableView dequeueReusableCellWithIdentifier:@"researchCell"];
        if (!researchCell) {
            researchCell = [[HomepageResearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"researchCell"];
        }
        researchCell.researchModel = (HomepageResearchModel *)obj;
        return researchCell;
    }

    if ([obj isKindOfClass:[HomepageAnswerModel class]]) {
        HomepageAnswerCell *answerCell = [tableView dequeueReusableCellWithIdentifier:@"answerCell"];
        if (!answerCell) {
            answerCell = [[HomepageAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"answerCell"];
        }
        answerCell.answerModel = (HomepageAnswerModel *)obj;
        return answerCell;
    }


    HomepageForumCell *forumCell = [tableView dequeueReusableCellWithIdentifier:@"forumCell"];
    if (!forumCell) {
        forumCell = [[HomepageForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"forumCell"];
    }
    forumCell.forumModel = (HomepageForumModel *)obj;

    return forumCell;
}


#pragma mark - Tabel view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomepageSectionHeaderView *view = [[HomepageSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    view.sectionModel = _dataArray[section];

    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    HomepageSectionFooterView *view = [[HomepageSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    HomepageSectionModel *sectionModel = _dataArray[section];
    sectionModel.section = section;
    view.parentVC = self;
    view.sectionModel = sectionModel;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageSectionModel *sectionModel = _dataArray[indexPath.section];
    BasicObject *obj = sectionModel.rowModels[indexPath.row];
    if ([obj isKindOfClass:[HomepageNewsModel class]]) {
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = ((HomepageNewsModel *)obj).ID;
        NSString *url = ((HomepageNewsModel *)obj).image;
        //如果有图片链接，设置分享图片链接为第一个
        if (url.length > 1) {
            NSArray *urls = [url componentsSeparatedByString:@","];
            if (urls.count) {
                detail.shareImageUrl = urls[0];
            }
        }
        detail.invest = NO;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];

    }else if ([obj isKindOfClass:[HomepageComplainModel class]]) {
        ComplainDetailsViewController *detail = [[ComplainDetailsViewController alloc] init];
        detail.cid = ((HomepageComplainModel *)obj).cpid;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];

    }else if ([obj isKindOfClass:[HomepageResearchModel class]]) {
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = ((HomepageNewsModel *)obj).ID;
        //设置分享图片链接
        detail.shareImageUrl = ((HomepageNewsModel *)obj).image;
        detail.invest = YES;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];

    }else if ([obj isKindOfClass:[HomepageAnswerModel class]]) {
        AnswerDetailsViewController *detail = [[AnswerDetailsViewController alloc] init];
        detail.cid = ((HomepageAnswerModel *)obj).ID;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];

    }else if ([obj isKindOfClass:[HomepageForumModel class]]){
        PostViewController *post = [[PostViewController alloc] init];
        post.tid = ((HomepageForumModel *)obj).tid;
        post.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:post animated:YES];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
