//
//  ChooseViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/18.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "ChooseViewController.h"
#import "MJNIndexView.h"

typedef enum {
    chooseNumberAlone,//单选
    chooseNumberMany//多选
}chooseNumber;

#pragma mark - class - ChooseSectionModel
@implementation ChooseSectionModel

//质量投诉
+ (NSArray<ChooseSectionModel *> *) getComplainQualityArray{
    ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];
    sectionModel.rowModels = @[
                               [[ChooseViewModel alloc] initWithID:@"0" title:@"发动机"],
                               [[ChooseViewModel alloc] initWithID:@"1" title:@"变速器"],
                               [[ChooseViewModel alloc] initWithID:@"2" title:@"离合器"],
                               [[ChooseViewModel alloc] initWithID:@"3" title:@"转向系统"],
                               [[ChooseViewModel alloc] initWithID:@"4" title:@"制动系统"],
                               [[ChooseViewModel alloc] initWithID:@"5" title:@"前后桥及悬挂系统"],
                               [[ChooseViewModel alloc] initWithID:@"6" title:@"轮胎"],
                               [[ChooseViewModel alloc] initWithID:@"7" title:@"车身附件及电器"]
                               ];
    return @[sectionModel];
}
//服务问题投诉
+ (NSArray<ChooseSectionModel *> *) getComplainServiceArray{
    ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];
    sectionModel.rowModels = @[
                               [[ChooseViewModel alloc] initWithID:@"0" title:@"服务态度"],
                               [[ChooseViewModel alloc] initWithID:@"1" title:@"人员技术"],
                               [[ChooseViewModel alloc] initWithID:@"2" title:@"服务收费"],
                               [[ChooseViewModel alloc] initWithID:@"3" title:@"承诺不兑现"],
                               [[ChooseViewModel alloc] initWithID:@"4" title:@"销售欺诈"],
                               [[ChooseViewModel alloc] initWithID:@"5" title:@"配件争议"],
                               [[ChooseViewModel alloc] initWithID:@"6" title:@"其他问题"]
                               ];
    return @[sectionModel];
}

//综合投诉
+ (NSArray<ChooseSectionModel *> *) getComplainSumupArray{
    ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];
    sectionModel.rowModels = @[
                               [[ChooseViewModel alloc] initWithID:@"0" title:@"发动机"],
                               [[ChooseViewModel alloc] initWithID:@"1" title:@"变速器"],
                               [[ChooseViewModel alloc] initWithID:@"2" title:@"离合器"],
                               [[ChooseViewModel alloc] initWithID:@"3" title:@"转向系统"],
                               [[ChooseViewModel alloc] initWithID:@"4" title:@"制动系统"],
                               [[ChooseViewModel alloc] initWithID:@"5" title:@"前后桥及悬挂系统"],
                               [[ChooseViewModel alloc] initWithID:@"6" title:@"轮胎"],
                               [[ChooseViewModel alloc] initWithID:@"7" title:@"车身附件及电器"],

                               [[ChooseViewModel alloc] initWithID:@"9" title:@"服务态度"],
                               [[ChooseViewModel alloc] initWithID:@"10" title:@"人员技术"],
                               [[ChooseViewModel alloc] initWithID:@"11" title:@"服务收费"],
                               [[ChooseViewModel alloc] initWithID:@"12" title:@"承诺不兑现"],
                               [[ChooseViewModel alloc] initWithID:@"13" title:@"销售欺诈"],
                               [[ChooseViewModel alloc] initWithID:@"14" title:@"配件争议"],
                               [[ChooseViewModel alloc] initWithID:@"15" title:@"其他问题"]
                               ];
    return @[sectionModel];
}

@end

#pragma mark - class - ChooseViewModel
@implementation ChooseViewModel

- (instancetype)initWithID:(NSString *)ID title:(NSString *)title{
    if (self = [super init]) {
        _ID = ID;
        _title = title;
    }
    return self;
}
@end

#pragma mark - class - ChooseViewController

@interface ChooseViewController ()<UITableViewDataSource,UITableViewDelegate,MJNIndexViewDataSource>
{
    UIButton *rightItemButton;
    UITableView *_tableView;
    NSArray *_sectionModels;
    
    NSString *_returnID;
    NSString *_returnTitle;
    UIActivityIndicatorView *_activity;
}
@property (nonatomic,assign) UITableViewStyle tabelViewStyle;
@property (nonatomic,assign) chooseNumber chooseNumbers;
@property (nonatomic,strong) NSMutableArray *titleArray;//存放多选时被选择的名称
@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation ChooseViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray = [[NSMutableArray alloc] init];
    }
    return self;
}



-(void)downloadBrand{
    _activity = [self createActivity];
     __weak __typeof(self)weakSelf = self;
   [HttpRequest GET:[URLFile urlStringForLetter] success:^(id responseObject) {

       NSMutableArray *mArray = [[NSMutableArray alloc] init];
       NSMutableArray *letterArray = [[NSMutableArray alloc] init];
       for (NSDictionary *dict in responseObject[@"rel"]) {
           [letterArray addObject:dict[@"letter"]];
           ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];
           sectionModel.title = dict[@"letter"];

           NSMutableArray *rowModels = [[NSMutableArray alloc] init];
           for (NSDictionary *subDic in dict[@"brand"]) {
               ChooseViewModel *model = [[ChooseViewModel alloc] initWithID:subDic[@"id"] title:subDic[@"name"]];
               [rowModels addObject:model];
           }
           sectionModel.rowModels = rowModels;
           [mArray addObject:sectionModel];
       }
       _sectionModels = mArray;

       [_tableView reloadData];
        weakSelf.indexView.dataSource = self;
       [weakSelf.view addSubview:weakSelf.indexView];
       [_activity stopAnimating];

   } failure:^(NSError *error) {
        [_activity stopAnimating];
   }];
}


-(void)downloadSeries:(NSString *)brandID{ 
    _activity = [self createActivity];
    NSString *urlString = [NSString stringWithFormat:[URLFile urlStringForSeries],brandID];
    [HttpRequest GET:urlString success:^(id responseObject) {

        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"rel"]) {

            ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];
            sectionModel.title = dict[@"brands"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDict in dict[@"series"]) {
                ChooseViewModel *model = [[ChooseViewModel alloc] initWithID:subDict[@"seriesid"] title:subDict[@"seriesname"]];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
        _sectionModels = mArray;
        [_tableView reloadData];
        [_activity stopAnimating];

    } failure:^(NSError *error) {
         [_activity stopAnimating];
    }];
}

-(void)downloadModel:(NSString *)seriesID{
    _activity = [self createActivity];
    NSString *urlString = [NSString stringWithFormat:[URLFile urlStringForModelList],seriesID];
     [HttpRequest GET:urlString success:^(id responseObject) {

         ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];

         NSMutableArray *rowModels = [[NSMutableArray alloc] init];
         for (NSDictionary *dict in responseObject[@"rel"]) {
             ChooseViewModel *model = [[ChooseViewModel alloc] initWithID:dict[@"mid"] title:dict[@"modelname"]];
             [rowModels addObject:model];
         }
         sectionModel.rowModels = rowModels;
         _sectionModels = @[sectionModel];
          
         [_tableView reloadData];
         [_activity stopAnimating];

     } failure:^(NSError *error) {
         [_activity stopAnimating];

     }];
}

-(void)downloadBusiness:(NSString *)provinceId CityId:(NSString *)cityId SeriesId:(NSString *)seriesId{
    
    NSString *urlString = [NSString stringWithFormat:[URLFile urlStringForDis],provinceId,cityId,seriesId];
    [HttpRequest GET:urlString success:^(id responseObject) {

         ChooseSectionModel *sectionModel = [[ChooseSectionModel alloc] init];
        NSMutableArray *rowModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"rel"]) {
            ChooseViewModel *model = [[ChooseViewModel alloc] initWithID:dict[@"did"] title:dict[@"name"]];
            [rowModels addObject:model];
        }
        sectionModel.rowModels = rowModels;

        _sectionModels = @[sectionModel];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 加载图
-(UIActivityIndicatorView *)createActivity{
    //加载等待提示控件，初始化的时候，设定风格样式
    //控件宽高固定
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //设置中心点为view的中心点
    activity.center = self.view.center;
    activity.color = [UIColor grayColor];
    [self.view addSubview:activity];
    //让控件开始转动
    [activity startAnimating];
    return activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = colorLightBlue;
    
    [self createLeftItem];

    if (self.chooseNumbers == chooseNumberMany) {
        [self createRightItem];
    }
    [self createTableView];
    [self firstAttributesForMJNIndexView];
}

-(void)createLeftItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(leftItemClick) Text:@"取消"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)leftItemClick{

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)createRightItem{
    rightItemButton = [LHController createButtnFram:CGRectMake(0, 0, 40, 20) Target:self Action:@selector(rightItemClick) Text:@"完成"];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    [self setRightItemButtonEnabled:NO];
}

-(void)rightItemClick{
    NSString *title = _returnTitle;
    NSString *ID = _returnID;
    if (self.chooseNumbers == chooseNumberMany) {
        ID = @"";
        title = [self.titleArray componentsJoinedByString:@","];
    }
    if (self.block) {
        self.block(title,ID);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//改变按钮状态
-(void)setRightItemButtonEnabled:(BOOL)b{
    
    self.navigationItem.rightBarButtonItem.enabled = b;
    if (b) {
       
        [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [rightItemButton setTitleColor:RGB_color(200, 200, 200, 1) forState:UIControlStateNormal];
       
    }
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

-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)setChoosetype:(chooseType)choosetype{
    _choosetype = choosetype;
   
    self.tabelViewStyle = UITableViewStylePlain;
   
    if (_choosetype == chooseTypeBrand) {
        self.title = @"品牌";
        self.chooseNumbers = chooseNumberAlone;
        self.tabelViewStyle = UITableViewStyleGrouped;
        [self downloadBrand];

    }else if (_choosetype == chooseTypeSeries){
        self.title = @"车系";
        self.chooseNumbers = chooseNumberAlone;
        self.tabelViewStyle = UITableViewStyleGrouped;
        [self downloadSeries:self.ID];
        
    }else if (_choosetype == chooseTypeModel){
        self.title = @"车型";
        self.chooseNumbers = chooseNumberAlone;
        [self downloadModel:self.ID];
        
    }else if (_choosetype == chooseTypeComplainQuality){
        self.title = @"质量投诉部位";
        self.chooseNumbers = chooseNumberMany;
        _sectionModels = [ChooseSectionModel getComplainQualityArray];
        
    }else if (_choosetype == chooseTypeComplainService){
        self.title = @"服务投诉问题";
        self.chooseNumbers = chooseNumberMany;
        _sectionModels = [ChooseSectionModel getComplainServiceArray];
        
    }else if (_choosetype == chooseTypeComplainSumup){
        self.title = @"综合问题";
        self.chooseNumbers = chooseNumberMany;
        _sectionModels = [ChooseSectionModel getComplainSumupArray];
        
    }else if (_choosetype == chooseTypeBusiness){
        self.title = @"经销商";
        self.chooseNumbers = chooseNumberAlone;
        [self downloadBusiness:self.ID CityId:self.cityId SeriesId:self.seriesId];
    }
}

-(void)retrunResults:(returnResult)block{
    self.block = block;
}


#pragma mark - MJNIndexViewDataSource
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    NSMutableArray *letters = [NSMutableArray array];
    for (ChooseSectionModel *sectionModel in _sectionModels) {
        if(sectionModel.title)  [letters addObject:sectionModel.title];
    }
    return letters;

}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{

    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ChooseSectionModel *sectionModel = _sectionModels[section];
    return sectionModel.rowModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-50, 15, 24, 17)];
        imageView.image = [UIImage imageNamed:@"chooseImage_check"];
        imageView.tag = 200;
        [cell.contentView addSubview:imageView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 43, WIDTH-30, 1)];
        view.backgroundColor = colorLineGray;
        [cell.contentView addSubview:view];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ChooseSectionModel *sectionModel = _sectionModels[indexPath.section];
    ChooseViewModel *model = sectionModel.rowModels[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.textColor = colorBlack;

    UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:200];
    cellImageView.hidden = YES;
    if (self.chooseNumbers == chooseNumberAlone) {
        if ([model.title isEqualToString:_returnTitle]) {
            cell.textLabel.textColor = colorDeepBlue;
            cellImageView.hidden = NO;
        }
    }else if (self.chooseNumbers == chooseNumberMany){
        for (int i = 0; i < self.titleArray.count; i ++) {
            if ([model.title isEqualToString:self.titleArray[i]]) {
                cell.textLabel.textColor = colorDeepBlue;
                cellImageView.hidden = NO;
            }
        }
    }
  
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setRightItemButtonEnabled:YES];
   
    ChooseSectionModel *sectionModel = _sectionModels[indexPath.section];
    ChooseViewModel *model = sectionModel.rowModels[indexPath.row];

    if (self.chooseNumbers == chooseNumberAlone) {
        if (![model.title isEqualToString:_returnTitle]) {
            _returnTitle = model.title;
            _returnID = model.ID;
            [_tableView reloadData];
        }
        [self rightItemClick];
    }else if (self.chooseNumbers == chooseNumberMany){
        NSInteger integer = [self.titleArray indexOfObject:model.title];
        if (integer < 1000) {
            [self.titleArray removeObject:model.title];
            if (self.titleArray.count == 0) {
                [self setRightItemButtonEnabled:NO];
            }
        }else{
            [self.titleArray addObject:model.title];
        }
        [_tableView reloadData];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.tabelViewStyle == UITableViewStyleGrouped) {

        ChooseSectionModel *sectionModel = _sectionModels[section];
        return sectionModel.title;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tabelViewStyle == UITableViewStyleGrouped) {
         return 40;
    }
    return 0.0;
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
