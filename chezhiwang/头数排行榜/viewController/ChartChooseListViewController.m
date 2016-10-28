//
//  ChartChooseListViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartChooseListViewController.h"
#import "ChartChooseModel.h"

@interface ChartChooseListViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UIDatePicker *beginDatePicker;
    UIDatePicker *endDatePicker;
    
    UILabel *beginDateLabel;
    UILabel *endDateLabel;
}

@end

@implementation ChartChooseListViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

- (instancetype)initWithType:(ChartChooseType)type direction:(DirectionStyle)direction{
    if (self = [super init]) {
        _direction = direction;
        _type = type;
        sectionArray = @"section";

        if (type == ChartChooseTypeDate) {
            [self createDatePicker];
        }else{
            [self createTableView];
        }

        if (type == ChartChooseTypeBrand || type == ChartChooseTypeSeries){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadDataWithTestView];
            });

        }else{
            [self loadDataWithChartView];
        }

    }
    return self;
}

- (void)loadDataWithChartView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:[URLFile urlString_rankingAct] success:^(id responseObject) {

        if (self.type == ChartChooseTypeAttributeBrand) {
            _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_brandAttr"] type:ChartChooseTypeAttributeBrand];
        }else if (self.type == ChartChooseTypeAttributeModel){
             _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_modelAttr"] type:ChartChooseTypeAttributeModel];
        }else if (self.type == ChartChooseTypeAttributeSeries){
             _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_dep"] type:ChartChooseTypeAttributeSeries];
        }else if (self.type == ChartChooseTypeQuality){
             _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_zlwt"] type:ChartChooseTypeQuality];
        }
        
        [_tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadDataWithTestView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if (_type == ChartChooseTypeBrand) {
        [HttpRequest GET:[URLFile urlStringForLetter] success:^(id responseObject) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject) {
                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                for (NSDictionary *subDict in dict[@"brand"]) {
                    ChartChooseModel * model = [[ChartChooseModel alloc] init];
                    model.tid = subDict[@"id"];
                    model.title = subDict[@"name"];
                    [subArray addObject:model];
                }
                NSDictionary *saveDict = @{@"name":dict[@"letter"],sectionArray:subArray};
                [mArray addObject:saveDict];
            }
            _dataArray = [mArray copy];

            [_tableView reloadData];

        } failure:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }else if (_type == ChartChooseTypeSeries){
        NSString *url = [NSString stringWithFormat:[URLFile urlStringForSeries],self.brandId];

        [HttpRequest GET:url success:^(id responseObject) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if ([responseObject count] == 0) {
                return ;
            }
            NSMutableArray *mArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in responseObject[0][@"series"]) {

                    ChartChooseModel * model = [[ChartChooseModel alloc] init];
                    model.tid = dict[@"id"];
                    model.title = dict[@"name"];
                    [mArray addObject:model];
            }
           
             _dataArray = @[
                            @{@"name":responseObject[0][@"brand"],sectionArray:mArray}
                            ];
           
            [_tableView reloadData];

        } failure:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)]];
}

#pragma mark - 滑动手势
-(void)panGesture:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.view];
    if (self.direction == DirectionLeft) {
        if (point.x+_tableView.frame.origin.x<= 0) {
            _tableView.center = CGPointMake(point.x+_tableView.center.x,_tableView.center.y);
            [pan setTranslation:CGPointZero inView:self.view];
        }
        
        if (pan.state == UIGestureRecognizerStateEnded) {
            CGRect rect = _tableView.frame;
            if (_tableView.frame.origin.x < -30) {
                rect.origin.x = -rect.size.width;
                __weak __typeof(self)weakself = self;
                [UIView animateWithDuration:0.2 animations:^{
                    _tableView.frame = rect;
                } completion:^(BOOL finished) {
                    __strong __typeof(weakself)strongself = weakself;
                    [strongself dismissViewControllerAnimated:NO completion:nil];
                }];
            }else{
                rect.origin.x = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    _tableView.frame = rect;
                }];
            }
        }

    }else{
        if (point.x+_tableView.frame.origin.x >= WIDTH/2) {
            _tableView.center = CGPointMake(point.x+_tableView.center.x,_tableView.center.y);
            [pan setTranslation:CGPointZero inView:self.view];
        }
        
        if (pan.state == UIGestureRecognizerStateEnded) {
            CGRect rect = _tableView.frame;
            if (_tableView.frame.origin.x > WIDTH/2+30) {
                rect.origin.x = WIDTH;
                __weak __typeof(self)weakself = self;
                [UIView animateWithDuration:0.2 animations:^{
                    _tableView.frame = rect;
                } completion:^(BOOL finished) {
                    __strong __typeof(weakself)strongself = weakself;
                    [strongself dismissViewControllerAnimated:NO completion:nil];
                }];
            }else{
                rect.origin.x = WIDTH/2;
                [UIView animateWithDuration:0.2 animations:^{
                    _tableView.frame = rect;
                }];
            }
        }
    }
}

-(void)createDatePicker{
    UIView *view = [[UIView alloc ] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 260)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(0, 0, WIDTH, 40);
    [finishButton setTitle:@"完  成" forState:UIControlStateNormal];
    [finishButton setTitleColor:colorLightBlue forState:UIControlStateNormal];
    finishButton.backgroundColor = [UIColor whiteColor];
    [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:finishButton];

    beginDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, WIDTH/2, 40)];
    beginDateLabel.font = [UIFont systemFontOfSize:15];
    beginDateLabel.textAlignment = NSTextAlignmentCenter;
    beginDateLabel.text = @"开始日期";
    endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 40, WIDTH/2, 40)];
    endDateLabel.font = [UIFont systemFontOfSize:15];
    endDateLabel.textAlignment = NSTextAlignmentCenter;
    endDateLabel.text  = @"结束日期";
    
    [view addSubview:beginDateLabel];
    [view addSubview:endDateLabel];
    
    beginDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)-180, WIDTH, 180)];
    beginDatePicker.backgroundColor = [UIColor whiteColor];
    beginDatePicker.transform = CGAffineTransformMakeScale(0.5, 1);
    //最小时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    beginDatePicker.minimumDate = [formatter dateFromString:@"1919-10-10"];
    //最大时间
    beginDatePicker.maximumDate = [NSDate date];
    //设置时间模式为中文显示
    beginDatePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [beginDatePicker setLocale:locale];
   
    //添加事件
    [beginDatePicker addTarget:self action:@selector(beginDateClick) forControlEvents:UIControlEventValueChanged];
    CGRect rect = beginDatePicker.frame;
    rect.origin.x = 0;
    beginDatePicker.frame = rect;
    [view addSubview:beginDatePicker];
    
    
    endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view.frame)-180, WIDTH, 180)];
    endDatePicker.backgroundColor = [UIColor whiteColor];
    endDatePicker.transform = CGAffineTransformMakeScale(0.5, 1);
   
    //最小时间

    [formatter setDateFormat:@"yyyy-MM-dd"];
    endDatePicker.minimumDate = [formatter dateFromString:@"1980-10-10"];
    //最大时间
    endDatePicker.maximumDate = [NSDate date];
    //设置时间模式为中文显示
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker setLocale:locale];
    
    //添加事件
    [endDatePicker addTarget:self action:@selector(endDateClick) forControlEvents:UIControlEventValueChanged];
    rect = endDatePicker.frame;
    rect.origin.x = WIDTH/2;
    endDatePicker.frame = rect;
    [view addSubview:endDatePicker];
    
    CGRect frame = view.frame;
    frame.origin.y = frame.origin.y-frame.size.height;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       [UIView animateWithDuration:0.2 animations:^{
           view.frame = frame;
       }];
    });
}


- (void)finishButtonClick{
    if ([beginDateLabel.text floatValue] < 100) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择开始时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:ac animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ac dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }else if ([endDateLabel.text floatValue] < 100){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择结束时间" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:ac animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ac dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    if ([endDateLabel.text integerValue] > 100 && [beginDateLabel.text integerValue] > 100) {
        if (self.chooseDeate) {
            self.chooseDeate(beginDateLabel.text,endDateLabel.text);
        }
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)beginDateClick{
    //转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    beginDateLabel.text = [formatter stringFromDate:beginDatePicker.date];
    endDatePicker.minimumDate = beginDatePicker.date;
}

-(void)endDateClick
{
    
        //转换
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //
        endDateLabel.text  = [formatter stringFromDate:endDatePicker.date];
        beginDatePicker.maximumDate = endDatePicker.date;
}


-(void)createTableView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    view.backgroundColor = colorLightBlue;
    [self.view addSubview:view];
 //   UITableViewStyle style = UITableViewStylePlain;
//    if (_type == ChartChooseTypeSeries || _type == ChartChooseTypeBrand) {
//        style = UITableViewStyleGrouped;
//    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 20, WIDTH/2, HEIGHT-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:_tableView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 30)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    _tableView.tableHeaderView = label;
    
    NSArray *titles = @[@"时间",@"车型属性",@"品牌属性",@"系别",@"质量问题",@"品牌",@"车系",@"车型"];
    label.text = titles[self.type];
    
    
    _tableView.tableFooterView = [UIView new];
    
    if (self.direction == DirectionLeft) {
        CGRect rect = _tableView.frame;
        rect.origin.x = -WIDTH/2;
        _tableView.frame = rect;
        rect.origin.x = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = rect;
            }];
        });

    }else{
        CGRect rect = _tableView.frame;
        rect.origin.x = WIDTH/2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = rect;
            }];
        });

    }
}

#pragma mark - sets

#pragma mark - touchs
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self.view];
    if (beginDatePicker) {
        if (CGRectContainsPoint(beginDatePicker.superview.frame, location)) {
            [super touchesEnded:touches withEvent:event];
             return;
        }
       
    }
    if (CGRectContainsPoint(_tableView.frame, location)) {
       [super touchesEnded:touches withEvent:event];
        return;
    }
     [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_type == ChartChooseTypeBrand || _type == ChartChooseTypeSeries) {
        return _dataArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_type == ChartChooseTypeBrand || _type == ChartChooseTypeSeries) {
        return [_dataArray[section][sectionArray] count];
    }
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor grayColor];
        if (self.direction == DirectionLeft) {
            cell.textLabel.textAlignment = NSTextAlignmentRight;
        }else{
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
    ChartChooseModel *model;
    if (_type == ChartChooseTypeBrand || _type == ChartChooseTypeSeries) {
        model = _dataArray[indexPath.section][sectionArray][indexPath.row];
    }else{
        model = _dataArray[indexPath.row];
    }


    cell.textLabel.text = model.title;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.chooseEnd) {
        ChartChooseModel *model;
        if (_type == ChartChooseTypeBrand || _type == ChartChooseTypeSeries) {
            model = _dataArray[indexPath.section][sectionArray][indexPath.row];
        }else{
            model = _dataArray[indexPath.row];
        }
    
        self.chooseEnd(model.title,model.tid);

    }
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    });
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_type == ChartChooseTypeBrand || _type == ChartChooseTypeSeries) {
        NSString *title =  _dataArray[section][@"name"];
        return title;
    }else{
       return @"";
    }


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
