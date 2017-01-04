//
//  SearchHistoryView.m
//  auto
//
//  Created by bangong on 15/11/12.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "SearchHistoryView.h"

@interface SearchHistoryView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    NSUserDefaults *_userDefaults;
    UIView *tableHeaderView;
    NSString *history;
}
@end

@implementation SearchHistoryView

-(instancetype)initWithFrame:(CGRect)frame Type:(historyType)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        if (type == historyTypeComplain) {
            history = @"searchHistoryDataComplain";
        }else if (type == historyTypeANswer){
            history = @"searchHistoryDataAnswer";
        }else if (type == historyTypeNews){
            history = @"searchHistoryDataNews";
        }
    }
    return self;
}

-(void)makeUI{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _dataArray = [[NSMutableArray alloc] init];
    
    [self createTabelView];
    [self createTabelHeaderView];
}

-(void)createTabelHeaderView{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    tableHeaderView.backgroundColor = colorLineGray;
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 10, 80, 20) Font:15 Bold:NO TextColor:colorDeepGray Text:@"搜索历史"];
    [tableHeaderView addSubview:label];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(WIDTH-30, 10, 20, 20) Target:self Action:@selector(headerClick) Text:nil];
    [button setImage:[UIImage imageNamed:@"searchView_close"] forState:UIControlStateNormal];
    [tableHeaderView addSubview:button];
}

-(void)headerClick{
    [_userDefaults setObject:[[NSMutableArray alloc] init] forKey:history];
    [_userDefaults synchronize];
    
    _tabelView.tableHeaderView = nil;
    [_dataArray removeAllObjects];
    [_tabelView reloadData];
}

-(void)createTabelView{
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tabelView];
}

-(void)selectSring:(selectSring)block{
    self.block = block;
}

//刷新列表
-(void)reloadDataOFtableview:(NSString *)string{
    if (history == nil) {
        history = @"";
    }
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:history];
    [_dataArray removeAllObjects];
    if (string.length == 0) {
        for (NSString *str in array) {
            [_dataArray addObject:str];
        }
    }else{
        for (NSString *str in array) {
            if ([str rangeOfString:string].length > 0) {
                [_dataArray addObject:str];
            }
        }
    }
    
    if (_dataArray.count > 0) {
        _tabelView.tableHeaderView = tableHeaderView;
    }else{
        _tabelView.tableHeaderView = nil;
    }
        [_tabelView reloadData];
}

//保存搜索字符串
-(void)updataOFhistory:(NSString *)string{

    if (string.length == 0) {
        return;
    }
    NSArray *array = [_userDefaults objectForKey:history];
    if (array == nil) {
        array = [[NSArray alloc] init];
    }
    NSMutableArray *mArary = [[NSMutableArray alloc] initWithArray:array];
   [mArary removeObject:string];
   [mArary addObject:string];
    if (mArary.count > 20) {
        [mArary removeObjectAtIndex:0];
    }
   [_userDefaults setObject:mArary forKey:history];
   [_userDefaults synchronize];
}

#pragma mark - UITableViewDeleate/datasouch
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
        view.backgroundColor = colorBackGround;
        [cell.contentView addSubview:view];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = colorBlack;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block(_dataArray[indexPath.row]);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
