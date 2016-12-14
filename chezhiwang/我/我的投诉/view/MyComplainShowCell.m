
//
//  MyComplainShowCell.m
//  chezhiwang
//
//  Created by bangong on 16/6/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyComplainShowCell.h"
#import "MyComplainViewController.h"
#import "MyComplainDetailsViewController.h"
#import "ComplainViewController.h"
#import "MyComplainHeaderView.h"
#import "ComplainDrawView.h"

@implementation MyComplainShowCell
{
    UILabel *stateLabel;
    MyComplainHeaderView *headerView;
    ComplainDrawView *stepView;
    ButtonView *btnView;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = RGB_color(240, 240, 240, 1);
        //创建UI
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{

    stateLabel = [[UILabel alloc] init];
    stateLabel.textColor = colorBlack;
    stateLabel.font = [UIFont systemFontOfSize:15];
    stateLabel.numberOfLines = 0;

    headerView = [[MyComplainHeaderView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor clearColor];

    stepView = [[ComplainDrawView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];

    btnView = [[ButtonView alloc] init];

    __weak __typeof(self)weakSelf = self;
    btnView.click = ^(NSString *title){
       
       __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([title isEqualToString:@"查看详情"]) {
            MyComplainDetailsViewController *cp = [[MyComplainDetailsViewController alloc] init];
            cp.Cpid = weakSelf.model.Cpid;
            [strongSelf.parentController.navigationController pushViewController:cp animated:YES];
        }else{
            ComplainViewController *complain = [[ComplainViewController alloc] init];
            complain.siChange = YES;
            complain.Cpid = strongSelf.model.Cpid;
            if ([title isEqualToString:@"再次投诉"]) {
                complain.again = YES;
            }
            [strongSelf.parentController.navigationController pushViewController:complain animated:YES];
        }
    };

    [self.contentView addSubview:stateLabel];
    [self.contentView addSubview:stepView];
    [self.contentView addSubview:headerView];
    [self.contentView addSubview:btnView];


    [stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.right.equalTo(-10);
    }];

    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(stateLabel.bottom).offset(10);
        make.right.equalTo(-10);
        make.height.equalTo(42);
    }];

    [stepView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(headerView.bottom).offset(15);
        make.right.equalTo(0);
    }];
    
    [btnView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(stepView.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(MyComplainModel *)model{
    _model = model;
    
    NSString *text = [NSString stringWithFormat:@"当前投诉状态：%@",model.status];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:model.status];
    if (range.length) {
        [att setLh_colorWithColor:RGB_color(237, 27, 36, 1) range:range];
    }

    stateLabel.attributedText = att;

    [stepView setSteps:model.steps];
    headerView.current = [model.stepid integerValue];

    if ([model.show integerValue] == 2) {
         btnView.titles = @[@"查看详情",@"修  改"];
    }else{
         btnView.titles = @[@"查看详情"];
    }


    [stepView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(stepView.lh_height);
    }];

    [btnView updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(btnView.bounds.size);
    }];
}

@end
