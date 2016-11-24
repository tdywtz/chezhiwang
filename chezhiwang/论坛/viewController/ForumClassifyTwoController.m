//
//  ForumClassifyTwoController.m
//  chezhiwang
//
//  Created by bangong on 15/10/14.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumClassifyTwoController.h"
#import "ForumClassifyListViewController.h"
#import "WritePostViewController.h"

@interface ForumClassifyTwoCell : UITableViewCell

@end

@implementation ForumClassifyTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];

    self.imageView.frame = CGRectMake(0,0,44,44);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.lh_centerY = self.lh_centerY;


    CGRect tmpFrame = self.textLabel.frame;

    tmpFrame.origin.x = 46;

    self.textLabel.frame = tmpFrame;

    // self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = colorBlack;

    tmpFrame = self.detailTextLabel.frame;

    tmpFrame.origin.x = 46;
    
    self.detailTextLabel.frame = tmpFrame;
    
}

@end


#pragma mark - -----------------
@interface ForumClassifyTwoController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation ForumClassifyTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"栏目论坛";
   
    [self createTableView];
    
    [self createData];
}

-(void)createData{
  _dataArray = @[
                       @{@"title":@"故障交流",@"imageName":@"forum_故障交流",@"ID":@"2"},
                       @{@"title":@"用车心得",@"imageName":@"forum_用车心得",@"ID":@"3"},
                       @{@"title":@"人车生活",@"imageName":@"forum_人车生活",@"ID":@"1"},
                       @{@"title":@"汽车文化",@"imageName":@"forum_汽车文化",@"ID":@"5"},
                       @{@"title":@"七嘴八舌",@"imageName":@"forum_七嘴八舌",@"ID":@"4"},
                       @{@"title":@"召回与三包",@"imageName":@"forum_汽车召回与三包",@"ID":@"6"}
                       ];
    [_tableView reloadData];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotcell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [cell.contentView addSubview:view];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    cell.imageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    cell.textLabel.text = dict[@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataArray[indexPath.row];

        if ( self.block) {
            self.block(dict[@"ID"],dict[@"title"]);
        }
        [self.navigationController popViewControllerAnimated:YES];

}

//回调
-(void)returnCid:(returnCid)block{
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
