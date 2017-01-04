//
//  ForumClassifyViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/28.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumClassifyViewController.h"
#import "ForumClassifyListViewController.h"
#import "MJNIndexView.h"
#import "WritePostViewController.h"
#import "ForumCatalogueSectionModel.h"

@interface ForumClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,MJNIndexViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    
    UIView *twoView;
    NSArray *twoArray;
    UITableView *twoTableView;
}
@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation ForumClassifyViewController

-(void)readData{

    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpRequest GET:[URLFile urlStringForLetter] policy:NSURLRequestReturnCacheDataElseLoad success:^(id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _dataArray = [ForumCatalogueSectionModel arrayWithArray:responseObject[@"rel"]];
        [_tableView reloadData];
        weakSelf.indexView.dataSource = self;
        [weakSelf.view insertSubview:weakSelf.indexView atIndex:1];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadTwoData:(NSString *)brandId{
    __weak __typeof(self)weakSlef = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForSeries],brandId];
    [HttpRequest GET:url success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakSlef.view animated:YES];
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
        twoArray = sections;
        [twoTableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSlef.view animated:YES];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"品牌论坛";

    [self createTableView];
    [self firstAttributesForMJNIndexView];
    [self readData];
}

- (void)firstAttributesForMJNIndexView
{
    self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];

    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = colorLightBlue;
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}


-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    twoView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH+10, 64, WIDTH-100, HEIGHT)];
    twoView.layer.shadowColor = [UIColor blackColor].CGColor;
    twoView.layer.shadowOffset = CGSizeMake(-4, -0.1);
    twoView.layer.shadowRadius = 4;
    twoView.layer.shadowOpacity = 0.8;
    [self.view addSubview:twoView];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [twoView addGestureRecognizer:tap];
    
    twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-100, HEIGHT-64) style:UITableViewStyleGrouped];
    twoTableView.delegate = self;
    twoTableView.dataSource = self;
    [twoView addSubview:twoTableView];
}

#pragma mark - 滑动手势
-(void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.view];
    if (point.x+pan.view.frame.origin.x > 100) {
        pan.view.center = CGPointMake(point.x+pan.view.center.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.frame.origin.x < 130) {
            [self showTwoView:YES];
        }else{
            [self showTwoView:NO];
        }
    }
}

-(void)showTwoView:(BOOL)b{
    if (b) {
        [UIView animateWithDuration:0.3 animations:^{
            twoView.frame = CGRectMake(100, 64, WIDTH-100, HEIGHT-64);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            twoView.frame = CGRectMake(WIDTH+10, 64, WIDTH-100, HEIGHT-64);
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == twoTableView) return twoArray.count;
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == twoTableView){
        ForumCatalogueSectionModel *sectionModel = twoArray[section];
        return sectionModel.roeModels.count;

    }else{
        ForumCatalogueSectionModel *sectionModel = _dataArray[section];
        return sectionModel.roeModels.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == twoTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twocell"];
        }
        ForumCatalogueSectionModel *sectionModel2 = twoArray[indexPath.section];
        ForumCatalogueModel *model = sectionModel2.roeModels[indexPath.row];
        cell.textLabel.text = model.title;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        ForumCatalogueSectionModel *sectionModel = _dataArray[indexPath.section];
        ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];
        cell.textLabel.text = model.title;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70;
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == twoTableView){
         ForumCatalogueSectionModel *sectionModel = twoArray[section];
        return sectionModel.title;
    }

    ForumCatalogueSectionModel *sectionModel = _dataArray[section];
    return sectionModel.title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   // if (tableView == twoTableView) return 0;
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == twoTableView) {
        //回调函数
        ForumCatalogueSectionModel *sectionModel = twoArray[indexPath.section];
        ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];
            if (self.block) {
                self.block(model.ID,model.title);
            }
            [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        ForumCatalogueSectionModel *sectionModel = _dataArray[indexPath.section];
        ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];
        [self loadTwoData:model.ID];
        [self showTwoView:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _tableView) [self showTwoView:NO];
}

//回调
-(void)returnSid:(returnSid)block{
    self.block = block;
}


#pragma mark - MJNIndexViewDataSource
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    NSMutableArray *letters = [NSMutableArray array];
    for (ForumCatalogueSectionModel *sectionModel in _dataArray) {
        if(sectionModel.title)  [letters addObject:sectionModel.title];
    }
    return letters;
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{

    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
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
