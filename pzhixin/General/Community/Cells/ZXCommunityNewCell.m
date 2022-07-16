//
//  ZXCommunityNewCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommunityNewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZXCommunityImgCell.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <UICollectionViewLeftAlignedLayout/UICollectionViewLeftAlignedLayout.h>
#import "ZXCommunityCommentsCell.h"

#define IMG_IDENTIFIER @"ZXCommunityImgCell"

@interface ZXCommunityNewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource> {
    NSArray *imgList;
}

@property (strong, nonatomic) UIView *imgContainer;

@property (strong, nonatomic) UIImageView *singleImg;

@property (strong, nonatomic) UIButton *detailBtn;

@property (strong, nonatomic) UIView *goodsView;

@property (strong, nonatomic) UIView *goodsContent;

@property (strong, nonatomic) UIImageView *goodsImg;

@property (strong, nonatomic) ZXLabel *goodsTitleLab;

@property (strong, nonatomic) UILabel *oriLab;

@property (strong, nonatomic) UILabel *curLab;

@property (strong, nonatomic) UILabel *commissionLab;

@property (strong, nonatomic) UILabel *couponLab;

@property (assign, nonatomic) NSInteger saveIndex;

@property (strong, nonatomic) NSMutableArray *commentList;

@end

@implementation ZXCommunityNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    [self setBackgroundColor:COLOR_F1F1F1];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_couponLab setNeedsLayout];
    [_couponLab layoutIfNeeded];
    [_commissionLab setNeedsLayout];
    [_commissionLab layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_couponLab.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _couponLab.bounds;
    maskLayer.path = maskPath.CGPath;
    _couponLab.layer.mask = maskLayer;
    //
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_commissionLab.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4.0, 4.0)];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = _commissionLab.bounds;
    maskLayer1.path = maskPath1.CGPath;
    _commissionLab.layer.mask = maskLayer1;
}

#pragma mark - Setter

- (void)setCommunity:(ZXCommunity *)community {
    _community = community;
    
    NSString *content = _community.content;
    if (![UtilsMacro whetherIsEmptyWithObject:content]) {
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:content];
        [contentStr addAttributes:[UtilsMacro contentAttributes] range:NSMakeRange(0, content.length)];
        [_contentLabel setAttributedText:contentStr];
    }
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_community.author.img]] placeholderImage:nil];
    [_nameLabel setText:[NSString stringWithFormat:@"%@",_community.author.name]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",_community.s_time]];
    [_shareBtn setTitle:[NSString stringWithFormat:@"%@",_community.share_times] forState:UIControlStateNormal];
    
    [_shareBtn setNeedsLayout];
    [_shareBtn layoutIfNeeded];
    //设置渐变色背景
    CAGradientLayer *gradinentLayer = [CAGradientLayer layer];
    [gradinentLayer setColors:@[(__bridge id)[UtilsMacro colorWithHexString:@"FF5100"].CGColor, (__bridge id)[UtilsMacro colorWithHexString:@"FF8B00"].CGColor]];
    [gradinentLayer setLocations:@[@0.0, @1.0]];
    [gradinentLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradinentLayer setEndPoint:CGPointMake(1.0, 0.0)];
    [gradinentLayer setFrame:CGRectMake(0.0, 0.0, _shareBtn.frame.size.width, 20.0)];
    [gradinentLayer setCornerRadius:10.0];
    [gradinentLayer setMasksToBounds:YES];
    [_shareBtn.layer addSublayer:gradinentLayer];
    [_shareBtn bringSubviewToFront:_shareBtn.imageView];
    [_shareBtn bringSubviewToFront:_shareBtn.titleLabel];
    
    if ([UtilsMacro whetherIsEmptyWithObject:_community.detail.txt]) {
        [_detailBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_contentLabel.mas_bottom).mas_offset(0.0);
            make.height.mas_equalTo(0.0);
        }];
        [_detailBtn setTitle:@"" forState:UIControlStateNormal];
        [_detailBtn setImage:nil forState:UIControlStateNormal];
    } else {
        [_detailBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_contentLabel.mas_bottom).mas_offset(5.0);
            make.height.mas_equalTo(20.0);
        }];
        [_detailBtn setTitle:_community.detail.txt forState:UIControlStateNormal];
        [_detailBtn setImage:[UIImage imageNamed:@"ic_community_link"] forState:UIControlStateNormal];
    }
    
    imgList = [[NSArray alloc] initWithArray:_community.imgs];
    if ([imgList count] == 1) {
        if ([[_community.first_img_wh objectAtIndex:0] integerValue] > SCREENWIDTH - 80.0) {
            [self.imgContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self->_detailBtn.mas_bottom).offset(10.0);
                make.left.mas_equalTo(60.0);
                make.width.mas_equalTo(200.0);
                make.height.mas_equalTo(200.0 * [[_community.first_img_wh objectAtIndex:1] integerValue] / [[_community.first_img_wh objectAtIndex:0] integerValue]);
            }];
            [self.singleImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_equalTo(0.0);
            }];
            [self.imgCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0.0);
                make.height.mas_equalTo(0.0);
            }];
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:0]] imageView:_singleImg placeholderImage:nil options:0 progress:nil completed:nil];
        } else {
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:0]] imageView:_singleImg placeholderImage:nil options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self.itemSize = CGSizeMake(image.size.width, image.size.height);
                [self.imgContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.itemSize.height);
                }];
                [self.singleImg mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.mas_equalTo(0.0);
                    make.width.mas_equalTo(self.itemSize.width);
                }];
                [self.imgCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0.0);
                    make.height.mas_equalTo(0.0);
                }];
                if (!self.singleBlocked && self.zxCommunitySingleImgComplete) {
                    self.singleBlocked = !self.singleBlocked;
                    self.zxCommunitySingleImgComplete(self.indexPath);
                }
            }];
        }
    } else {
        [self.singleImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0.0);
            make.width.mas_equalTo(0.0);
            make.height.mas_equalTo(0.0);
        }];
        switch ([imgList count]) {
            case 2:
            {
                [self.imgContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 93.0)/2.0);
                }];
                [_imgCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 93.0)/2.0);
                }];
            }
                break;
            case 3:
            {
                [self.imgContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 96.0)/3.0);
                }];
                [_imgCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 96.0)/3.0);
                }];
            }
                break;
            case 4:
            {
                [self.imgContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 93.0)/2.0 * 2.0);
                }];
                [self.imgCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.bottom.mas_equalTo(0.0);
                }];
            }
                break;
            case 5:
            case 6:
            {
                [self.imgContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 96.0)/3.0 * 2.0);
                }];
                [_imgCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 96.0)/3.0 * 2.0);
                }];
            }
                break;
            case 7:
            case 8:
            case 9:
            {
                [self.imgContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 96.0)/3.0 * 3.0);
                }];
                [_imgCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((SCREENWIDTH - 96.0)/3.0 * 3.0);
                }];
            }
                break;
                

            default:
                break;
        }
        [_imgCollectionView reloadData];
    }
    
    //商品item的是否展示
    if ([_community.type integerValue] == 1) {
        [_goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgContainer.mas_bottom).offset(10.0);
            make.height.mas_equalTo(80.0);
        }];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_community.grow.cover] imageView:_goodsImg placeholderImage:nil options:0 progress:nil completed:nil];
        
        if (![UtilsMacro whetherIsEmptyWithObject:_community.grow.title]) {
            NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",_community.grow.title]]];
            YYAnimatedImageView *imageView;
            if ([_community.grow.shop_type integerValue] == 1) {
                imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"tmall_flag"]];
            } else if ([_community.grow.shop_type integerValue] == 2) {
                imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"taobao_flag"]];
            }
            [imageView setFrame:CGRectMake(0.0, 0.0, 25.0, 14.0)];
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:13.0] alignment:YYTextVerticalAlignmentCenter];
            [nameAttri insertAttributedString:attachText atIndex:0];
            [_goodsTitleLab setAttributedText:nameAttri];
        }
        
        if (![UtilsMacro whetherIsEmptyWithObject:_community.grow.price]) {
            NSString *current = [NSString stringWithFormat:@"￥%@", _community.grow.price];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:current];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(0, 1)];
            [attri addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:NSMakeRange(1, current.length - 1)];
            [_curLab setAttributedText:attri];
        }
        
        if (![UtilsMacro whetherIsEmptyWithObject:_community.grow.ori_price]) {
            NSString *originalStr = [NSString stringWithFormat:@"￥%@",_community.grow.ori_price];
            NSMutableAttributedString *originalAttri = [[NSMutableAttributedString alloc] initWithString:originalStr];
            [originalAttri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:NSMakeRange(0, originalStr.length)];
            [_oriLab setText:originalStr];
        }
        
        if ([_community.grow.coupon_amount integerValue] == 0 || [_community.grow.coupon_amount isEqualToString:@""]) {
            [_couponLab setText:@""];
            [_commissionLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.couponLab.mas_right).offset(0.0);
            }];
        } else {
            [_commissionLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.couponLab.mas_right).offset(5.0);
            }];
            [_couponLab setText:[NSString stringWithFormat:@" 劵 %@元  ", _community.grow.coupon_amount]];
        }
        [_commissionLab setText:[NSString stringWithFormat:@" 奖 %@  ", _community.grow.commission]];
    } else {
        [_goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgContainer.mas_bottom).offset(0.0);
            make.height.mas_equalTo(0.0);
        }];
    }
    
    //计算commentTableView的高度
    if (_commentView.frame.size.height == 0.0) {
        CGFloat tableH = 3.0;
        for (int i = 0; i < _community.comment.count; i++) {
            ZXCommunityComment *comment = (ZXCommunityComment *)[_community.comment objectAtIndex:i];
            CGFloat txtH = [UtilsMacro heightForString3:comment.txt font:[UIFont systemFontOfSize:12.0] andWidth:SCREENWIDTH - 110.0];
            tableH += txtH + 60.0;
        }
        [_commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableH);
        }];
        [_commentView setNeedsLayout];
        [_commentView layoutIfNeeded];
    }
    [_commentsTable reloadData];
}

#pragma mark - Private Methods

- (void)createSubViews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView.layer setCornerRadius:5.0];
        [_mainView.layer setMasksToBounds:YES];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(0.0);
            make.left.mas_equalTo(self.contentView).mas_offset(10.0);
            make.bottom.mas_equalTo(self.contentView).offset(-10.0);
            make.right.mas_equalTo(self.contentView).mas_offset(-10.0);
        }];
    }
    
    if (!_headView) {
        _headView = [[UIView alloc] init];
        [_mainView addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_mainView);
            make.top.mas_equalTo(self->_mainView);
            make.right.mas_equalTo(self->_mainView);
            make.height.mas_equalTo(66.0);
        }];
    }
    
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        [_headImg setContentMode:UIViewContentModeScaleAspectFill];
        [_headImg setBackgroundColor:[UIColor redColor]];
        [_headImg.layer setCornerRadius:5.0];
        [_headImg setClipsToBounds:YES];
        [_headView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_headView).offset(10.0);
            make.top.mas_equalTo(self->_headView).offset(10.0);
            make.width.mas_equalTo(40.0);
            make.height.mas_equalTo(40.0);
        }];
    }
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setText:@"DW旗舰店"];
        [_nameLabel setTextColor:HOME_TITLE_COLOR];
        [_nameLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [_headView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_headImg.mas_right).offset(10.0);
            make.top.mas_equalTo(self->_headView).offset(10.0);
            make.height.mas_equalTo(20.0);
        }];
    }
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setText:@"1小时前"];
        [_timeLabel setTextColor:COLOR_999999];
        [_timeLabel setFont:[UIFont systemFontOfSize:11.0]];
        [_headView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_headImg.mas_right).offset(10.0);
            make.top.mas_equalTo(self->_nameLabel.mas_bottom).offset(5.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(10.0).priorityLow();
        }];
    }
    
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"ic_community_share"] forState:UIControlStateNormal];
        [_shareBtn setTitle:@"1232" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn setBackgroundColor:THEME_COLOR];
        [_shareBtn.layer setCornerRadius:10.0];
        [_shareBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        [_shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_shareBtn addTarget:self action:@selector(shareCommunityInfo) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_headView).offset(20.0);
            make.right.mas_equalTo(self->_headView).offset(-15.0);
            make.height.mas_equalTo(20.0);
            make.width.mas_equalTo(20.0).priorityLow();
        }];
    }
    
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"ic_community_download"] forState:UIControlStateNormal];
        [_saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:THEME_COLOR];
        [_saveBtn.layer setCornerRadius:10.0];
        [_saveBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        [_saveBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_saveBtn addTarget:self action:@selector(saveImgList) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_headView).offset(20.0);
            make.right.mas_equalTo(self->_shareBtn.mas_left).offset(-10.0);
            make.height.mas_equalTo(20.0);
            make.width.mas_equalTo(20.0).priorityLow();
        }];
    }
    
    if (!_contentLabel) {
        _contentLabel = [[ZXCopyLabel alloc] init];
        [_contentLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_contentLabel setTextColor:HOME_TITLE_COLOR];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setText:@"花生不需要文凭，不需要外貌，最主要不需要投资，更不需要囤货，就需要一部手机，就能get一个真实的来钱之道！"];
        [_mainView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_headView.mas_bottom);
            make.left.mas_equalTo(self->_mainView.mas_left).offset(60.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-10.0);
            make.height.mas_equalTo(30.0).priorityLow();
        }];
    }
    
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn setTitleColor:[UtilsMacro colorWithHexString:@"CC0000"] forState:UIControlStateNormal];
        [_detailBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_detailBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [_detailBtn addTarget:self action:@selector(checkGoodsDetail) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_contentLabel.mas_bottom).mas_offset(5.0);
            make.left.mas_equalTo(self->_mainView.mas_left).offset(60.0);
            make.width.mas_equalTo(0.0).priorityLow();
            make.height.mas_equalTo(20.0);
        }];
    }
    
    if (!_imgContainer) {
        _imgContainer = [[UIView alloc] init];
        [_mainView addSubview:_imgContainer];
        [_imgContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_detailBtn.mas_bottom).offset(10.0);
            make.left.mas_equalTo(60.0);
            make.right.mas_equalTo(-10.0);
            make.height.mas_equalTo(0.0);
        }];
    }
    
    if (!_imgCollectionView) {
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
        _imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_imgCollectionView setBackgroundColor:[UIColor whiteColor]];
        [_imgCollectionView setScrollEnabled:NO];
        [_imgCollectionView setShowsVerticalScrollIndicator:NO];
        [_imgCollectionView setShowsHorizontalScrollIndicator:NO];
        [_imgCollectionView setDelegate:self];
        [_imgCollectionView setDataSource:self];
        [_imgCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCommunityImgCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:IMG_IDENTIFIER];
        [_imgContainer addSubview:_imgCollectionView];
        [_imgCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }

    if (!_singleImg) {
        _singleImg = [[UIImageView alloc] init];
        [_singleImg setContentMode:UIViewContentModeScaleAspectFit];
        [_singleImg setClipsToBounds:YES];
        [_singleImg.layer setCornerRadius:2.0];
        [_singleImg setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapSingleImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hanleTapSingleImgAction)];
        [_singleImg addGestureRecognizer:tapSingleImg];
        [_imgContainer addSubview:_singleImg];
        [_singleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(0.0);
        }];
    }
    
    if (!_goodsView) {
        _goodsView = [[UIView alloc] init];
        [_goodsView setBackgroundColor:COLOR_F1F1F1];
        [_goodsView setClipsToBounds:YES];
        UITapGestureRecognizer *tapGoods = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickGoodsView)];
        [_goodsView addGestureRecognizer:tapGoods];
        [_goodsView.layer setCornerRadius:2.0];
        [_mainView addSubview:_goodsView];
        [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgContainer.mas_bottom).offset(10.0);
            make.left.mas_equalTo(self->_mainView.mas_left).offset(60.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-10.0);
            make.height.mas_equalTo(80.0);
        }];
    }
    
    if (!_goodsImg) {
        _goodsImg = [[UIImageView alloc] init];
        [_goodsImg setContentMode:UIViewContentModeScaleAspectFill];
        [_goodsImg setClipsToBounds:YES];
        [_goodsImg.layer setCornerRadius:2.0];
        [_goodsView addSubview:_goodsImg];
        [_goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5.0);
            make.top.mas_equalTo(5.0);
            make.bottom.mas_equalTo(-5.0);
            make.width.mas_equalTo(70.0);
        }];
    }
    
    if (!_goodsTitleLab) {
        _goodsTitleLab = [[ZXLabel alloc] init];
        [_goodsTitleLab setTextColor:HOME_TITLE_COLOR];
        [_goodsTitleLab setFont:[UIFont systemFontOfSize:14.0]];
        [_goodsTitleLab setNumberOfLines:1];
        [_goodsTitleLab setTextVerticalAlignment:YYTextVerticalAlignmentTop];
        [_goodsView addSubview:_goodsTitleLab];
        [_goodsTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.goodsImg.mas_right).offset(10.0);
            make.right.mas_equalTo(-5.0);
            make.top.mas_equalTo(5.0);
            make.height.mas_equalTo(20.0);
        }];
    }
    
    if (!_curLab) {
        _curLab = [[UILabel alloc] init];
        [_curLab setTextColor:[UtilsMacro colorWithHexString:@"C4002C"]];
        [_curLab setFont:[UIFont systemFontOfSize:11.0]];
        [_curLab setTextAlignment:NSTextAlignmentCenter];
        [_goodsView addSubview:_curLab];
        [_curLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.goodsImg.mas_right).offset(10.0);
            make.top.mas_equalTo(self.goodsTitleLab.mas_bottom).offset(10.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_oriLab) {
        _oriLab = [[UILabel alloc] init];
        [_oriLab setTextColor:[UtilsMacro colorWithHexString:@"B1B1B1"]];
        [_oriLab setFont:[UIFont systemFontOfSize:11.0]];
        [_oriLab setTextAlignment:NSTextAlignmentCenter];
        [_goodsView addSubview:_oriLab];
        [_oriLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.curLab.mas_right).offset(5.0);
            make.top.mas_equalTo(self.goodsTitleLab.mas_bottom).offset(10.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_couponLab) {
        _couponLab = [[UILabel alloc] init];
        [_couponLab setTextColor:[UIColor whiteColor]];
        [_couponLab setFont:[UIFont systemFontOfSize:9.0]];
        [_couponLab setTextAlignment:NSTextAlignmentCenter];
        [_couponLab setBackgroundColor:[UtilsMacro colorWithHexString:@"CC0000"]];
        [_goodsView addSubview:_couponLab];
        [_couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.goodsImg.mas_right).offset(10.0);
            make.top.mas_equalTo(self.curLab.mas_bottom).offset(10.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_commissionLab) {
        _commissionLab = [[UILabel alloc] init];
        [_commissionLab setTextColor:[UIColor whiteColor]];
        [_commissionLab setFont:[UIFont systemFontOfSize:9.0]];
        [_commissionLab setTextAlignment:NSTextAlignmentCenter];
        [_commissionLab setBackgroundColor:THEME_COLOR];
        [_goodsView addSubview:_commissionLab];
        [_commissionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponLab.mas_right).offset(5.0);
            make.top.mas_equalTo(self.curLab.mas_bottom).offset(10.0);
            make.height.mas_equalTo(15.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }

    if (!_commentView) {
        _commentView = [[UIView alloc] init];
        [_commentView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F2F6"]];
        [_commentView setBackgroundColor:[UIColor whiteColor]];
        [_commentView.layer setCornerRadius:2.0];
        [_mainView addSubview:_commentView];
        [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.goodsView.mas_bottom).offset(10.0);
            make.left.mas_equalTo(self->_mainView.mas_left).offset(60.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-10.0);
            make.bottom.mas_equalTo(self->_mainView.mas_bottom).offset(0.0).priorityHigh();
            make.height.mas_equalTo(0.0);
        }];
    }
    
    if (!_commentsTable) {
        _commentsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_commentsTable setDelegate:self];
        [_commentsTable setDataSource:self];
        [_commentsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_commentsTable setShowsVerticalScrollIndicator:NO];
        [_commentsTable setShowsHorizontalScrollIndicator:NO];
        [_commentsTable setScrollEnabled:NO];
        [_commentsTable setEstimatedRowHeight:80.0];
        [_commentsTable setRowHeight:UITableViewAutomaticDimension];
        [_commentsTable registerClass:[ZXCommunityCommentsCell class] forCellReuseIdentifier:@"ZXCommunityCommentsCell"];
        [_commentView addSubview:_commentsTable];
        [_commentsTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_offset(0.0);
        }];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imgList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([imgList count] == 1) {
        return _itemSize;
    } else if ([imgList count] == 2 || [imgList count] == 4) {
        return CGSizeMake((SCREENWIDTH - 93.0)/2.0, (SCREENWIDTH - 93.0)/2.0);
    } else {
        return CGSizeMake((SCREENWIDTH - 96.0)/3.0, (SCREENWIDTH - 96.0)/3.0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([imgList count] == 1) {
        return 0.0;
    }
    return 3.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([imgList count] == 1) {
        return 0.0;
    }
    return 3.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXCommunityImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IMG_IDENTIFIER forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:indexPath.row]] placeholderImage:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:indexPath.row andThumdList:@[]];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_community.comment count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH - 90.0, 10.0)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXCommunityCommentsCell";
    ZXCommunityCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXCommunityComment *comment = (ZXCommunityComment *)[_community.comment objectAtIndex:indexPath.section];
    [cell setComment:comment];
    cell.zxCommunityCommentsCellClickCopy = ^(ZXCommunityComment * _Nonnull comment) {
        if (self.zxCommunityNewCellCommentsCellClickCopy) {
            self.zxCommunityNewCellCommentsCellClickCopy(comment, indexPath.section);
        }
    };
    return cell;
}

#pragma mark - Button Methods

//保存图片
- (void)saveImgList {
    [ZXProgressHUD loading];
    _saveIndex = 0;
    [self saveImage:_saveIndex];
}

//转发
- (void)shareCommunityInfo {
    if (self.zxCommunityShareCommunityInfo) {
        self.zxCommunityShareCommunityInfo();
    }
}

//查看详情
- (void)checkGoodsDetail {
    if (self.zxCommunityNewCellCheckDetail) {
        self.zxCommunityNewCellCheckDetail();
    }
}

#pragma mark - UITapGestureRecognizer

- (void)hanleTapSingleImgAction {
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:0 andThumdList:@[]];
}

- (void)handleClickGoodsView {
    if (self.zxCommunityNewCellClickGoods) {
        self.zxCommunityNewCellClickGoods();
    }
}

#pragma mark - 保存图片到系统相册

- (void)saveImage:(NSInteger)index {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:index]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (!error) {
            [self saveImgToAlbum:image];
        }
    }];
}

- (void)saveImgToAlbum:(UIImage *)img {
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [ZXProgressHUD loadFailedWithMsg:@"保存失败"];
        return;
    } else {
        if (_saveIndex != imgList.count - 1) {
            _saveIndex++;
            [self saveImage:_saveIndex];
        } else {
            [ZXProgressHUD loadSucceedWithMsg:@"保存成功"];
        }
    }
}

@end
