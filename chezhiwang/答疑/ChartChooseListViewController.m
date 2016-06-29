//
//  ChartChooseListViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartChooseListViewController.h"
#import <objc/runtime.h>

@interface ChartChooseModel : NSObject

@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *title;

+ (NSArray *)initWithArray:(NSArray *)array type:(ChartChooseType)type;
@end

@implementation ChartChooseModel

+ (NSArray *)initWithArray:(NSArray *)array type:(ChartChooseType)type{
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    
    NSString *titleKey;
    NSString *tidKey;
    if (type == ChartChooseTypeAttributeBrand) {
        titleKey = @"name";
        tidKey   = @"brandAttr";
    }else if (type == ChartChooseTypeAttributeModel){
        titleKey = @"name";
        tidKey   = @"modelAttr";
    }else if (type == ChartChooseTypeAttributeSeries){
        titleKey = @"name";
        tidKey   = @"dep";
    }else if (type == ChartChooseTypeQuality){
        titleKey = @"name";
        tidKey   = @"zlwt";
    }
    for (NSDictionary *dict in array) {
        ChartChooseModel * model = [[ChartChooseModel alloc] init];
        model.tid = dict[titleKey];
        model.title = dict[titleKey];
        [marr addObject:model];
    }
    
    return marr;
}

@end

@interface ChartChooseListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;

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
        if (type == ChartChooseTypeDate) {
            [self createDatePicker];
        }else{
            [self createTableView];
        }
        
        [self loadData];
    }
    return self;
}

- (void)loadData{
    [HttpRequest GET:[URLFile urlString_rankingAct] success:^(id responseObject) {
        if (self.type == ChartChooseTypeAttributeBrand) {
            _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_brandAttr"] type:ChartChooseTypeAttributeBrand];
        }else if (self.type == ChartChooseTypeAttributeModel){
             _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_modelAttr"] type:ChartChooseTypeAttributeBrand];
        }else if (self.type == ChartChooseTypeAttributeSeries){
             _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_dep"] type:ChartChooseTypeAttributeBrand];
        }else if (self.type == ChartChooseTypeQuality){
             _dataArray = [ChartChooseModel initWithArray:responseObject[@"R_zlwt"] type:ChartChooseTypeAttributeBrand];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
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
    UIView *view = [[UIView alloc ] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 220)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    beginDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2, 40)];
    beginDateLabel.font = [UIFont systemFontOfSize:15];
    beginDateLabel.textAlignment = NSTextAlignmentCenter;
    beginDateLabel.text = @"开始日期";
    endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, 40)];
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

-(void)beginDateClick{
    //转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    beginDateLabel.text = [formatter stringFromDate:beginDatePicker.date];
    endDatePicker.minimumDate = beginDatePicker.date;
    
    [self dateBlock];
}

-(void)endDateClick
{
    
        //转换
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //
        endDateLabel.text  = [formatter stringFromDate:endDatePicker.date];
        beginDatePicker.maximumDate = endDatePicker.date;
     [self dateBlock];
}

- (void)dateBlock{
    if ([endDateLabel.text integerValue] > 100 && [beginDateLabel.text integerValue] > 100) {
        if (self.chooseDeate) {
            self.chooseDeate(beginDateLabel.text,endDateLabel.text);
        }
    }
}

-(void)createTableView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    view.backgroundColor = colorLightBlue;
    [self.view addSubview:view];
    
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.frame = rect;
            }];
        });

    }else{
        CGRect rect = _tableView.frame;
        rect.origin.x = WIDTH/2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
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
    ChartChooseModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.chooseEnd) {
        ChartChooseModel *model = _dataArray[indexPath.row];
        self.chooseEnd(model.tid,model.title);
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    });
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
