//
//  ZXDetailRecCell.m
//  pzhixin
//
//  Created by zhixin on 2020/1/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXDetailRecCell.h"
#import "ZXDetailRecItemCell.h"
#import <Masonry/Masonry.h>

#define PAGE_WIDTH 15.0

@interface ZXDetailRecCell () <TYCyclePagerViewDelegate, TYCyclePagerViewDataSource>

@property (assign, nonatomic) CGFloat pageWidth;

@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation ZXDetailRecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    return self;
}

#pragma mark - Setter

- (void)setRecommendList:(NSArray *)recommendList {
    _recommendList = recommendList;
    _pageNum = ceil([_recommendList count]/6.0);
    if (_pageNum <= 0) {
        return;
    }
    [self createPageView];
    [_recPagerView reloadData];
}
 
- (void)createPageView {
    if (!_pageView) {
        _pageView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - _pageNum * PAGE_WIDTH)/2.0, ((SCREENWIDTH - 40.0)/3.0 + 65.0) * 2.0 + 54.0 + 9.0, 45.0, 2.0)];
        [_pageView.layer setCornerRadius:1.0];
        [_pageView.layer setMasksToBounds:YES];
        [_pageView setBackgroundColor:[UtilsMacro colorWithHexString:@"D5D9E2"]];
        [_mainView addSubview:_pageView];
    }
    
    _pageWidth = 45.0/_pageNum;
    
    if (!_pageLab) {
        _pageLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, _pageWidth, 2.0)];
        [_pageLab setBackgroundColor:THEME_COLOR];
        [_pageLab.layer setCornerRadius:1.0];
        [_pageLab.layer setMasksToBounds:YES];
        [_pageView addSubview:_pageLab];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_mainView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(44.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setText:@"为你推荐"];
        [_titleLab setTextColor:COLOR_666666];
        [_titleLab setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"ECECEA"]];
        [_titleView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.0);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    if (!_recPagerView) {
        _recPagerView = [[TYCyclePagerView alloc] init];
        _recPagerView.isInfiniteLoop = YES;
        _recPagerView.delegate = self;
        _recPagerView.dataSource = self;
        [_recPagerView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDetailRecItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXDetailRecItemCell"];
        [_mainView addSubview:_recPagerView];
        [_recPagerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.titleView.mas_bottom);
            make.bottom.mas_equalTo(-20.0);
        }];
    }
}

#pragma mark - TYCyclePagerViewDelegate && TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _pageNum;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    ZXDetailRecItemCell *itemCell = [pagerView dequeueReusableCellWithReuseIdentifier:@"ZXDetailRecItemCell" forIndex:index];
    [itemCell setTag:index];
    [itemCell setRecommendList:_recommendList];
    itemCell.zxDetailRecItemCellDidSelectCollectionViewCell = ^(NSIndexPath * _Nonnull indexPath, ZXGoods * _Nonnull goods) {
        if (self.zxDetailRecCellDidSelectCollectionViewCell) {
            self.zxDetailRecCellDidSelectCollectionViewCell(indexPath, goods);
        }
    };
    return itemCell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, ((SCREENWIDTH - 40.0)/3.0 + 70.0) * 2.0);
    layout.itemSpacing = 0.0;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [UIView animateWithDuration:0.2 animations:^{
        [self.pageLab setFrame:CGRectMake(toIndex * self.pageWidth, 0.0, self.pageWidth, 2.0)];
    }];
}

@end
