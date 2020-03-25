//
//  ZXNewHomeHeadLineCell.m
//  pzhixin
//
//  Created by zhixin on 2019/12/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewHomeHeadLineCell.h"
#import "SGAdvertScrollView.h"
#import <Masonry/Masonry.h>

@interface ZXNewHomeHeadLineCell () <SGAdvertScrollViewDelegate>

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIImageView *headerImg;

@property (strong, nonatomic) SGAdvertScrollView *headlineScroll;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *firstImg;

@property (strong, nonatomic) UIImageView *secondImg;

@property (strong, nonatomic) UIImageView *thirdImg;

@property (strong, nonatomic) UIImageView *fouthImg;

@end

@implementation ZXNewHomeHeadLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BG_COLOR;
        [self createSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.0);
        make.left.mas_equalTo(5.0);
        make.right.mas_equalTo(-5.0);
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(40.0);
    }];

    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(90.0);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    if (_headlineScroll) {
        [_headlineScroll removeFromSuperview];
    }
    _headlineScroll = [[SGAdvertScrollView alloc] init];
    [_headlineScroll setDelegate:self];
    _headlineScroll.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_headlineScroll];
    [_headlineScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImg.mas_right);
        make.top.mas_equalTo(0.0);
        make.bottom.mas_equalTo(-1.0);
        make.right.mas_equalTo(-10.0);
    }];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *signs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_notices count]; i++) {
        ZXHomeNotice *homeNotice = (ZXHomeNotice *)[_notices objectAtIndex:i];
        [titles addObject:homeNotice.name];
        if ([homeNotice.is_new integerValue] == 1) {
            [signs addObject:@"ic_newest_flag"];
        } else {
            [signs addObject:@""];
        }
    }
    [self.headlineScroll setSignImages:signs];
    [self.headlineScroll setTitles:titles];

    [_secondImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0.0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.width.mas_equalTo((SCREENWIDTH - 10.0)/3.0);
    }];

    [_firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo((SCREENWIDTH - 10.0)/3.0);
        make.right.mas_equalTo(self.secondImg.mas_left);
    }];

    [_thirdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(0.0);
        make.top.mas_equalTo(self.firstImg.mas_bottom);
        make.width.mas_equalTo((SCREENWIDTH - 10.0)/3.0);
    }];

    [_fouthImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstImg.mas_bottom);
        make.left.mas_equalTo(self.thirdImg.mas_right);
        make.right.mas_equalTo(self.secondImg.mas_left);
        make.bottom.mas_equalTo(0.0);
    }];
}

#pragma mark - Setter

- (void)setNotices:(NSArray *)notices {
    _notices = notices;
}

- (void)setMain_ads:(NSArray *)main_ads {
    _main_ads = main_ads;
    if (_main_ads.count > 0) {
        ZXHomeSlides *firstAd = (ZXHomeSlides *)[_main_ads objectAtIndex:0];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:firstAd.img] imageView:_firstImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    }
    
    if (_main_ads.count > 1) {
        ZXHomeSlides *secondAd = (ZXHomeSlides *)[_main_ads objectAtIndex:1];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:secondAd.img] imageView:_secondImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    }
    
    if (_main_ads.count > 2) {
        ZXHomeSlides *thirdAd = (ZXHomeSlides *)[_main_ads objectAtIndex:2];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:thirdAd.img] imageView:_thirdImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    }
    
    if (_main_ads.count > 3) {
        ZXHomeSlides *fouthAd = (ZXHomeSlides *)[_main_ads objectAtIndex:3];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:fouthAd.img] imageView:_fouthImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    }
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.clipsToBounds = YES;
        _mainView.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_mainView];
    }
    
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        [_mainView addSubview:_headerView];
    }
    
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_spend_headline.png"]];
        [_headerImg setContentMode:UIViewContentModeCenter];
        [_headerView addSubview:_headerImg];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UtilsMacro colorWithHexString:@"ECECEA"];
        [_headerView addSubview:_lineView];
    }
    
    if (!_secondImg) {
        _secondImg = [[UIImageView alloc] init];
        [_secondImg setClipsToBounds:YES];
        [_secondImg setContentMode:UIViewContentModeScaleAspectFit];
        [_secondImg setTag:1];
        UITapGestureRecognizer *tapSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
        [_secondImg addGestureRecognizer:tapSecond];
        [_mainView addSubview:_secondImg];
    }
    
    if (!_firstImg) {
        _firstImg = [[UIImageView alloc] init];
        [_firstImg setClipsToBounds:YES];
        [_firstImg setContentMode:UIViewContentModeScaleAspectFit];
        [_firstImg setTag:0];
        UITapGestureRecognizer *tapFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
        [_firstImg addGestureRecognizer:tapFirst];
        [_mainView addSubview:_firstImg];
    }
    
    if (!_thirdImg) {
        _thirdImg = [[UIImageView alloc] init];
        [_thirdImg setClipsToBounds:YES];
        [_thirdImg setContentMode:UIViewContentModeScaleAspectFit];
        [_thirdImg setTag:2];
        UITapGestureRecognizer *tapThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
        [_thirdImg addGestureRecognizer:tapThird];
        [_mainView addSubview:_thirdImg];
    }
    
    if (!_fouthImg) {
        _fouthImg = [[UIImageView alloc] init];
        [_fouthImg setClipsToBounds:YES];
        [_fouthImg setContentMode:UIViewContentModeScaleAspectFit];
        [_fouthImg setTag:3];
        UITapGestureRecognizer *tapFouth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
        [_fouthImg addGestureRecognizer:tapFouth];
        [_mainView addSubview:_fouthImg];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapSpecialImgAction:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *tapView = gestureRecognizer.view;
    if (self.zxNewHomeHeadLineCellImgClick) {
        self.zxNewHomeHeadLineCellImgClick(tapView.tag);
    }
}

#pragma mark - SGAdvertScrollViewDelegate

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    if (self.zxNewHomeHeadLineCellAdvertDidSelected) {
        self.zxNewHomeHeadLineCellAdvertDidSelected(index);
    }
}

@end
