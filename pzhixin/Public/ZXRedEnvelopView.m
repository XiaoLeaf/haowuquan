//
//  ZXRedEnvelopView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/16.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRedEnvelopView.h"
#import <Masonry/Masonry.h>

@interface ZXRedEnvelopView ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIImageView *redBgImg;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *countLab;

@property (strong, nonatomic) UILabel *tipLab;

@property (strong, nonatomic) UIButton *fetchBtn;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UITapGestureRecognizer *tapView;

@end

@implementation ZXRedEnvelopView

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

- (void)setRedEnvelop:(ZXRedEnvelop *)redEnvelop {
    _redEnvelop = redEnvelop;
    switch ([_redEnvelop.type integerValue]) {
        case 1:
        case 2:
        {
            [_fetchBtn setHidden:NO];
            [self removeGestureRecognizer:_tapView];
            [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(305.0);
            }];
        }
            break;
        case 3:
        {
            [_fetchBtn setHidden:YES];
            _tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMainViewAction)];
            [_mainView addGestureRecognizer:_tapView];
            [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(305.0);
            }];
        }
            break;
        case 4:
        {
            [_fetchBtn setHidden:YES];
            _tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMainViewAction)];
            [_mainView addGestureRecognizer:_tapView];
            [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(305.0).priorityLow();
            }];
        }
            break;
            
        default:
            break;
    }
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_redEnvelop.bg] imageView:_redBgImg placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"image:%@",image);
        if ([self.redEnvelop.type integerValue] == 4) {
            [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SCREENWIDTH * image.size.height / image.size.width);
            }];
        } else {
            [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(305.0);
            }];
        }
        if (self.zxRedEnvelopViewBgImgComplete) {
            self.zxRedEnvelopViewBgImgComplete();
        }
    }];
    if (![UtilsMacro whetherIsEmptyWithObject:_redEnvelop.btn.txt]) {
        [_fetchBtn setTitle:_redEnvelop.btn.txt forState:UIControlStateNormal];
    }
    if (![UtilsMacro whetherIsEmptyWithObject:_redEnvelop.btn.color]) {
        [_fetchBtn setTitleColor:[UtilsMacro colorWithHexString:_redEnvelop.btn.color] forState:UIControlStateNormal];
    }
    if (![UtilsMacro whetherIsEmptyWithObject:_redEnvelop.btn.bg]) {
        [_fetchBtn setBackgroundColor:[UtilsMacro colorWithHexString:_redEnvelop.btn.bg]];
    }
    
    if ([UtilsMacro whetherIsEmptyWithObject:_redEnvelop.txt.title]) {
        [_titleLab setHidden:YES];
        [_titleLab setText:@""];
    } else {
        [_titleLab setHidden:NO];
        [_titleLab setText:_redEnvelop.txt.title];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_redEnvelop.txt.amount]) {
        [_countLab setHidden:YES];
        [_countLab setText:@""];
    } else {
        [_countLab setHidden:NO];
        [_countLab setText:_redEnvelop.txt.amount];
    }
    if ([UtilsMacro whetherIsEmptyWithObject:_redEnvelop.txt.desc]) {
        [_tipLab setHidden:YES];
        [_tipLab setText:@""];
    } else {
        [_tipLab setHidden:NO];
        [_tipLab setText:_redEnvelop.txt.desc];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.center.mas_equalTo(self);
        }];
    }
    
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_containerView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(305.0).priorityLow();
            make.top.left.right.mas_equalTo(0.0);
        }];
    }
    
    if (!_redBgImg) {
        _redBgImg = [[UIImageView alloc] init];
        [_redBgImg setContentMode:UIViewContentModeScaleAspectFit];
        [_mainView addSubview:_redBgImg];
        [_redBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0.0);
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleLab setText:@"恭喜，您已获得新人红包"];
        [_titleLab setTextColor:[UtilsMacro colorWithHexString:@"D1321E"]];
        [_titleLab setFont:[UIFont systemFontOfSize:15.0]];
        [_titleLab setHidden:YES];
        [_mainView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(50.0);
            make.height.mas_equalTo(15.0);
        }];
    }
    
    if (!_countLab) {
        _countLab = [[UILabel alloc] init];
        [_countLab setTextAlignment:NSTextAlignmentCenter];
        [_countLab setTextColor:[UtilsMacro colorWithHexString:@"D1321E"]];
        [_countLab setFont:[UIFont systemFontOfSize:45.0 weight:UIFontWeightMedium]];
        [_countLab setText:@"0.88"];
        [_countLab setHidden:YES];
        [_mainView addSubview:_countLab];
        [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(20.0);
            make.height.mas_equalTo(35.0);
        }];
    }
    
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        [_tipLab setTextAlignment:NSTextAlignmentCenter];
        [_tipLab setText:@"已到账"];
        [_tipLab setTextColor:[UtilsMacro colorWithHexString:@"D1321E"]];
        [_tipLab setFont:[UIFont systemFontOfSize:12.0]];
        [_tipLab setHidden:YES];
        [_mainView addSubview:_tipLab];
        [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.countLab.mas_bottom).mas_offset(15.0);
            make.height.mas_equalTo(12.0);
        }];
    }
    
    if (!_fetchBtn) {
        _fetchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        [_fetchBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"FFCC00"]];
        [_fetchBtn setTitleColor:[UtilsMacro colorWithHexString:@"A03900"] forState:UIControlStateNormal];
        [_fetchBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_fetchBtn.layer setCornerRadius:3.0];
        [_fetchBtn setTag:0];
        [_fetchBtn addTarget:self action:@selector(handleTapRedEnvelopViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_fetchBtn];
        [_fetchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-44.0);
            make.width.mas_equalTo(SCREENWIDTH * 160.0 / 375.0);
            make.height.mas_equalTo(40.0);
            make.centerX.mas_equalTo(self.mainView);
        }];
    }
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ic_home_toast_close"] forState:UIControlStateNormal];
        [_closeBtn setTag:1];
        [_closeBtn addTarget:self action:@selector(handleTapRedEnvelopViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainView.mas_bottom).mas_equalTo(30.0);
            make.width.height.mas_equalTo(40.0);
            make.centerX.mas_equalTo(self.containerView);
            make.bottom.mas_equalTo(0.0).priorityHigh();
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapRedEnvelopViewBtnAction:(UIButton *)btn {
    if (self.zxRedEnvelopViewBtnClick) {
        self.zxRedEnvelopViewBtnClick(btn.tag);
    }
}

- (void)handleTapMainViewAction {
    if (self.zxRedEnvelopViewBtnClick) {
        self.zxRedEnvelopViewBtnClick(999);
    }
}

@end
