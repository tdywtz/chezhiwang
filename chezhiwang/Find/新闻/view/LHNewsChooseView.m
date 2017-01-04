//
//  LHNewsChooseView.m
//  chezhiwang
//
//  Created by bangong on 16/10/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHNewsChooseView.h"

#pragma mark - model
@interface LHNewsChooseModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ID;

+ (instancetype)initWithTitle:(NSString *)title ID:(NSString *)ID;
@end

@implementation LHNewsChooseModel

+ (instancetype)initWithTitle:(NSString *)title ID:(NSString *)ID{
    LHNewsChooseModel *model = [[LHNewsChooseModel alloc] init];
    model.title = title;
    model.ID = ID;
    return model;
}
@end

#pragma mark - cell
@interface LHNewsChooseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation LHNewsChooseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = colorBlack;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.cornerRadius = 3;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = colorLightBlue.CGColor;
        [self.contentView addSubview:_titleLabel];

        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}


@end

#pragma mark - chooseView
@interface LHNewsChooseView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSArray *_dadaArray;
}
@end


@implementation LHNewsChooseView

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = RGB_color(0, 0, 0, 0.5);

        [self makeUI:frame];
        [self createData];
        [_collectionView reloadData];
    }
    return self;
}

- (void)createData{
    _dadaArray = @[
                   [LHNewsChooseModel initWithTitle:@"全部" ID:@"0"],
                   [LHNewsChooseModel initWithTitle:@"行业" ID:@"1"],
                   [LHNewsChooseModel initWithTitle:@"新车" ID:@"5"],
                   [LHNewsChooseModel initWithTitle:@"谍照" ID:@"14"],
                   [LHNewsChooseModel initWithTitle:@"评测" ID:@"4"],
                   [LHNewsChooseModel initWithTitle:@"导购" ID:@"15"],
                   [LHNewsChooseModel initWithTitle:@"召回" ID:@"2"],
                   [LHNewsChooseModel initWithTitle:@"用车" ID:@"13"],
                   [LHNewsChooseModel initWithTitle:@"零部件" ID:@"6"],
                   [LHNewsChooseModel initWithTitle:@"缺陷报道" ID:@"9"],
                   [LHNewsChooseModel initWithTitle:@"分析报告" ID:@"16"],
                   [LHNewsChooseModel initWithTitle:@"投诉销量比" ID:@"17"],
                   [LHNewsChooseModel initWithTitle:@"可靠性调查" ID:@"18"],
                   [LHNewsChooseModel initWithTitle:@"满意度调查" ID:@"19"]
                   ];
}

- (void)makeUI:(CGRect)frame{

    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = colorBlack;
    label.text = @"切换内容";
    label.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 1)];
    lineView.backgroundColor = colorBackGround;
    [self addSubview:lineView];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(WIDTH-40, 0, 40, 40);
    [cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [cancelButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 41, WIDTH, 0) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];

    [_collectionView registerClass:[LHNewsChooseCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)cancelClick{
    [self dismiss];
}

- (void)show{
    self.hidden = NO;
    CGRect frame = _collectionView.frame;
    frame.size.height = _collectionView.contentSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.frame = frame;
        self.alpha = 1.0;
    }];
}

- (void)dismiss{
    CGRect frame = _collectionView.frame;
    frame.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.frame = frame;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dadaArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LHNewsChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    LHNewsChooseModel *model = _dadaArray[indexPath.row];
    cell.titleLabel.text = model.title;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(clickItem:)]) {
        [self.delegate clickItem:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat space = 20;
    if (WIDTH == 320) {
        space = 15;
    }
    if (indexPath.row < 11) {
        return CGSizeMake((WIDTH-space*5)/4, 40);
    }
    return CGSizeMake((WIDTH-space*4)/3, 40);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
