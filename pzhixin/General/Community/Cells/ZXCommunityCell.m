//
//  ZXCommunityCell.m
//  pzhixin
//
//  Created by zhixin on 2019/7/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommunityCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZXCommunityImgCell.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <UICollectionViewLeftAlignedLayout/UICollectionViewLeftAlignedLayout.h>

#define IMG_IDENTIFIER @"ZXCommunityImgCell"

@interface ZXCommunityCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSArray *imgList;
}

@property (strong, nonatomic) UIView *imgContainer;

@property (strong, nonatomic) UIImageView *singleImg;

@property (strong, nonatomic) UIButton *detailBtn;

@end

@implementation ZXCommunityCell

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
        [self createSubViews];
    }
    [self setBackgroundColor:BG_COLOR];
    return self;
}

#pragma mark - Setter

- (void)setCommunityInfo:(NSDictionary *)communityInfo {
    _communityInfo = communityInfo;
    
    NSString *content = [_communityInfo objectForKey:@"content"];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:content];
    [contentStr addAttributes:[UtilsMacro contentAttributes] range:NSMakeRange(0, contentStr.length)];
    
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_communityInfo objectForKey:@"icon"]]] imageView:_headImg placeholderImage:[UtilsMacro big_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [_nameLabel setText:[NSString stringWithFormat:@"%@",[_communityInfo objectForKey:@"name"]]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",[_communityInfo objectForKey:@"time"]]];
    [_contentLabel setAttributedText:contentStr];
    [_commentLabel setText:@"自购/分享，预估得【 2.91】\n 限时抢途径:好物券app首页—好店 \n 搜索关键词【捞旺】"];
    [_shareBtn setTitle:[NSString stringWithFormat:@"%@",[_communityInfo objectForKey:@"share"]] forState:UIControlStateNormal];
    
    //设置渐变色背景
    CAGradientLayer *gradinentLayer = [CAGradientLayer layer];
    [gradinentLayer setColors:@[(__bridge id)[UtilsMacro colorWithHexString:@"FF5100"].CGColor, (__bridge id)[UtilsMacro colorWithHexString:@"FF8B00"].CGColor]];
    [gradinentLayer setLocations:@[@0.0, @1.0]];
    [gradinentLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradinentLayer setEndPoint:CGPointMake(1.0, 0.0)];
    [gradinentLayer setFrame:CGRectMake(0.0, 0.0, [UtilsMacro widthForString:[_communityInfo objectForKey:@"share"] font:[UIFont systemFontOfSize:10.0] andHeight:20.0] + 20.0, 20.0)];
    [gradinentLayer setCornerRadius:10.0];
    [gradinentLayer setMasksToBounds:YES];
    [_shareBtn.layer addSublayer:gradinentLayer];
    [_shareBtn bringSubviewToFront:_shareBtn.imageView];
    [_shareBtn bringSubviewToFront:_shareBtn.titleLabel];
    
    imgList = [[NSArray alloc] initWithArray:[_communityInfo objectForKey:@"imgList"]];
    if ([imgList count] == 1) {
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
        }];
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
            make.top.mas_equalTo(self.contentView).offset(10.0);
            make.left.mas_equalTo(self.contentView).mas_offset(10.0);
            make.bottom.mas_equalTo(self.contentView).mas_offset(0.0);
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
            make.height.mas_equalTo(66.0).priorityLow();
        }];
    }
    
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        [_headImg setContentMode:UIViewContentModeScaleAspectFill];
        [_headImg setBackgroundColor:[UIColor redColor]];
        [_headImg.layer setCornerRadius:25.0];
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
            make.width.mas_equalTo(70.0).priorityLow();
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
        [_shareBtn addTarget:self action:@selector(shareCommunityInfo) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn.layer setCornerRadius:10.0];
        [_shareBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        [_shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
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
        [_saveBtn setImage:[UIImage imageNamed:@"ic_community_share"] forState:UIControlStateNormal];
        [_saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:THEME_COLOR];
        [_saveBtn.layer setCornerRadius:10.0];
        [_saveBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        [_saveBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_saveBtn addTarget:self action:@selector(shareCommunityInfo) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_headView).offset(20.0);
            make.right.mas_equalTo(self->_shareBtn.mas_left).offset(-10.0);
            make.height.mas_equalTo(20.0);
            make.width.mas_equalTo(20.0).priorityLow();
        }];
    }
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_contentLabel setTextColor:HOME_TITLE_COLOR];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setText:@"花生不需要文凭，不需要外貌，最主要不需要投资，更不需要囤货，就需要一部手机，就能get一个真实的来钱之道！"];
        [_mainView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_headView.mas_bottom);
            make.left.mas_equalTo(self->_mainView.mas_left).offset(60.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-10.0);
            make.height.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_detailBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
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
            make.top.mas_equalTo(self->_contentLabel.mas_bottom).offset(10.0);
            make.left.mas_equalTo(self->_mainView.mas_left).offset(60.0);
            make.right.mas_equalTo(self->_mainView.mas_right).offset(-10.0);
            make.height.mas_equalTo(0.0);
            make.bottom.mas_equalTo(-15.0);
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
        [_singleImg setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapSingleImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hanleTapSingleImgAction)];
        [_singleImg addGestureRecognizer:tapSingleImg];
        [_imgContainer addSubview:_singleImg];
        [_singleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(0.0);
        }];
    }
}

- (void)hanleTapSingleImgAction {
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:0 andThumdList:@[]];
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
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:indexPath.row]] imageView:cell.imgView placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:indexPath.row andThumdList:@[]];
}

#pragma mark - Button Methods

- (void)shareCommunityInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityCellShareCommunityInfo)]) {
        [self.delegate communityCellShareCommunityInfo];
    }
}

- (void)checkGoodsDetail {
    if (self.zxCommunityCellCheckDetail) {
        self.zxCommunityCellCheckDetail();
    }
}

@end
