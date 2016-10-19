//
//  FindCollectionViewController.m
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "FindCollectionViewController.h"
#import "FindCollectionViewCell.h"
#import "FindModel.h"

@interface FindCollectionViewController ()
{
    NSArray *_dataArray;
}
@end

@implementation FindCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

+ (instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
    layout.itemSize = CGSizeMake(WIDTH/3, WIDTH/3);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    return [[FindCollectionViewController alloc] initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[FindCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    [self setData];
    // Do any additional setup after loading the view.
}

- (void)setData{
    _dataArray = @[
                  [[FindModel alloc] initWithTitle:@"新闻" imageName:@"论坛" aClass:@"NewsViewController"],
                  [[FindModel alloc] initWithTitle:@"投诉" imageName:@"论坛" aClass:@"ComplainListViewController"],
                  [[FindModel alloc] initWithTitle:@"调查" imageName:@"论坛" aClass:@"NewsInvestigateViewController"],
                  [[FindModel alloc] initWithTitle:@"答疑" imageName:@"论坛" aClass:@"AnswerViewController"],
                  [[FindModel alloc] initWithTitle:@"排行榜" imageName:@"论坛" aClass:@"ComplainChartViewController"],
                  [[FindModel alloc] initWithTitle:@"找车" imageName:@"论坛" aClass:@"VehicleImageViewController"],
                  [[FindModel alloc] initWithTitle:@"车型对比" imageName:@"论坛" aClass:@"ContrastChartViewController"],
                  [[FindModel alloc] initWithTitle:@"口碑" imageName:@"论坛" aClass:@""],
                  [[FindModel alloc] initWithTitle:@"论坛" imageName:@"论坛" aClass:@"ForumClassifyListViewController"],
                   ];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    FindModel *model = _dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    cell.titleLabel.text = model.title;
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FindModel *model = _dataArray[indexPath.row];
    UIViewController *VC = [[NSClassFromString(model.aClass) alloc] init];
    if ([VC isKindOfClass:[UIViewController class]] == NO) {
        return;
    }
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
