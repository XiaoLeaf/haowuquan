//
//  ZXHomeHeadLineCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeHeadLineCell.h"

@interface ZXHomeHeadLineCell () <SGAdvertScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@end

@implementation ZXHomeHeadLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mainView.layer setCornerRadius:5.0];
    [self setBackgroundColor:BG_COLOR];
    
    UITapGestureRecognizer *tapFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
    [self.firstSpecial addGestureRecognizer:tapFirst];
    
    UITapGestureRecognizer *tapSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
    [self.secondSpecial addGestureRecognizer:tapSecond];
    
    UITapGestureRecognizer *tapThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
    [self.thirdSpecial addGestureRecognizer:tapThird];
    
    UITapGestureRecognizer *tapFouth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpecialImgAction:)];
    [self.fouthSpecial addGestureRecognizer:tapFouth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setNotices:(NSArray *)notices {
    if (_wordScrollView) {
        [_wordScrollView removeFromSuperview];
        _wordScrollView = nil;
    }
    _wordScrollView = [[SGAdvertScrollView alloc] initWithFrame:CGRectMake(_headerImg.frame.origin.x + _headerImg.frame.size.width, 0.0, _headerView.frame.size.width - _headerImg.frame.origin.x - _headerImg.frame.size.width, _headerView.frame.size.height - 1.0)];
    [_wordScrollView setDelegate:self];
    [_wordScrollView setBackgroundColor:[UIColor whiteColor]];
    [_headerView addSubview:_wordScrollView];
    _notices = notices;
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
    [self.wordScrollView setSignImages:signs];
    [self.wordScrollView setTitles:titles];
}

- (void)setMain_ads:(NSArray *)main_ads {
    _main_ads = main_ads;
    ZXHomeSlides *firstAd = (ZXHomeSlides *)[_main_ads objectAtIndex:0];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:firstAd.img] imageView:_firstSpecial placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.firstSpecial setContentMode:UIViewContentModeScaleAspectFill];
        });
    }];
    
    ZXHomeSlides *secondAd = (ZXHomeSlides *)[_main_ads objectAtIndex:1];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:secondAd.img] imageView:_secondSpecial placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [self.secondSpecial setContentMode:UIViewContentModeScaleAspectFill];
    }];
    
    ZXHomeSlides *thirdAd = (ZXHomeSlides *)[_main_ads objectAtIndex:2];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:thirdAd.img] imageView:_thirdSpecial placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [self.thirdSpecial setContentMode:UIViewContentModeScaleAspectFill];
    }];
    
    ZXHomeSlides *fouthAd = (ZXHomeSlides *)[_main_ads objectAtIndex:3];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:fouthAd.img] imageView:_fouthSpecial placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [self.fouthSpecial setContentMode:UIViewContentModeScaleAspectFill];
    }];
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapSpecialImgAction:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *tapView = gestureRecognizer.view;
    if (self.zxHomeHeadLineCellImgClick) {
        self.zxHomeHeadLineCellImgClick(tapView.tag);
    }
}

#pragma mark - SGAdvertScrollViewDelegate

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    if (self.zxHomeHeadLineCellAdvertDidSelected) {
        self.zxHomeHeadLineCellAdvertDidSelected(index);
    }
}

@end
