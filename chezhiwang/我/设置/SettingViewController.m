//
//  SettingViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "SettingViewController.h"
#import "TakeViewController.h"
#import "AboutViewController.h"
#import "AgreementViewController.h"

@interface SettingViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGFloat B;

    UITableView *_tableView;
    NSArray     *_dataAray;
}
@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    B = [LHController setFont];
    self.navigationItem.title = @"设置";
  
    _dataAray = @[
                  @[
                      @{@"title":@"清除缓存",@"class":@""},
                      @{@"title":@"浏览记录",@"class":@"TakeViewController"},
                      @{@"title":@"用户服务协议",@"class":@"AgreementViewController"}
                      ],
                  @[
                      @{@"title":@"版本号",@"class":@""},
                      @{@"title":@"关于我们",@"class":@"AboutViewController"}
                      ]
                  ];

    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSString *)getText{
    long long a = [self fileSizeAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"]];
    NSInteger m =  [[SDImageCache sharedImageCache] getSize];
    CGFloat n = a*8/1024/1024 + m*8.0/1024/1024*(1000000.0/(m+1000000));
    if (n < 0) {
        n = 0;
    }
    return  [NSString stringWithFormat:@"%0.1f MB",n];
  
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    //NSLog(@"%@",filePath);
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


#pragma mark - uialertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self deleteDatabse];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - 清除缓存
- (void)deleteDatabse
{
    //清除sdimage缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

    // delete the old db.
    FmdbManager *DB = [FmdbManager shareManager];
    [DB dropTables];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataAray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100;
        [cell.contentView addSubview:label];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = colorDeepGray;
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(WIDTH-120);
            make.centerY.equalTo(0);
            make.width.equalTo(90);
        }];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dict = _dataAray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"title"];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    if (indexPath.section == 0 && indexPath.row == 0) {
        label.text = [self getText];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *versionNow = [info objectForKey:@"CFBundleShortVersionString"];
        label.text = versionNow;
    }else{
        label.text = @"";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:
                           @"您确定要清除所有缓存？" delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:@"取消", nil];
        [al show];
        
    }else if (!(indexPath.section == 1 && indexPath.row == 0)){
        NSString *str = _dataAray[indexPath.section][indexPath.row][@"class"];
        [self.navigationController pushViewController:[[NSClassFromString(str) alloc] init] animated:YES];
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
