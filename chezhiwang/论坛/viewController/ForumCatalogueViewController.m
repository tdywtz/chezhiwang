//
//  ForumCatalogueViewController.m
//  chezhiwang
//
//  Created by bangong on 16/11/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumCatalogueViewController.h"
#import <MJNIndexView.h>
#import "ForumCatalogueSliderView.h"
#import "ForumCatalogueSectionModel.h"
#import "ForumCatalogueHeaderView.h"
#import "ForumCatalogueCell.h"

@interface ForumCatalogueViewController ()<UITableViewDelegate,UITableViewDataSource,MJNIndexViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;

    ForumCatalogueSliderView *sliderView;
}
@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation ForumCatalogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    [self firstAttributesForMJNIndexView];

    [self loadData];

    sliderView = [[ForumCatalogueSliderView alloc] initWithFrame:self.view.frame];
    sliderView.lh_top = 64;
    sliderView.lh_height = HEIGHT-64;
    sliderView.lh_left = WIDTH+10;
    sliderView.hidden = YES;
    sliderView.layer.shadowColor = [UIColor blackColor].CGColor;
    sliderView.layer.shadowOffset = CGSizeMake(-5, 0);
    sliderView.layer.shadowOpacity = 0.5;
    sliderView.parentViewController = self;
    [self.view addSubview:sliderView];

    [sliderView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
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
            [UIView animateWithDuration:0.1 animations:^{
              sliderView.lh_left = 100;
            }];

        }else{
            [self hiddeSliderView];
        }
    }
}

- (void)showSliderView{
    sliderView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        sliderView.lh_left = 100;
    }];
}

- (void)hiddeSliderView{
    [UIView animateWithDuration:0.2 animations:^{
        sliderView.lh_left = WIDTH+10;
    } completion:^(BOOL finished) {
        sliderView.hidden = YES;
    }];
}

- (void)loadData{

    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpRequest GET:[URLFile urlStringForOtherSeries] policy:NSURLRequestReturnCacheDataElseLoad success:^(id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _dataArray = [ForumCatalogueSectionModel arrayWithArray:responseObject];
        [_tableView reloadData];
        weakSelf.indexView.dataSource = self;
        [weakSelf.view insertSubview:weakSelf.indexView atIndex:1];
    } failure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];


    ForumCatalogueHeaderView *headerView = [[ForumCatalogueHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    headerView.parentViewController = self;
    _tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ForumCatalogueSectionModel *sectionModel = _dataArray[section];
    return sectionModel.roeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumCatalogueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ForumCatalogueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    ForumCatalogueSectionModel *sectionModel = _dataArray[indexPath.section];
    ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:@"top"];
    return cell;
}

#pragma mark- tableview delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumCatalogueSectionModel *sectionModel = _dataArray[indexPath.section];
    ForumCatalogueModel *model = sectionModel.roeModels[indexPath.row];
    sliderView.dataArray = model.sections;
 
    [self showSliderView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
ForumCatalogueSectionModel *sectionModel = _dataArray[section];
    return sectionModel.title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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
