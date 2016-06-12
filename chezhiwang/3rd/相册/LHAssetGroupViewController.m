//
//  LHAssetGroupViewController.m
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import "LHAssetGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LHAssetViewController.h"

@interface LHAssetGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
}
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation LHAssetGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createRightItem];
    [self createTableView];
    [self setGroup];
}

-(void)createRightItem{
    UIButton *btn = [self createButtonWithFrame:CGRectMake(0, 0, 40, 20) Target:self action:@selector(rightClick) Text:@"取消"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
   // [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)rightClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)setGroup
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    ALAssetsFilter *assetsFilter = [ALAssetsFilter allPhotos];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0) {
                [self.groups addObject:group];
            }
        }
        else{
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/2-50, WIDTH-20, 50)];
        label.text = @"此应用没有权限访问您的相册，您可以在设置中开启权限";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    ALAssetsGroup *group = self.groups[indexPath.row];
    CGImageRef posterImage = group.posterImage;
    cell.imageView.image = [UIImage imageWithCGImage:posterImage];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)[group numberOfAssets]];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80, 59, self.view.frame.size.width-80, 1)];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [cell.contentView addSubview:view];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LHAssetViewController *lh = [[LHAssetViewController alloc] init];
    lh.assetGroup = self.groups[indexPath.row];
    [self.navigationController pushViewController:lh animated:YES];
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
