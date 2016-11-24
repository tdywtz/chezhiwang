//
//  ForumClassifyListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/10/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumClassifyListViewController.h"
#import "HomepageForumCell.h"
#import "PostViewController.h"
#import "WritePostViewController.h"
#import "ApplyModeratorsViewController.h"
#import "LoginViewController.h"
#import "ForumHeaderView.h"

@interface ForumClassifyListHeaderView : UIView
{
    UIImageView *iconImageView;
    UILabel *titleLabel;
    UILabel *userNameLabel;
    UILabel *numberLabel;
    UIButton *applyButton;//申请当版主
    UIView *lineView;
}
@property (nonatomic,strong) NSDictionary *dictionary;//论坛信息
@property (nonatomic,assign) forumClassify style;
@property (nonatomic,weak) UIViewController *parentViewController;

@end

@implementation ForumClassifyListHeaderView

- (instancetype)initWithFrame:(CGRect)frame style:(forumClassify)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;

        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = colorBlack;

        numberLabel = [[UILabel alloc] init];
        numberLabel.font = [UIFont systemFontOfSize:15];
        numberLabel.textColor = colorLightGray;

        lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB_color(240, 240, 240, 1);

        [self addSubview:titleLabel];
        [self addSubview:numberLabel];
        [self addSubview:lineView];

        if (style == forumClassifyBrand) {
            iconImageView = [[UIImageView alloc] init];
            iconImageView.contentMode = UIViewContentModeScaleAspectFit;

            userNameLabel = [[UILabel alloc] init];
            userNameLabel.font = [UIFont systemFontOfSize:15];
            userNameLabel.textColor = colorDeepGray;
            userNameLabel.numberOfLines = 2;

            applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [applyButton setTitle:@"申请当版主" forState:UIControlStateNormal];
            [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            applyButton.backgroundColor = colorYellow;
            applyButton.titleLabel.font = [UIFont systemFontOfSize:15];
            applyButton.layer.cornerRadius = 3;
            applyButton.layer.masksToBounds = YES;
            [applyButton addTarget:self action:@selector(applyButtonClick) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:iconImageView];
            [self addSubview:userNameLabel];
            [self addSubview:applyButton];
        }
    }
    return self;
}

- (void)applyButtonClick{
    if ([CZWManager manager].isLogin) {
        ApplyModeratorsViewController *apply = [[ApplyModeratorsViewController alloc] init];
        apply.dict = _dictionary;
        [self.parentViewController.navigationController pushViewController:apply animated:YES];
    }else{

        [self.parentViewController presentViewController:[LoginViewController instance] animated:YES completion:nil];
    }
}

- (void)setDictionary:(NSDictionary *)dictionary{
    _dictionary = dictionary;
    
    if (_style == forumClassifyBrand) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"image"]] placeholderImage:[CZWManager defaultIconImage]];
        titleLabel.text = [NSString stringWithFormat:@"%@%@",dictionary[@"bname"],dictionary[@"fname"]];
        NSMutableAttributedString *userText = [[NSMutableAttributedString alloc] initWithString:@"版主：" attributes:@{NSForegroundColorAttributeName:colorLightGray}];
        [userText appendAttributedString:[[NSAttributedString alloc] initWithString:dictionary[@"sname"]?dictionary[@"sname"]:@""]];
        userNameLabel.attributedText = userText;

        NSMutableAttributedString *numText = [[NSMutableAttributedString alloc] initWithString:@"总贴数："];
        [numText appendAttributedString:[[NSAttributedString alloc] initWithString:dictionary[@"total"] attributes:@{NSForegroundColorAttributeName:colorOrangeRed}]];
        [numText appendAttributedString:[[NSAttributedString alloc] initWithString:@"    今日帖子数："]];
        [numText appendAttributedString:[[NSAttributedString alloc] initWithString:dictionary[@"nowday"] attributes:@{NSForegroundColorAttributeName:colorOrangeRed}]];
        numberLabel.attributedText = numText;


        iconImageView.lh_left = 10;
        iconImageView.lh_top = 20;
        iconImageView.lh_size = CGSizeMake(80, 60);

        [titleLabel sizeToFit];
        titleLabel.lh_width =  self.lh_width - iconImageView.lh_right-1;
        titleLabel.lh_left = iconImageView.lh_right+10;
        titleLabel.lh_top = 10;

        userNameLabel.lh_width = self.lh_width - iconImageView.lh_right-10;
        userNameLabel.lh_size = [userNameLabel sizeThatFits:CGSizeMake(self.lh_width - iconImageView.lh_right-10, 100)];
        userNameLabel.lh_left = titleLabel.lh_left;
        userNameLabel.lh_top = titleLabel.lh_bottom+10;

        numberLabel.lh_width = self.lh_width - iconImageView.lh_right-10;
         numberLabel.lh_size = [numberLabel sizeThatFits:CGSizeMake(self.lh_width - iconImageView.lh_right-10, 100)];
        numberLabel.lh_left = titleLabel.lh_left;
        numberLabel.lh_top = userNameLabel.lh_bottom+10;

        applyButton.lh_left = titleLabel.lh_left;
        applyButton.lh_top = numberLabel.lh_bottom+10;
        applyButton.lh_size = CGSizeMake(90, 30);

        lineView.lh_size = CGSizeMake(self.lh_width, 1);
        lineView.lh_left = 0;
        lineView.lh_top = applyButton.lh_bottom + 10;

    }else{

        titleLabel.text = dictionary[@"cname"];

        NSMutableAttributedString *numText = [[NSMutableAttributedString alloc] initWithString:@"总贴数："];
        [numText appendAttributedString:[[NSAttributedString alloc] initWithString:dictionary[@"total"] attributes:@{NSForegroundColorAttributeName:colorOrangeRed}]];
        [numText appendAttributedString:[[NSAttributedString alloc] initWithString:@"    今日帖子数："]];
        [numText appendAttributedString:[[NSAttributedString alloc] initWithString:dictionary[@"nowday"] attributes:@{NSForegroundColorAttributeName:colorOrangeRed}]];

        numberLabel.attributedText = numText;

        titleLabel.lh_width = self.lh_width - 20;
        [titleLabel sizeToFit];
        titleLabel.lh_left = 10;
        titleLabel.lh_top = 10;

        numberLabel.lh_width = self.lh_width - 20;
        [numberLabel sizeToFit];
        numberLabel.lh_left = titleLabel.lh_left;
        numberLabel.lh_top = titleLabel.lh_bottom+10;

        lineView.lh_size = CGSizeMake(self.lh_width, 1);
        lineView.lh_left = 0;
        lineView.lh_top = numberLabel.lh_bottom + 10;
    }

    self.lh_height = lineView.lh_bottom;
}

@end

#pragma mark - /////
@interface ForumClassifyListViewController ()<UITableViewDataSource,UITableViewDelegate,ForumHeaderViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _orderType;
    NSInteger _topicType;
    
    NSString *_urlString;
    NSInteger _count;

    ForumClassifyListHeaderView *_headerView;
    ForumHeaderView *_chooseSegmented;
    UIView *tableHeaderView;
}

@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation ForumClassifyListViewController

-(void)loadData{
    NSString *url = [NSString stringWithFormat:_urlString,self.sid,_orderType,_topicType,_count];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            
            [_dataArray removeAllObjects];
        }

        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dict in responseObject[@"rel"]) {
            HomepageForumModel *model = [HomepageForumModel mj_objectWithKeyValues:dict];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
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

        self.dictionary = responseObject;

            [_headerView setDictionary:responseObject];
      _chooseSegmented.lh_left = 0;
          _chooseSegmented.lh_top = _headerView.lh_bottom;
       tableHeaderView.lh_height = _chooseSegmented.lh_bottom;
         _tableView.tableHeaderView = tableHeaderView;

  } failure:^(NSError *error) {
      
  }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];

    [self createRightItem];
    [self createTableView];
    [self loadDataHeader];
    _orderType = 0;
    _topicType = 0;
    _count = 1;
    [self setUrl];
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"forum_write"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    if ([CZWManager manager].isLogin){
        WritePostViewController *write = [[WritePostViewController alloc] init];
        BasicNavigationController *nvc = [[BasicNavigationController alloc] initWithRootViewController:write];
     
        if (self.forumType == forumClassifyBrand) {
            write.sid = self.sid;
        }else{
            write.cid = self.sid;
        }
        write.classify = self.forumType;
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
    
        [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
    }
}

#pragma mark - 创建列表
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 80;
    [self.view addSubview:_tableView];


    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    [_tableView.mj_header beginRefreshing];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    _tableView.mj_footer.automaticallyHidden = YES;


    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];

    _headerView = [[ForumClassifyListHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100) style:self.forumType];
    _headerView.parentViewController = self;

    _chooseSegmented = [[ForumHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    _chooseSegmented.showChooseView = _tableView;
    _chooseSegmented.delegate = self;

    [tableHeaderView addSubview:_headerView];
    [tableHeaderView addSubview:_chooseSegmented];
}


#pragma mark - ForumHeaderViewDelegate
- (void)didSelectOrderType:(NSInteger)orderType topicType:(NSInteger)topicType{
    _orderType = orderType;
    _topicType = topicType;
    _count = 1;
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageForumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomepageForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.forumModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageForumModel *model = _dataArray[indexPath.row];
    PostViewController *detail = [[PostViewController alloc] init];
    detail.tid = model.tid;
    detail.titleText = model.title;
    [self.navigationController pushViewController:detail animated:YES];
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
