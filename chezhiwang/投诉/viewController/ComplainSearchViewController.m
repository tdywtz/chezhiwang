//
//  ComplainSearchViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/18.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainSearchViewController.h"
#import "ComplainDetailsViewController.h"
#import "SearchHistoryView.h"

@interface ComplainSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *noView;
    CGFloat B;

    NSInteger _count;
    NSInteger _number;

    BOOL isOne;
    SearchHistoryView *_historyView;
    NSString * _searchText;
}
@end

@implementation ComplainSearchViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 请求数据
-(void)loadData{
    //处理汉字

    [HttpRequest GET:self.urlString success:^(id responseObject) {
        if (_count == 1) {

            [_dataArray removeAllObjects];
        }

      [_dataArray addObjectsFromArray:[self arrayWithResponseObject:responseObject]];
        [_tableView reloadData];

        if ([_dataArray count] == 0) {
            noView.hidden = NO;
        }else{
            noView.hidden = YES;
        }

        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [_tableView.mj_footer endRefreshing];
    }];
}

- (NSArray *)arrayWithResponseObject:(id)responseObject{
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in responseObject[@"rel"]) {
        NSString *ID = dict[@"id"]?dict[@"id"]:dict[@"cpid"];
        NSString *question = dict[@"question"]?dict[@"question"]:dict[@"title"];
        [marr addObject:@{@"id":ID,@"question":question}];
    }

    return marr;
}

-(void)setUrlWith:(NSString *)string andP:(NSInteger)p andS:(NSInteger)s{
    self.urlString = [NSString stringWithFormat:[URLFile urlStringForZLTSWithSearch],string,p,s];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    _number = 15;
    if (HEIGHT == 480) {
        _number = 9;
    }
    if (HEIGHT == 568) {
        _number = 12;
    }
    if (HEIGHT == 667) {

    }
    B = [LHController setFont];
    [self createLeftItem];
    [self createRightItem];
    [self createTitleView];
    [self createTabelView];
    [self createNoView];
    [self history];

    [self.searchBar becomeFirstResponder];
}



-(void)history{
    historyType type;
    if (self.numType == 2) {
        type = historyTypeComplain;
    }else if (self.numType == 3){
        type = historyTypeANswer;
    }else if (self.numType == 1){
        type = historyTypeNews;
    }
    _historyView = [[SearchHistoryView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) Type:type];
    //_historyView.hidden = YES;
    [_historyView  selectSring:^(NSString *string) {
        _count = 1;
        _searchText = string;
        [self setUrlWith:string andP:_count andS:_number];
        [self loadData];
        [self.searchBar resignFirstResponder];
        _historyView.hidden = YES;
    }];
    [self.view addSubview:_historyView];
    [_historyView reloadDataOFtableview:self.searchBar.text];
}

#pragma mark 搜索不到数据
-(void)createNoView{
    noView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    [self.view addSubview:noView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    imageView.image = [UIImage imageNamed:@"90"];
    imageView.center = CGPointMake(WIDTH/2, HEIGHT/2-150);
    [noView addSubview:imageView];

    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, 180, 20) Font:B Bold:NO TextColor:[UIColor blackColor] Text:@"没有搜索到结果"];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(WIDTH/2, imageView.frame.origin.y+imageView.frame.size.height+20);
    [noView addSubview:label];

    noView.hidden = YES;
}

#pragma mark uitabelView创建
-(void)createTabelView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [self loadData];
    }];
}

-(void)createTitleView{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH-60, 45)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入关键字";
}

-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightitemClick) Text:@"取消"];
    btn.titleLabel.font = [UIFont systemFontOfSize:B-2];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightitemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchResultsDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    self.header = YES;
    _count = 1;
    _searchText = self.searchBar.text;
    [self setUrlWith:self.searchBar.text andP:_count andS:_number];
    [self.searchBar resignFirstResponder];
    [self loadData];
    _historyView.hidden = YES;
    [_historyView updataOFhistory:self.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //    if (_sb.text.length == 0) {
    //        _historyView.hidden = YES;
    //    }else{
    //        _historyView.hidden = NO;
    //
    //    }
    _historyView.hidden = NO;
    [_historyView reloadDataOFtableview:self.searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _historyView.hidden = NO;
    [_historyView reloadDataOFtableview:self.searchBar.text];
    return YES;
}

#pragma mark - 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str searchStr:(NSString *)search{

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:B] range:NSMakeRange(0, att.length)];
    for (int i = 0; i < search.length; i ++) {
        NSRange ran = {i,1};
        NSString *sub = [search substringWithRange:ran];
        NSRange range = [str rangeOfString:sub];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    }


    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    //[style setLineBreakMode:NSLineBreakByWordWrapping];
    // style.firstLineHeadIndent = 30;
    //style.paragraphSpacing = 20;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
    return att;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
        [cell.contentView addSubview:view];
    }

    NSDictionary *dict = _dataArray[indexPath.row];
    cell.textLabel.attributedText = [self attributeSize:dict[@"question"] searchStr:_searchText];


    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    ComplainDetailsViewController *user = [[ComplainDetailsViewController alloc] init];
    user.cid = dic[@"id"];
    [self.navigationController pushViewController:user animated:YES];

}

//#pragma mark - MJRefreshBaseViewDelegate
//-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    //    if (refreshView == headerView) {
//    //
//    //        self.header = YES;
//    //
//    //        [self setUrlWithP:1 andS:_number];
//    //        [self loadData];
//    //        _count = 1;
//    //    }else if (refreshView == footView){
//
//    if (_count < 1) {
//        _count = 1;
//    }
//    _count ++;
//    [self setUrlWith:_searchBar.text andP:_count andS:_number];
//    [self loadData];
//    // }
//}


/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
