//
//  ComplainChartViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartViewController.h"
#import "ComplainChartView.h"
#import "ComplainChartFirstCell.h"
#import "ComplainChartSecondCell.h"
#import "ComplainChartSecondHeaderView.h"
#import "ChartChooseListViewController.h"
#import "BezierPathView.h"
#import "ComplainChartFirstShowCell.h"
#import "ChartDateChooseViewController.h"

@interface ComplainChartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_firstArray;
    NSArray        *_secondArray;
    //回复率数据字典，将数组存放到字典中 key： 0->厂家满意  1->车主满意  2->新车调查排行
    NSMutableDictionary *_secondArrayDictionary;

    NSInteger _count;

    NSObject * _object;
    ComplainChartFirstShowCell *showCell;

    UIButton *moreButton;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ComplainChartView *headerView;
@property (nonatomic,strong) ComplainChartSecondHeaderView *secondHeaderView;

@end

@implementation ComplainChartViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"投诉排行榜";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _object = [[NSObject alloc ]init];

    _firstArray = [[NSMutableArray alloc] init];
    _secondArrayDictionary = [[NSMutableDictionary alloc] init];
    _secondArray = [[NSMutableArray alloc] initWithArray:_firstArray];
    _count = 0;

    showCell = [[ComplainChartFirstShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];

    [self createTableView];
    [self loadDataRankingBotm];
    [self createBezier];
}

- (void)createBezier{
   BOOL open = [[NSUserDefaults standardUserDefaults] boolForKey:@"ComplainChartViewControllerthePageOpend"];
    if (open) {
        return;
    }

    BezierPathView *view = [[BezierPathView alloc] initWithFrame:self.view.frame bezierRect:CGRectMake(20, 69, 100, 25) radius:5];
    [self.view addSubview:view];
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    __weak __typeof(self)weakSelf = self;
    _headerView = [[ComplainChartView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44) titles:@[@"时间",@"车型属性",@"品牌属性",@"系别",@"质量问题"] block:^(NSInteger index, BOOL initialSetUp) {
        if (index == 0) {
            //已经选择过时间，标记下一次进入页面不在弹出提示
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ComplainChartViewControllerthePageOpend"];
            if (initialSetUp) {
                //选择时间
                ChartDateChooseViewController *choose = [[ChartDateChooseViewController alloc] initWithChooseDeate:^(NSString *beginDate, NSString *endDate) {
                    //返回时间

                    NSString *date = [NSString stringWithFormat:@"%@\n%@",beginDate,endDate];
                    [_headerView setTitle:date tid:nil index:0];
                    _headerView.beginDate = beginDate;
                    _headerView.endDate = endDate;
                    _count = 1;//重置页码
                    [weakSelf loadDataRankingList];
                }];
                [weakSelf.navigationController pushViewController:choose animated:YES];
            }else{
                _count = 1;//重置页码
                [weakSelf loadDataRankingList];
            }
            return ;
        }
        if (!initialSetUp) {
            _count = 1;//重置页码
            [weakSelf loadDataRankingList];
            return ;
        }

        ChartChooseListViewController *chart = [[ChartChooseListViewController alloc] initWithType:index direction:DirectionRight];
        //返回名和id
        chart.chooseEnd = ^(NSString *title , NSString *tid){
            [_headerView setTitle:title tid:tid index:index];
            _count = 1;//重置页码
            [weakSelf loadDataRankingList];
        };
        [weakSelf presentViewController:chart animated:YES completion:nil];
    }];
    _headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _headerView;
}

//回复率列表
- (void)loadDataRankingBotm{
      [HttpRequest GET:[URLFile urlString_rankingBotm] success:^(id responseObject) {

          //厂家回复率
          NSMutableArray *arrayOne = [[NSMutableArray alloc] init];
          for (NSDictionary *dict in responseObject[@"CJHFL"]) {
              ComplainChartSecondModel *model = [[ComplainChartSecondModel alloc] init];
              model.number = dict[@"num"];
              model.brandName = dict[@"brandName"];
              model.percentage = dict[@"HFL"];
              [arrayOne addObject:model];
          }
          //车主满意度
          NSMutableArray *arrayTwo = [[NSMutableArray alloc] init];
          for (NSDictionary *dict in responseObject[@"PPMYD"]) {
              ComplainChartSecondModel *model = [[ComplainChartSecondModel alloc] init];
              model.number = dict[@"num"];
              model.brandName = dict[@"brandName"];
              model.percentage = dict[@"MYD"];
              [arrayTwo addObject:model];
          }
          //新车调查排行
          NSMutableArray *arrayThree = [[NSMutableArray alloc] init];
          for (NSDictionary *dict in responseObject[@"CZDCPH"]) {
              ComplainChartSecondModel *model = [[ComplainChartSecondModel alloc] init];
              model.number = dict[@"num"];
              model.brandName = dict[@"brandName"];
              model.percentage = dict[@"PF"];
              [arrayThree addObject:model];
          }
          [_secondArrayDictionary setObject:arrayOne forKey:@"0"];
          [_secondArrayDictionary setObject:arrayTwo forKey:@"1"];
          [_secondArrayDictionary setObject:arrayThree forKey:@"2"];
          
           _secondArray = arrayOne;
          [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

      } failure:^(NSError *error) {
          
      }];
}

//加载投诉排行数据
- (void)loadDataRankingList{
    if (_count == 1) {
        moreButton.hidden = NO;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:[URLFile urlString_rankingList],_headerView.beginDate,_headerView.endDate,[_headerView gettidWithIndex:1],[_headerView gettidWithIndex:2],[_headerView gettidWithIndex:3],[_headerView gettidWithIndex:4],_count];
    [HttpRequest GET:url success:^(id responseObject) {
       // NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];


        [_firstArray removeAllObjects];

        NSInteger count = 0;
        for (NSDictionary *dict in responseObject[@"rel"]) {
            count ++;
            [_firstArray addObject:dict];
            if (_count == 1 && count == 1) {
                _object =  [[NSObject alloc] init];
                [_firstArray addObject:_object];
            }
        }
      
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _firstArray.count;
    }
    return _secondArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSObject *object = _firstArray[indexPath.row];
        if ([object isMemberOfClass:[NSObject class]]) {
            ComplainChartFirstShowCell *tabelcell = [tableView dequeueReusableCellWithIdentifier:@"inset"];
            if (!tabelcell) {
                tabelcell = [[ComplainChartFirstShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inset"];
                tabelcell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
           
            tabelcell.errorInfo = _firstArray[indexPath.row-1][@"errorInfo"];
            return tabelcell;
        }else{
            ComplainChartFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCFirstCellell"];
            if (!cell) {
                cell = [[ComplainChartFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCFirstCellell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.draw = YES;

            NSInteger index = [_firstArray indexOfObject:_object];

            if (indexPath.row == index-1) {
                cell.draw = NO;
            }
            [cell setDictionary:_firstArray[indexPath.row]];

            return cell;
        }
    }
    
    ComplainChartSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell"];
    if (!cell) {
        cell = [[ComplainChartSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondCell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setModel:_secondArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        NSInteger index = [_firstArray indexOfObject:_object];
        if (index == NSNotFound) {
            [_firstArray insertObject:_object atIndex:indexPath.row+1];
        }else{
            if (index == indexPath.row) {
                return;
            }else if (index == indexPath.row+1){
                [_firstArray removeObject:_object];
            }else{
                NSObject *obj = [[NSObject alloc] init];
                [_firstArray insertObject:obj atIndex:indexPath.row+1];
                [_firstArray removeObject:_object];
                _object = obj;
            }
        }

        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ){
        if ([_firstArray[indexPath.row] isMemberOfClass:[NSObject class]]) {
            showCell.errorInfo = _firstArray[indexPath.row-1][@"errorInfo"];
            return [showCell getCellHeight];
        }
    }
    return 44;
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
       return  35;
    }
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *viewFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 35)];
        viewFirst.backgroundColor = RGB_color(237, 238, 239, 1);
        NSArray *array = @[@"排名",@"品牌",@"车系",@"车型属性",@"数量"];
        for (int i = 0; i < array.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/5*i, 0, WIDTH/5, viewFirst.frame.size.height)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = colorLightGray;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = array[i];
            [viewFirst addSubview:label];

            CGRect rect = label.frame;
            if (i == 0) {
                rect.origin.x = 15;
                label.textAlignment = NSTextAlignmentLeft;
                label.frame = rect;
            }else if (i == 4){
                rect.size.width = WIDTH/5-15;
                label.textAlignment = NSTextAlignmentRight;
                label.frame = rect;
            }
        }
        return viewFirst;
    }
   
    
    if (_secondHeaderView == nil) {
        __weak __typeof(self)weakSelf = self;
        _secondHeaderView = [[ComplainChartSecondHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        _secondHeaderView.click = ^(NSInteger index){
            NSString *str = [NSString stringWithFormat:@"%ld",index];
            _secondArray = _secondArrayDictionary[str];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
    return _secondHeaderView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (!moreButton) {
            moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            moreButton.backgroundColor = [UIColor whiteColor];
            [moreButton setTitle:@"点击加载更多内容" forState:UIControlStateNormal];
            [moreButton setTitleColor:colorLightGray forState:UIControlStateNormal];
            moreButton.frame = CGRectMake(0, 0, WIDTH, 50);
            moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreButton addTarget:self action:@selector(loadClick) forControlEvents:UIControlEventTouchUpInside];
        }

        return moreButton;
    }
    return nil;
}

- (void)loadClick{

    if (_count >= 5) {
        return;
    }
    _count ++;
    if (_count == 5) {
        moreButton.hidden = YES;
    }
    [self loadDataRankingList];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
//    view.backgroundColor = [UIColor orangeColor];
//    return view;
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
