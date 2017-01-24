

//
//  ChooseTableView.m
//  chezhiwang
//
//  Created by bangong on 17/1/12.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "ChooseTableView.h"
#import <MJNIndexView.h>

static NSString * const reuseIdentifier = @"Cell";

@interface ChooseTableView ()<MJNIndexViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MJNIndexView *indexView;


@end

@implementation ChooseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.separatorColor = colorLineGray;
        _tableView.rowHeight = 60;
        [self addSubview:_tableView];
       
//        [_tableView makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(CGRectZero);
//        }];

        [_tableView registerClass:[ChooseTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}


- (void)firstAttributesForMJNIndexView
{
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.bounds];

    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.fontColor = colorLightBlue;
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}

- (void)setSectionModels:(NSArray<__kindof ChooseTableViewSectionModel *> *)sectionModels{
    _sectionModels = sectionModels;

    if (_isIndex) {
        if (self.indexView == nil) {
            [self firstAttributesForMJNIndexView];
        }
        self.indexView.dataSource = self;
        self.indexView.frame = self.bounds;
        [self insertSubview:self.indexView aboveSubview:self.tableView];
    }
}


#pragma mark - MJNIndexViewDataSource
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView{
    NSMutableArray *letters = [NSMutableArray array];
    for (ChooseTableViewSectionModel *sectionModel in _sectionModels) {
        if (sectionModel.title) {
            [letters addObject:sectionModel.title];
        }
    }
    return letters;
}

// you have to implement this method to get the selected index item
- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ChooseTableViewSectionModel *sectionModel = _sectionModels[section];
    return sectionModel.rowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.isShowImage = self.isShowImage;

    ChooseTableViewSectionModel *sectionModel = _sectionModels[indexPath.section];
    ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];

    [cell setModel:model];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_isShowSection) {
        ChooseTableViewSectionModel *sectionModel = _sectionModels[section];
        return sectionModel.title;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectedRow) {
        ChooseTableViewSectionModel *sectionModel = _sectionModels[indexPath.section];
        ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];
        self.didSelectedRow(model);
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
