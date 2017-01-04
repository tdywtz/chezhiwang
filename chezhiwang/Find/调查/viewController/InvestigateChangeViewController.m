//
//  InvestigateChangeViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/18.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "InvestigateChangeViewController.h"

@interface InvestigateChangeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSArray *_dataArray;
}

@end

@implementation InvestigateChangeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor = colorLightBlue;
    [self.view addSubview:view];
    
    _dataArray = @[@"不限",@"微型车",@"小型车",@"紧凑型车",@"中型车",@"中大型车",@"豪华型车",@"SUV",@"MPV",@"跑车",@"面包车",@"其他"];
    [self createTableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = CGRectMake(WIDTH/3, 20, WIDTH/3*2, HEIGHT-20);
        }];
    });

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
  
    if (!CGRectContainsPoint(_tableView.frame, point)) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 20, WIDTH, HEIGHT-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) Font:[LHController setFont] Bold:NO TextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] Text:@"车型属性"];
    label.textAlignment = NSTextAlignmentCenter;
    _tableView.tableHeaderView = label;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uicell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"uicell"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [cell.contentView addSubview:view];
    }
    cell.textLabel.textColor = colorBlack;
    cell.textLabel.font = [UIFont systemFontOfSize:[LHController setFont]-3];
    cell.textLabel.text = _dataArray[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.blcok) {
        NSString *name = _dataArray[indexPath.row];
        NSString *ID = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        self.blcok(name,ID);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)returnChange:(void(^)(NSString *,NSString *))block{
    self.blcok = block;
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
