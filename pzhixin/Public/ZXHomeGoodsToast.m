//
//  ZXHomeGoodsToast.m
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXHomeGoodsToast.h"
#import <Masonry/Masonry.h>

@interface ZXHomeGoodsToast ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation ZXHomeGoodsToast

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
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.74]];
        [self createSubviews];
    }
    return self;
}

#pragma mark - Setter

- (void)setImgUrl:(NSString *)imgUrl {
    _imgUrl = imgUrl;
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_imgUrl] imageView:_imgView placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.left.mas_equalTo(0.0);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0.0);
        }];
    }
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        [_imgView setClipsToBounds:YES];
        [_imgView setUserInteractionEnabled:YES];
        [_imgView setTag:0];
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImgViewAction)];
        [_imgView addGestureRecognizer:tapImg];
        [_mainView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn setTag:1];
        [_closeBtn addTarget:self action:@selector(handleTapInviteViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_equalTo(30.0);
            make.width.height.mas_equalTo(40.0);
            make.centerX.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
}

#pragma mark - Actions

- (void)handleTapImgViewAction {
    if (self.zxHomeGoodsToastBtnClick) {
        self.zxHomeGoodsToastBtnClick(0);
    }
}

- (void)handleTapInviteViewBtnAction:(UIButton *)btn {
    if (self.zxHomeGoodsToastBtnClick) {
        self.zxHomeGoodsToastBtnClick(btn.tag);
    }
}

@end
