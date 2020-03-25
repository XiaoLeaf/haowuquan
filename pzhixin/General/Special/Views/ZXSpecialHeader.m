//
//  ZXSpecialHeader.m
//  pzhixin
//
//  Created by zhixin on 2019/11/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXSpecialHeader.h"
#import <Masonry/Masonry.h>
#import "ZXSpecialHeaderCell.h"

@interface ZXSpecialHeader () <TYCyclePagerViewDelegate, TYCyclePagerViewDataSource>

@property (strong, nonatomic) TYCyclePagerView *specialCycle;

@end

@implementation ZXSpecialHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSpecialBanner];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createSpecialBanner {
    if (!_specialCycle) {
        _specialCycle = [[TYCyclePagerView alloc] init];
        [_specialCycle.layer setCornerRadius:5.0];
        [_specialCycle setClipsToBounds:YES];
        _specialCycle.delegate = self;
        _specialCycle.dataSource = self;
        _specialCycle.autoScrollInterval = 3.0;
        _specialCycle.isInfiniteLoop = YES;
        [_specialCycle registerClass:[ZXSpecialHeaderCell class] forCellWithReuseIdentifier:@"ZXSpecialHeaderCell"];
        [self addSubview:_specialCycle];
        [_specialCycle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5.0);
            make.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(5.0);
            make.right.mas_equalTo(-5.0);
        }];
    }
}

#pragma mark - TYCyclePagerViewDelegate && TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _imgList.count;
}

- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    ZXSpecialHeaderCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"ZXSpecialHeaderCell" forIndex:index];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:index]] imageView:cell.bannerImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    [layout setItemSize:CGSizeMake(SCREENWIDTH - 10.0, (SCREENWIDTH - 10.0) * 0.4 + 5.0)];
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.zxSpecialHeaderBannerClick) {
        self.zxSpecialHeaderBannerClick(index);
    }
}

@end
