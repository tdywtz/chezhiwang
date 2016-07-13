//
//  ForumClassifyViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/28.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumClassifyViewController.h"
#import "ForumClassifyListViewController.h"
#import "AIMTableViewIndexBar.h"
#import "WritePostViewController.h"

@interface ForumClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,AIMTableViewIndexBarDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_indexArray;
    
    UIView *twoView;
    NSArray *twoArray;
    UITableView *twoTableView;
}
@end

@implementation ForumClassifyViewController

-(void)readData{


    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"auto_toolbarRightTriangle@2x"]];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [HttpRequest GET:[URLFile urlStringForOtherSeries] policy:NSURLRequestReturnCacheDataElseLoad success:^(id responseObject) {
        [SVProgressHUD dismiss];
        for (NSDictionary *dict in responseObject) {
          
            NSString *key = dict[@"letter"];
            NSMutableArray *mArr = dictionary[key];
            if (mArr == nil) {
                mArr = [[NSMutableArray alloc] init];
            }
            [mArr addObject:dict];
            [dictionary setObject:mArr forKey:key];
        }
        
        for (int i = 'A'; i <= 'Z'; i ++) {
            NSString *key = [NSString stringWithFormat:@"%c",i];
            if (dictionary[key]) {
                [_dataArray addObject:dictionary[key]];
                [_indexArray addObject:key];
            }
        }
        AIMTableViewIndexBar *indexBar = [[AIMTableViewIndexBar alloc] initWithFrame:CGRectMake(WIDTH-30, 94, 30, HEIGHT-64-80) andArray:_indexArray];
        indexBar.delegate = self;
        [self.view insertSubview:indexBar belowSubview:twoView];
        
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"品牌论坛";
    _dataArray = [[NSMutableArray alloc] init];
    _indexArray = [[NSMutableArray alloc] init];

    [self createTableView];
    [self readData];
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
    if (tableView == twoTableView) return 1;
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == twoTableView) return twoArray.count;
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == twoTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twocell"];
        }
        //cell.imageView.image = [UIImage imageNamed:@""];
        cell.textLabel.text = twoArray[indexPath.row][@"sname"];
        cell.textLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //cell.imageView.image = [[UIImage alloc] init];
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row][@"bname"];
    cell.textLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    return cell;
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70;
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == twoTableView) return nil;
    return _indexArray[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   // if (tableView == twoTableView) return 0;
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == twoTableView) {
        
        if (self.nextType == classifyNextPop) {
            //回调函数
            if (self.block) {
                self.block(twoArray[indexPath.row][@"sid"],twoArray[indexPath.row][@"sname"]);
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (self.pushtype == onePushTypeList) {
            ForumClassifyListViewController *list = [[ForumClassifyListViewController alloc] init];
            list.sid = twoArray[indexPath.row][@"sid"];
            list.forumType = forumClassifyBrand;
            [self.navigationController pushViewController:list animated:YES];
        }else{
            WritePostViewController *write = [[WritePostViewController alloc] init];
            write.sid = twoArray[indexPath.row][@"sid"];
            [self.navigationController pushViewController:write animated:YES];
        }
        
    }else{
        twoArray = _dataArray[indexPath.section][indexPath.row][@"series"];
        [twoTableView reloadData];
        [self showTwoView:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == _tableView) [self showTwoView:NO];
}

#pragma mark - AIMTableViewIndexBarDelegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
  
    if ([_tableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
    }
}


//回调
-(void)returnSid:(returnSid)block{
    self.block = block;
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
