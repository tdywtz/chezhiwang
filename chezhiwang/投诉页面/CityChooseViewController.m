//
//  CityChooseViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "CityChooseViewController.h"

@interface CityChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *rightItemButton;
    UITableView *_oneTableView;
    NSArray *_oneDataArray;
    
    UIView *_twoSuperView;
    UITableView *_twoTableView;
    NSArray *_twoDataArray;
    
    NSString *_pid;
    NSString *_pName;
    NSString *_cid;
    NSString *_cName;
}

@end

@implementation CityChooseViewController

-(void)loadDataOne{
    [HttpRequest GET:[URLFile urlStringForPro] success:^(id responseObject) {
        _oneDataArray = responseObject;
        [_oneTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadDataTwo:(NSString *)pid{
    NSString *urlSting = [NSString stringWithFormat:[URLFile urlStringForDisCity],pid];
    [HttpRequest GET:urlSting success:^(id responseObject) {
        _twoDataArray = responseObject;
        [_twoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = colorLightBlue;
    self .title = @"省、市";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftItem];
    //[self createRightItem];
    [self createTableView];
    [self loadDataOne];
}

-(void)createLeftItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(leftItemClick) Text:@"取消"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
}

-(void)leftItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createRightItem{
    rightItemButton = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"完成"];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self setRightItemButtonEnabled:NO];
}

-(void)rightItemClick{
    if (self.block) {
        self.block(_pName,_pid,_cName,_cid);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//改变按钮状态
-(void)setRightItemButtonEnabled:(BOOL)b{
   
    rightItemButton.enabled = b;
    if (b) {
        [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [rightItemButton setTitleColor:RGB_color(200, 200, 200, 1) forState:UIControlStateNormal];
    }
}

-(void)createTableView{

    _oneTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _oneTableView.delegate = self;
    _oneTableView.dataSource = self;
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_oneTableView];
    
    _twoSuperView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH+10, 64, WIDTH/3*2, HEIGHT-64)];
    _twoSuperView.layer.shadowColor = [UIColor blackColor].CGColor;
    _twoSuperView.layer.shadowOffset = CGSizeMake(-4, 0);
    _twoSuperView.layer.shadowOpacity = 0.5;
    [self.view addSubview:_twoSuperView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_twoSuperView addGestureRecognizer:pan];
    
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _twoSuperView.frame.size.width, _twoSuperView.frame.size.height) style:UITableViewStylePlain];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_twoSuperView addSubview:_twoTableView];
}

#pragma mark - 滑动
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    
    if (point.x+pan.view.frame.origin.x > WIDTH/3) {
        pan.view.center = CGPointMake(point.x+pan.view.center.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.frame.origin.x< WIDTH/3+30) {
            [UIView animateWithDuration:0.3 animations:^{
                pan.view.frame = CGRectMake(WIDTH/3, 64, WIDTH/3*2, HEIGHT-64);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                pan.view.frame = CGRectMake(WIDTH+10, 64, WIDTH/3*2, HEIGHT-64);
            }];
        }
    }
}

-(void)returnRsults:(returnResults)block{
    self.block = block;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _oneTableView) return _oneDataArray.count;
    return _twoDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _oneTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"onecell"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-50, 15, 24, 17)];
            imageView.image = [UIImage imageNamed:@"chooseImage_check"];
            imageView.tag = 100;
            [cell.contentView addSubview:imageView];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 43, WIDTH-30, 1)];
            view.backgroundColor = colorLineGray;
            [cell.contentView addSubview:view];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = _oneDataArray[indexPath.row][@"Name"];
        UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:100];
        if ([cell.textLabel.text isEqualToString:_pName]) {
            cell.textLabel.textColor = colorDeepBlue;
            cellImageView.hidden = NO;
        }else{
            cell.textLabel.textColor = colorBlack;
            cellImageView.hidden = YES;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twocell"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_twoTableView.frame.size.width-50, 15, 24, 17)];
        imageView.image = [UIImage imageNamed:@"chooseImage_check"];
        imageView.tag = 200;
        [cell.contentView addSubview:imageView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 43, WIDTH-30, 1)];
        view.backgroundColor = colorLineGray;
        [cell.contentView addSubview:view];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = _twoDataArray[indexPath.row][@"CityName"];
    UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:200];
    if ([cell.textLabel.text isEqualToString:_cName]) {
        cell.textLabel.textColor = colorDeepBlue;
        cellImageView.hidden = NO;
    }else{
        cell.textLabel.textColor = colorBlack;
        cellImageView.hidden = YES;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _oneTableView) {
    
        NSDictionary *dict = _oneDataArray[indexPath.row];
        if (![_pid isEqualToString:dict[@"Id"]]) {
            [self loadDataTwo:dict[@"Id"]];
            _twoSuperView.frame = CGRectMake(WIDTH+10, 64, WIDTH/3*2, HEIGHT-64);
            
            _pid = dict[@"Id"];
            _pName = dict[@"Name"];
            if ([_pid isKindOfClass:[NSNumber class]]) {
                _pid = [NSString stringWithFormat:@"%@",_pid];
            }
            _cName = nil;
            _cid = nil;
            
            [self setRightItemButtonEnabled:NO];
            [_oneTableView reloadData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _twoSuperView.frame = CGRectMake(WIDTH/3, 64, WIDTH/3*2, HEIGHT-64);
        }];
    }else{
        NSDictionary *dict = _twoDataArray[indexPath.row];

        if (![_cName isEqualToString:dict[@"CityName"]]) {
            
            _cid = dict[@"CityId"];
            _cName = dict[@"CityName"];
            if ([_cid isKindOfClass:[NSNumber class]]) {
                _pid = [NSString stringWithFormat:@"%@",_cid];
            }
            [self setRightItemButtonEnabled:YES];
            [_twoTableView reloadData];
        }
        [self rightItemClick];
    }
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
