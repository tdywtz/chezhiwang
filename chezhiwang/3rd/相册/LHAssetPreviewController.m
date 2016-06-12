//
//  LHAssetPreviewController.m
//  auto
//
//  Created by bangong on 15/7/30.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "LHAssetPreviewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LHAssetPickerController.h"
#import "LHPreViewCell.h"

#define myHeight [UIScreen mainScreen].bounds.size.height
#define myWidth [UIScreen mainScreen].bounds.size.width

@interface LHAssetPreviewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_array;
    UITableView *_tabelView;
    UIButton *rightButton;
    NSInteger _num;
}
@end

@implementation LHAssetPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _array = [[NSMutableArray alloc] init];
    if (self.resultArray) {
        [_array setArray:self.resultArray];
    }
    LHAssetPickerController *picker = (LHAssetPickerController *)self.navigationController;
    picker.navigationBar.alpha = 0.8;
    [self createLeftItem];
    //[self craeteScrollView];
    [self createTableView];
    [self createtRightItem];
    [self btnState:self.index];
}

-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(blockClick)];
}

-(void)blockClick{
    if (self.getRsuelt) {
        self.getRsuelt(_array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createtRightItem{
    rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    rightButton.layer.cornerRadius = 30;
    rightButton.layer.masksToBounds = YES;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"FriendsSendsPicturesSelectBigYIcon"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(rightItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(void)rightItem:(UIButton *)btn{
    if (btn.selected == NO) {
        LHAssetPickerController *picker = (LHAssetPickerController *)self.navigationController;
        if (_array.count == picker.maxNumber) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"图片不能超过%ld张",picker.maxNumber] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [al show];
            [UIView animateWithDuration:0.3 animations:^{
                [al dismissWithClickedButtonIndex:0 animated:YES];
            }];
            return;
        }
    }
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        [_array addObject:self.assetArray[_num]];
    }else{
        [_array removeObject:self.assetArray[_num]];
    }
}

-(void)createTableView{
    _tabelView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT, WIDTH) style:UITableViewStylePlain];
    _tabelView.center = CGPointMake(WIDTH / 2, HEIGHT/2);
    _tabelView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.pagingEnabled = YES;
    
    [self.view addSubview:_tabelView];
}



-(void)getRsuelt:(void (^)(NSArray *))block{
    self.getRsuelt = block;
}

#pragma mark -  UITableViewDataSource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHPreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LHPreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.asset = self.assetArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.y/WIDTH;
    _num = index;
    [self btnState:index];
}

-(void)btnState:(NSInteger)index{
    rightButton.selected = NO;
    _tabelView.contentOffset = CGPointMake(0, WIDTH*index);
    ALAsset *asset = self.assetArray[index];
    for (int i = 0; i < _array.count; i ++) {
        if ([_array[i] isEqual:asset]) {
            rightButton.selected = YES;
            break;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    LHAssetPickerController *picker = (LHAssetPickerController *)self.navigationController;
    picker.navigationBar.alpha = 1;
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
