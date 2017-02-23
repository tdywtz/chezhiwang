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

+ (void)brand:(void(^)(NSArray <ChooseTableViewSectionModel *> *))result{
    if (result == nil) {
        return;
    }
    [HttpRequest GET:[URLFile urlStringForLetter] success:^(id responseObject) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];

        for (NSDictionary *dict in responseObject[@"rel"]) {
            ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
            sectionModel.title = dict[@"letter"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"brand"]) {
                ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
                model.ID = subDic[@"id"];
                model.title = subDic[@"name"];
                model.imageUrl = subDic[@"logo"];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
         result(mArray);
    } failure:^(NSError *error) {
        result(nil);
    }];

}

+ (void)seriesWithBid:(NSString *)bid result:(void (^)(NSArray<ChooseTableViewSectionModel *> *))result{
    if (result == nil) {
        return;
    }
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForSeries],bid];
    [HttpRequest GET:url success:^(id responseObject) {


        NSMutableArray *mArray = [[NSMutableArray alloc] init];

        for (NSDictionary *dict in responseObject[@"rel"]) {
            ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
            sectionModel.title = dict[@"brands"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"series"]) {
                ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
                model.ID = subDic[@"seriesid"];
                model.title = subDic[@"seriesname"];
                model.imageUrl = subDic[@"logo"];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
        result(mArray);

    } failure:^(NSError *error) {
        result(nil);
    }];
}

+ (void)modelWithSid:(NSString *)sid result:(void (^)(NSArray<ChooseTableViewSectionModel *> *))result{
    if (result == nil) {
        return;
    }
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForModelList],sid];
    [HttpRequest GET:url success:^(id responseObject) {
        ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
        [ChooseTableViewModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"mid",@"title":@"modelname",@"imageUrl":@"logo"};
        }];
        sectionModel.rowModels = [ChooseTableViewModel mj_objectArrayWithKeyValuesArray:responseObject[@"rel"]];
        result(@[sectionModel]);
        
    } failure:^(NSError *error) {
        result(nil);
    }];
}

@end

#pragma mark - ChooseTableViewModel
@implementation ChooseTableViewModel

@end

#pragma mark - cell
@implementation ChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = colorBlack;
        self.textLabel.font = [UIFont systemFontOfSize:17];
    }
    return self;
}

- (void)setModel:(ChooseTableViewModel *)model{
    if (_isShowImage) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[CZWManager defaultIconImage]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.textLabel.text = model.title;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    if (_isShowImage) {
        self.imageView.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        CGRect rect = CGRectZero;
        rect.size = CGSizeMake(self.lh_height, self.lh_height-18);
        rect.origin.x = 10;
        rect.origin.y = 9;
        self.imageView.frame = rect;

        rect = self.textLabel.frame;
        rect.origin.x = self.imageView.lh_right + 10;
        self.textLabel.frame = rect;

    }else{

        self.imageView.hidden = YES;
        CGRect rect = self.textLabel.frame;
        rect.origin.x = 10;
        rect.size.width = WIDTH - 20;
        self.textLabel.frame = rect;
    }
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
    [self createLeftItemBack];
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
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.separatorColor = colorLineGray;
        _tableView.rowHeight = 60;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (BOOL)isSelectedID:(NSString *)ID selecteds:(NSArray<NSString *> *)selecteds{
    if (selecteds == nil) {
        return NO;
    }
    for (NSString *str in selecteds) {
        if ([str isEqualToString:ID]) {
            return YES;
        }
    }
    return NO;
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
    cell.isShowImage = self.isShowImage;
    
    ChooseTableViewSectionModel *sectionModel = _sectionModels[indexPath.section];
    ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];

    [cell setModel:model];
    if ([self isSelectedID:model.ID selecteds:_selectId]) {
        cell.textLabel.textColor = colorLightBlue;
    }else{
        cell.textLabel.textColor = colorBlack;
    }

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
    ChooseTableViewSectionModel *sectionModel = _sectionModels[indexPath.section];
    ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];

    if ([self isSelectedID:model.ID selecteds:_selectId]) {
        return;
    }

    if (self.didSelectedRow) {
        self.didSelectedRow(model);
    }

    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
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
