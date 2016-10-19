
//
//  NewsTestTableView.m
//  chezhiwang
//
//  Created by bangong on 16/5/31.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestTableView.h"
#import "ComplainChartView.h"
#import "ChartChooseListViewController.h"
#import "NewsTestTableViewCell.h"
#import "NewsTestTableViewModel.h"
#import "NewsDetailViewController.h"

@interface NewsTestTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    ComplainChartView *_chart;//头部选择数据
    NSInteger _count;
}
@property (nonatomic,weak) UIViewController *parentViewController;
@end

@implementation NewsTestTableView

- (instancetype)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parent{
    if (self = [super initWithFrame:frame]) {
         _count = 1;
        _parentViewController = parent;
        _dataArray = [[NSMutableArray alloc] init];
        __weak __typeof(self)wealself = self;
        //创建头部选择按钮
        _chart = [[ComplainChartView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 80) titles:@[@"品牌",@"车系",@"车型",@"车型属性",@"品牌属性",@"系别"] block:^(NSInteger index, BOOL initialSetUp) {

            if (!initialSetUp) {
                _count = 1;

                if (index == 0) {
                    [_chart setTitle:@"车系" tid:@"" index:1];
                }
                [wealself loadData];
                return ;
            }
            
            ChartChooseType chooseType;
            if (index == 0) {
                chooseType = ChartChooseTypeBrand;
            }else if (index == 1){
                 chooseType = ChartChooseTypeSeries;
            }else if (index == 2){
                 chooseType = ChartChooseTypeModel;
            }else if (index == 3){
                 chooseType = ChartChooseTypeAttributeModel;
            }else if (index == 4){
                 chooseType = ChartChooseTypeAttributeBrand;
            }else if (index == 5){
                 chooseType = ChartChooseTypeAttributeSeries;
            }
            DirectionStyle style = DirectionRight;
            if ((index+1)%3 == 0) {
                style = DirectionLeft;
            }
    
            ChartChooseListViewController *choose = [[ChartChooseListViewController alloc] initWithType:chooseType direction:style];

            choose.brandId = [_chart gettidWithIndex:0];
           
            //在choose页面选中数据后回调
            choose.chooseEnd = ^(NSString *title , NSString *tid){
                [_chart setTitle:title tid:tid index:index];
                _count = 1;
    

                if (chooseType == ChartChooseTypeBrand) {
                    [_chart setTitle:@"车系" tid:@"" index:1];
                }else if (chooseType == ChartChooseTypeSeries){

                }else if (chooseType == ChartChooseTypeAttributeModel){

                }else if (chooseType == ChartChooseTypeAttributeBrand){

                }else if (chooseType == ChartChooseTypeAttributeSeries){

                }
                 [wealself loadData];
            };
            [wealself.parentViewController presentViewController:choose animated:NO completion:nil];
        }];
        [_chart hideBarWithIndex:2];//隐藏第三个按钮
        [self addSubview:_chart];
    
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_chart.frame)+10, CGRectGetWidth(frame), CGRectGetHeight(frame)-CGRectGetHeight(_chart.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 200;
        [self addSubview:_tableView];

     
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chart.bottom);
            make.left.and.right.equalTo(0);
            make.bottom.equalTo(0);
        }];

        [self loadData];
    }
    
    return self;
}

- (void)loadData{
    NSString *bid = [_chart gettidWithIndex:0];
    NSString *sid = [_chart gettidWithIndex:1];
    NSString *mattr = [_chart gettidWithIndex:3];
    NSString *battr = [_chart gettidWithIndex:4];
    NSString *dep = [_chart gettidWithIndex:5];

    NSString *url = [NSString stringWithFormat:[URLFile urlString_testDrive],bid,sid,mattr,battr,dep,_count];
 
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *dict in responseObject[@"rel"]) {
            NewsTestTableViewModel *model = [[NewsTestTableViewModel alloc] initWithDictionary:dict];
            [_dataArray addObject:model];
        }

        [_tableView reloadData];
    } failure:^(NSError *error) {

    }];
}
/**
 *  <#Description#>
 *
 *  @param toTop <#toTop description#>
 */
- (void)setScrollToTop:(BOOL)toTop{
    _tableView.scrollsToTop = toTop;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NewsTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (!cell) {
        cell = [[NewsTestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentController = self.parentViewController;
        
    }
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTestTableViewModel *model = _dataArray[indexPath.row];
    NewsDetailViewController *details = [[NewsDetailViewController alloc] init];
    details.ID = model.ID;
    details.hidesBottomBarWhenPushed = YES;
    [self.parentViewController.navigationController pushViewController:details animated:YES];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ImageShowViewController *show = [[ImageShowViewController alloc] init];
//    show.hidesBottomBarWhenPushed = YES;
//    [self.parentViewController.navigationController pushViewController:show animated:YES];
//}


@end
