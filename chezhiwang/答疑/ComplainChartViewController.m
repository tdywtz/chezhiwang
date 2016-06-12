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

@interface ComplainChartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_firstArray;
    NSArray *_secondArray;
    NSObject * _object;
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
    [self createTableView];
    _firstArray = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
   // [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"auto_toolbarRightTriangle@2x"]];
    [SVProgressHUD showWithStatus:@"冲啊"];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       [SVProgressHUD dismiss];
   });
    
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

    _headerView = [[ComplainChartView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44) titles:@[@"时间",@"车型属性",@"品牌属性",@"系别",@"质量问题"] block:^(NSInteger index) {
       
        DirectionStyle direction = DirectionRight;
        if (index == 2) {
            direction = DirectionLeft;
        }
        ChartChooseListViewController *chart = [[ChartChooseListViewController alloc] initWithType:index direction:direction];
        chart.chooseEnd = ^(NSString *title){
            [_headerView setTitle:title index:index];
        };
        [self presentViewController:chart animated:YES completion:nil];
    }];
    _tableView.tableHeaderView = _headerView;
    
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSObject *object = _firstArray[indexPath.row];
        if ([object isMemberOfClass:[NSObject class]]) {
            UITableViewCell *tabelcell = [tableView dequeueReusableCellWithIdentifier:@"inset"];
            if (!tabelcell) {
                tabelcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inset"];
                tabelcell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
          //  tabelcell.backgroundColor = [UIColor lightGrayColor];
            tabelcell.textLabel.numberOfLines = 0;
            tabelcell.textLabel.text = @"若是没有你的微笑\n天空又怎会如此绚丽\n若是没有你的陪伴\n生活都已失去意义";
            return tabelcell;
        }else{
            ComplainChartFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCFirstCellell"];
            if (!cell) {
                cell = [[ComplainChartFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCFirstCellell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    }
    
    ComplainChartSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell"];
    if (!cell) {
        cell = [[ComplainChartSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondCell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0 ){
//        if ([_firstArray[indexPath.row] isMemberOfClass:[NSObject class]]) {
//            return (arc4random()%10)*10+40;
//        }
//    }
//    return 44;
//}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
       return  44;
    }
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *viewFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        viewFirst.backgroundColor = [UIColor lightGrayColor];
        NSArray *array = @[@"排名",@"品牌",@"车系",@"车型属性",@"数量"];
        for (int i = 0; i < array.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/5*i, 0, WIDTH/5, 44)];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = array[i];
            [viewFirst addSubview:label];
        }
        return viewFirst;
    }
   
    if (_secondHeaderView == nil) {
        _secondHeaderView = [[ComplainChartSecondHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 88)];
    }
    return _secondHeaderView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, WIDTH, 30);
        return btn;
    }
    return nil;
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
