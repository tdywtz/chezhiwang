//
//  ContrastChartViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ContrastChartViewController.h"
#import "ChartView.h"
#import "StarView.h"
#import "LHLabel.h"

@interface ContrastChartViewController ()
{

    NSMutableArray *sectionModelArray;
    ChartView *_chartView;
}
@end

@implementation ContrastChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"对比";
    
    [self createLeftItemBack];
    //第一分组
    sectionModelArray = [[NSMutableArray alloc] init];
    NSArray *array = @[@"车型信息",@"投诉数量",@"厂家回复率",@"用户满意度",@"典型问题"];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        ChartRowModel *rowModel = [[ChartRowModel alloc] init];
        rowModel.name = array[i];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (int j = 0; j < 4; j ++) {
            ChartItemModel *itemModel = [[ChartItemModel alloc] init];
            [items addObject:itemModel];
        }
        rowModel.itemModels = items;
        [rows addObject:rowModel];
    }
    ChartSectionModel *sectionModel = [[ChartSectionModel alloc] init];
    sectionModel.rowModels = rows;

    [sectionModelArray addObject:sectionModel];



    _chartView = [[ChartView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _chartView.itemWidth = 120;
    _chartView.parentViewController = self;
    [self.view addSubview:_chartView];
    __weak __typeof(self)weakSelf = self;
    [_chartView ruturnModel:^(TopCollectionViewModel *topModel) {
        [weakSelf releaesItemDataWithQueue:topModel.index];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [weakSelf loadSectionOneValueListWithBrandId:topModel.brandId seriesId:topModel.seriesId modelId:topModel.modelId queue:topModel.index];
        if ([topModel.modelId integerValue]) {
            [weakSelf loadDataValueListWithSeriesId:topModel.seriesId modelId:topModel.brandId queue:topModel.index];
        }
    }];


    [_chartView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];

    [self loadDataNameList];
}


//清除列数据
- (void)releaesItemDataWithQueue:(NSInteger)queue{
    for (int i = 0; i < _chartView.sectionModels.count; i ++) {
        if (i == 0) {
            continue;
        }
        ChartSectionModel *sectionModel = _chartView.sectionModels[i];

        for (int j = 0; j < sectionModel.rowModels.count; j ++) {

            ChartRowModel *rowModel = sectionModel.rowModels[j];

            ChartItemModel *itemModel = rowModel.itemModels[queue];
            [itemModel releaseData];
        }
    }
}

//加载第一列数据(参数名)
- (void)loadDataNameList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:[URLFile urlString_mConfig] success:^(id responseObject) {
        for (int i = 0; i <  [responseObject[@"rel"] count]; i ++) {
            NSDictionary *superDict = responseObject[@"rel"][i];

            ChartSectionModel *sectionModel = [[ChartSectionModel alloc] init];
            sectionModel.name = superDict[@"name"];
            int temp = 0;
            if (i == 0) {
                //基本参数数组前两个数据剔除，从第三个开始取值
                temp = 2;
            }
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (int j = temp; j < [superDict[@"paramitems"] count]; j ++) {
                NSDictionary *dict = superDict[@"paramitems"][j];
                ChartRowModel *rowModel = [[ChartRowModel alloc] init];
                rowModel.name = dict[@"name"];

                NSMutableArray *items = [[NSMutableArray alloc] init];
                for (int k = 0; k < 4; k ++) {
                    ChartItemModel *itemModel = [[ChartItemModel alloc] init];
                    [items addObject:itemModel];
                }
                rowModel.itemModels = items;
                [rows addObject:rowModel];
            }

            sectionModel.rowModels = rows;
            [sectionModelArray addObject:sectionModel];
        }
        _chartView.sectionModels = sectionModelArray;
        [_chartView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    //表格头部数据
    NSArray *arr = [[NSArray alloc] initWithObjects:[[TopCollectionViewModel alloc] init],[[TopCollectionViewModel alloc] init],[[TopCollectionViewModel alloc] init],[[TopCollectionViewModel alloc] init], nil];
    [_chartView setTopModels:arr];
}

//加载右侧值列
- (void)loadDataValueListWithSeriesId:(NSString *)seriesId modelId:(NSString *)modeId queue:(NSInteger)queue{
    NSString *url = [NSString stringWithFormat:@"%@&sid=%@&mid=%@",[URLFile urlString_mConfig],seriesId,modeId];
    [HttpRequest GET:url success:^(id responseObject) {
        NSArray *array = responseObject[@"rel"];
//从第二分组开始
        for (int i = 1; i < sectionModelArray.count; i ++) {
            ChartSectionModel *sectionModel = sectionModelArray[i];
            //如果 下标 大于 越界，跳出循环
            if (i-1 > array.count-1) {
                break;
            }

            NSDictionary *dict = array[i-1];
            //
            for (int j = 0; j < sectionModel.rowModels.count; j ++) {

                int temp = 0;
                if (i-1 == 0) {
                    //基本参数数组前两个数据剔除，从第三个开始取值
                    temp = 2;
                }
                if (j+temp > [dict[@"paramitems"] count]-1) {
                    break;
                }
                NSDictionary *rowDict = dict[@"paramitems"][j+temp];
                //如果数组长度为零，跳出循环
                if ([rowDict[@"valueitems"] count] == 0) {
                    break;
                }
                ChartRowModel *rowModel = sectionModel.rowModels[j];

                ChartItemModel *itemModel = rowModel.itemModels[queue];
                NSDictionary *itemDict = rowDict[@"valueitems"][0];
                itemModel.name = [itemDict[@"value"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            }
        }
        _chartView.sectionModels = sectionModelArray;
        [_chartView reloadData];
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//sectionOne概况信息
- (void)loadSectionOneValueListWithBrandId:(NSString *)brandId seriesId:(NSString *)seriesId modelId:(NSString *)modeId queue:(NSInteger)queue{
    if (seriesId == nil) {
        seriesId = @"";
    }
    if (modeId == nil) {
        modeId = @"";
    }
    NSString *url = [NSString stringWithFormat:[URLFile urlString_dbInfo],brandId,seriesId,modeId];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest GET:url success:^(id responseObject) {
        ChartSectionModel *sectionModel = sectionModelArray[0];
        for (int i = 0; i < sectionModel.rowModels.count; i ++) {
            ChartRowModel *rowModel = sectionModel.rowModels[i];
            ChartItemModel *itemModel = rowModel.itemModels[queue];
            if (i == 0) {
                itemModel.name = responseObject[@"CarInfo"];
            }else if (i == 1){
                itemModel.attribute = [weakSelf attributeLeft:responseObject[@"Count"] right:@"条" star:NO];
            }else if (i == 2){
                itemModel.attribute = [weakSelf attributeLeft:responseObject[@"HFL"] right:@"%" star:NO];
            }else if ( i == 3){
                itemModel.attribute = [weakSelf attributeLeft:responseObject[@"AVG"] right:@"星" star:NO];
            }else if (i == 4){
                itemModel.attribute = [weakSelf attribute:responseObject[@"dxgz"]];
            }
            rowModel.cellHeight = (NSInteger)[rowModel getCellHeight];
        }
        _chartView.sectionModels = sectionModelArray;
        [_chartView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSAttributedString *)attributeLeft:(NSString *)left right:(NSString *)right star:(BOOL)start{
    NSString *string = [NSString stringWithFormat:@"%@%@",left,right];
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:string];
    [matt addAttribute:NSForegroundColorAttributeName value:colorOrangeRed range:NSMakeRange(0, left.length)];
    if (start) {
        //[matt insertAttributedString:[[NSAttributedString alloc] initWithString:@"  "] atIndex:0];

        NSTextAttachment *achment = [[NSTextAttachment alloc] init];
        achment.image = [self starIamge:[left floatValue]];
        CGFloat height = 22;
        CGFloat width = achment.image.size.width*(height/achment.image.size.height);
        achment.bounds = CGRectMake(0, -6,width , height);
        [matt insertAttributedString:[NSAttributedString attributedStringWithAttachment:achment] atIndex:0];
    }
    return matt;
}

- (UIImage *)starIamge:(CGFloat)star{
    StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(0, 0, 75, 23)];
    starView.backgroundColor = [UIColor whiteColor];
    [starView setStar:star];
    UIImage *image = [self imageWithView:starView];

    return image;
}

- (UIImage *)imageWithView:(UIView *)view{
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    //设置截屏大小
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (NSAttributedString *)attribute:(NSArray *)arrray{
    if ([arrray isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }

    NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < arrray.count; i ++) {
        NSDictionary *dict = arrray[i];
        [mAtt appendAttributedString:[self textAchment:dict[@"parentTitle"] textColor:[UIColor whiteColor] backColor:RGB_color(172, 92, 158, 1)]];
        [mAtt appendAttributedString:[self blankAttrubute]];
        [mAtt appendAttributedString:[self textAchment:dict[@"title"] textColor:RGB_color(172, 92, 158, 1) backColor:[UIColor whiteColor]]];
        [mAtt appendAttributedString:[self blankAttrubute]];
        [mAtt appendAttributedString:[self textAchment:[NSString stringWithFormat:@"%@个",dict[@"count"]] textColor:colorOrangeRed backColor:[UIColor whiteColor]]];
        if (i < arrray.count - 1) {
            [mAtt appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}]];

        }
    }

    return mAtt;
}

- (NSAttributedString *)blankAttrubute{
    unichar objectReplacementChar           = 0xFFFC;
    NSString *objectReplacementString       = [NSString stringWithCharacters:&objectReplacementChar length:1];
    return [[NSAttributedString alloc] initWithString:objectReplacementString];
}

- (NSAttributedString *)textAchment:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor{

    NSTextAttachment *achment = [[NSTextAttachment alloc] init];
    UIImage *image = [self imageWithView:[self LabelWithText:text textColor:textColor backColor:backColor]];
    achment.image = image;
    achment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);

    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:achment];

    return att;
}



- (UIView *)LabelWithText:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor{

    CZWLabel *label = [[CZWLabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 10)];
    label.textInsets = UIEdgeInsetsMake(1, 3, 1, 3);
    label.textColor = textColor;
    label.backgroundColor = backColor;
    label.font = [UIFont systemFontOfSize:12];
    label.layer.borderColor = RGB_color(172, 92, 158, 1).CGColor;
    label.layer.borderWidth = 1;
    label.text = text;
    [label sizeToFit];

    return label;
}

//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationPortraitUpsideDown;
//}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
