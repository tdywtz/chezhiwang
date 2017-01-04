//
//  ChangeView.m
//  chezhiwang
//
//  Created by bangong on 15/11/3.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "ChangeView.h"

@interface  ChangeView()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSArray *_dataArray;
}

@end

@implementation ChangeView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = @[@"不限",@"微型车",@"小型车",@"紧凑型车",@"中型车",@"中大型车",@"豪华型车",@"SUV",@"MPV",@"跑车",@"面包车",@"其他"];
        [self createTableView];
    }
    return self;
}


-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, 40) Font:[LHController setFont] Bold:NO TextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] Text:@"车型属性"];
    label.textAlignment = NSTextAlignmentCenter;
    _tableView.tableHeaderView = label;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uicell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"uicell"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        view.backgroundColor = colorLineGray;
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
        self.blcok(_dataArray[indexPath.row],[NSString stringWithFormat:@"%ld",indexPath.row]);
    }
    
}

-(void)returnChange:(returnChange)block{
    self.blcok = block;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
