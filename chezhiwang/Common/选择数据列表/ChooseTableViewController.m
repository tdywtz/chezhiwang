//
//  ChooseTableViewController.m
//  chezhiwang
//
//  Created by bangong on 16/12/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChooseTableViewController.h"
#import <MJNIndexView.h>

#pragma mark - 模型ChooseTableViewSectionModel
@implementation ChooseTableViewSectionModel

- (NSString *)title{
    if (_title == nil) {
        _title = @"#";
    }
    return  _title;
}
@end

#pragma mark - ChooseTableViewModel
@implementation ChooseTableViewModel

@end

#pragma mark - cell
@interface ChooseTableViewCell : UITableViewCell

@end

@implementation ChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = colorBlack;
    }
    return self;
}

@end

#pragma mark - 列表ChooseTableViewController

static NSString * const reuseIdentifier = @"Cell";

@interface ChooseTableViewController ()<MJNIndexViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MJNIndexView *indexView;

@end

@implementation ChooseTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[ChooseTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)firstAttributesForMJNIndexView
{
    self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];

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
        [self.view insertSubview:self.indexView aboveSubview:self.tableView];
    }
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:self.style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ChooseTableViewSectionModel *sectionModel = _sectionModels[indexPath.section];
    ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];

    cell.textLabel.text = model.title;

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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
