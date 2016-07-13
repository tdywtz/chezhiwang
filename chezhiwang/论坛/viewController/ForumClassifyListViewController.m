//
//  ForumClassifyListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/10/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumClassifyListViewController.h"
#import "ForumListCell.h"
#import "PostViewController.h"
#import "WritePostViewController.h"
#import "ApplyModeratorsViewController.h"
#import "LoginViewController.h"

@interface ForumClassifyListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger orderType;
    NSInteger topicType;
    
    NSString *_urlString;
    NSInteger _count;
    BOOL header;
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
}

@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation ForumClassifyListViewController
- (void)dealloc
{
    [headerView removeFromSuperview];
    [footView removeFromSuperview];
}
-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:_urlString,self.sid,orderType,topicType,p,s];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            
            [_dataArray removeAllObjects];
        }
        if ([responseObject count] == 0) {
            footView.noData = YES;
        }
        for (NSDictionary *dict in responseObject) {
            [_dataArray addObject:dict];
        }
        [_tableView reloadData];
        [headerView endRefreshing];
        [footView endRefreshing];

    } failure:^(NSError *error) {
        [headerView endRefreshing];
        [footView endRefreshing];
    }];
}

-(void)setUrl{
    if (self.forumType == forumClassifyBrand) {
        _urlString = [URLFile urlStringForBrand_postlist];
    }else{
        _urlString = [URLFile urlStringForColumn_postlist];
    }
}

-(void)loadDataHeader{
    NSString *url;
    if (self.forumType == forumClassifyBrand) {
        url = [NSString stringWithFormat:[URLFile urlStringForSeriesForm],self.sid];
    }else{
        url = [NSString stringWithFormat:[URLFile urlString_columnform],self.sid];
    }
 
  [HttpRequest GET:url success:^(id responseObject) {
      if ([responseObject count] > 0) {
          if (self.forumType == forumClassifyBrand) {
              [self createTableHeaderView:responseObject[0]];
              self.dictionary = responseObject[0];
          }else{
              [self createTableHeaderViewLanMu:responseObject[0]];
          }
      }

  } failure:^(NSError *error) {
      
  }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];

    [self createRightItem];
    [self createTableView];
    //[self createFootView];
    [self loadDataHeader];
    orderType = 0;
    topicType = 0;
    _count = 1;
    [self setUrl];
    [self loadDataWithP:_count  andS:10];
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"forum_write"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]){
        WritePostViewController *write = [[WritePostViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:write];
        nvc.navigationBar.barStyle = UIBarStyleBlack;
        if (self.forumType == forumClassifyBrand) {
            write.sid = self.sid;
        }else{
            write.cid = self.sid;
        }
        write.classify = self.forumType;
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypePopView;
        [self.navigationController pushViewController:my animated:YES];
    }
}

#pragma mark - 创建列表
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    headerView.delegate = self;
    footView.delegate = self;
}

#pragma mark - 创建列表headerView
-(void)createTableHeaderView:(NSDictionary *)dict{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
    _tableView.tableHeaderView = view;
    

    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 80, 60)];
    [iamgeView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"新闻"]];
    [view addSubview:iamgeView];
    
    UILabel *titleLabel = [LHController createLabelWithFrame:CGRectMake(100, 20, WIDTH-100, 20) Font:[LHController setFont]-2 Bold:NO TextColor:nil Text:dict[@"fname"]];
    [view addSubview:titleLabel];
    
    NSAttributedString *att1 = [self attString:[NSString stringWithFormat:@"版主：%@",dict[@"moderator"]] Font:[LHController setFont]-5 type:0];
    //计算高度
    CGSize size = [att1 boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    UILabel *webmasterLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, size.width<(WIDTH-100-100)?size.width:WIDTH-200, 20)];
    webmasterLabel.attributedText = att1;
    [view addSubview:webmasterLabel];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(webmasterLabel.frame.origin.x+webmasterLabel.frame.size.width, 40, 100, 20) Target:self Action:@selector(applicationClick) Text:nil];
    [button setAttributedTitle:[self attString:@"【申请当版主】" Font:[LHController setFont]-5] forState:UIControlStateNormal];
    [view addSubview:button];
    
    UILabel *informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, WIDTH-100, 20)];
    informationLabel.attributedText = [self attString:[NSString stringWithFormat:@"论坛信息：总帖数：%@   今日帖子数：%@",dict[@"total"],dict[@"nowday"]] Font:[LHController setFont]-5 type:1];
    [view addSubview:informationLabel];
   
    UIView *fg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 90, WIDTH, 1)];
    fg1.backgroundColor = colorLineGray;
    [view addSubview:fg1];
    
   
    NSArray *array1 = @[@"全部",@"精华"];
    NSArray *array2 = @[@"最新回复",@"最新发布"];
    UISegmentedControl *sge1 = [[UISegmentedControl alloc] initWithItems:array1];
    sge1.frame = CGRectMake(10, fg1.frame.origin.y+5, WIDTH/2-12.5, 30);
    sge1.tintColor = colorLightBlue;
    sge1.segmentedControlStyle = UISegmentedControlStyleBordered;
    sge1.selectedSegmentIndex = 0;
    [sge1 addTarget:self action:@selector(segmentActionOne:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sge1];
    
    UISegmentedControl *sge2 = [[UISegmentedControl alloc] initWithItems:array2];
    sge2.frame = CGRectMake(WIDTH/2+2.5, fg1.frame.origin.y+5, WIDTH/2-12.5, 30);
    sge2.tintColor = colorLightBlue;
    sge2.segmentedControlStyle = UISegmentedControlStyleBordered;
    sge2.selectedSegmentIndex = 0;
    [sge2 addTarget:self action:@selector(segmentActionTwo:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sge2];
    
    UIView *fg2 = [[UIView alloc] initWithFrame:CGRectMake(0, sge1.frame.origin.y+sge1.frame.size.height+5, WIDTH, 1)];
    fg2.backgroundColor = colorLineGray;
    [view addSubview:fg2];
}

-(void)createTableHeaderViewLanMu:(NSDictionary *)dict{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    _tableView.tableHeaderView = view;
    
    UILabel *nameLabel = [LHController createLabelWithFrame:CGRectMake(10, 10, 200, 20) Font:[LHController setFont] Bold:NO TextColor:nil Text:dict[@"cname"]];
    [view addSubview:nameLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, WIDTH-20, 20)];
    NSString *str = [NSString stringWithFormat:@"论坛信息：总贴数：%@  今日帖子数：%@",dict[@"total"],dict[@"nowday"]];
    label.attributedText = [self attString:str Font:[LHController setFont]-6 type:1];
    [view addSubview:label];
    
    UIView *fg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, 1)];
    fg1.backgroundColor = colorLineGray;
    [view addSubview:fg1];
    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 61, WIDTH, 36)];
//    bgView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
//    [view addSubview:bgView];
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 36)];
    //    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    NSArray *array1 = @[@"全部",@"精华"];
    NSArray *array2 = @[@"最新回复",@"最新发布"];
    UISegmentedControl *sge1 = [[UISegmentedControl alloc] initWithItems:array1];
    sge1.frame = CGRectMake(10, fg1.frame.origin.y+5, WIDTH/2-12.5, 30);
    sge1.tintColor = colorLightBlue;
    sge1.segmentedControlStyle = UISegmentedControlStyleBordered;
    sge1.selectedSegmentIndex = 0;
    [sge1 addTarget:self action:@selector(segmentActionOne:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sge1];
    
    UISegmentedControl *sge2 = [[UISegmentedControl alloc] initWithItems:array2];
    sge2.frame = CGRectMake(WIDTH/2+2.5, fg1.frame.origin.y+5, WIDTH/2-12.5, 30);
    sge2.tintColor = colorLightBlue;
    sge2.segmentedControlStyle = UISegmentedControlStyleBordered;
    sge2.selectedSegmentIndex = 0;
    [sge2 addTarget:self action:@selector(segmentActionTwo:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sge2];

    
    UIView *fg2 = [[UIView alloc] initWithFrame:CGRectMake(0, sge1.frame.origin.y+sge1  .frame.size.height+5, WIDTH, 1)];
    fg2.backgroundColor = colorLineGray;
    [view addSubview:fg2];
}


#pragma mark - 点击申请版主按钮响应方法
-(void)applicationClick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        ApplyModeratorsViewController *apply = [[ApplyModeratorsViewController alloc] init];
        apply.dict = self.dictionary;
        [self.navigationController pushViewController:apply animated:YES];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypePopView;
        [self.navigationController pushViewController:my animated:YES];
    }
}

#pragma mark - 属性化字符串
-(NSAttributedString *)attString:(NSString *)str Font:(CGFloat)size type:(NSInteger)type{
    if (!str) {
        return nil ;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
    if (type == 0) {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(0, att.length)];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    }else if (type == 1){
         [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1] range:NSMakeRange(0, att.length)];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
        for (int i = 0; i < str.length; i ++) {
            unichar C = [str characterAtIndex:i];
            if (isdigit(C)) {
                [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
            }
        }
    }
    
    return att;
}

-(NSAttributedString *)attString:(NSString *)str Font:(CGFloat)size{
    if (!str) {
        return nil ;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
 
       // [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:6/255.0 green:143/255.0 blue:206/255.0 alpha:1] range:NSMakeRange(1, 5)];
    
    return att;
}

#pragma mark - order/topic
-(void)segmentActionOne:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
        case 0:
        {
            topicType = 0;
            break;
        }
            
        case 1:
        {
            topicType = 1;
            break;
        }
    }
    
    _count = 1;
    header = YES;
    [self loadDataWithP:_count andS:10];
}

-(void)segmentActionTwo:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
        case 0:
        {
            orderType = 0;
            break;
        }
            
        case 1:
        {
            orderType = 1;
            break;
        }
        default:
            break;
    }
    
    _count = 1;
    header = YES;
    [self loadDataWithP:_count andS:10];
}

-(void)createFootView{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-64-49, WIDTH, HEIGHT)];
    foot.backgroundColor = [UIColor colorWithRed:6/255.0 green:143/255.0 blue:206/255.0 alpha:1];
    [self.view addSubview:foot];
    
    UIButton *btn = [LHController createButtnFram:CGRectMake(10, 10, WIDTH-30, 29) Target:self Action:@selector(footBtnCLick) Text:@"发表新帖"];
    btn.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]-3];
    btn.backgroundColor = [UIColor whiteColor];
    [foot addSubview:btn];
}

-(void)footBtnCLick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]){
        WritePostViewController *write = [[WritePostViewController alloc] init];
        if (self.forumType == forumClassifyBrand) {
            write.sid = self.sid;
        }else{
            write.cid = self.sid;
        }
        [self.navigationController pushViewController:write animated:YES];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypePopView;
        [self.navigationController pushViewController:my animated:YES];
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ForumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 69, WIDTH-10, 1)];
        view.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [cell.contentView addSubview:view];
    }
    
    cell.dictionary = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostViewController *detail = [[PostViewController alloc] init];
    detail.tid = _dataArray[indexPath.row][@"tid"];
    detail.titleText = _dataArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == headerView) {
        header = YES;
        _count = 1;
        footView.noData = NO;
    }else{
        if (_count < 1) {
            _count = 1;
        }
        _count ++;
    }
    [self loadDataWithP:_count andS:10];
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
