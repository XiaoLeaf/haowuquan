//
//  ZXShareCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXGoodsDetail.h"
#import "ZXShareImgCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXShareCellDelegate;

@interface ZXShareCell : UITableViewCell

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UILabel *earningLab;

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UITextView *titleTV;

@property (strong, nonatomic) UIButton *cpBtn;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIView *writerView;

@property (strong, nonatomic) UIView *goodsContentView;

@property (strong, nonatomic) UITextView *writeTV;

@property (strong, nonatomic) UILabel *originalPrice;

@property (strong, nonatomic) UILabel *currentPrice;

@property (strong, nonatomic) UILabel *saveLab;

@property (strong, nonatomic) UIView *secLine;

@property (strong, nonatomic) UILabel *inviteCode;

@property (strong, nonatomic) UIView *thirdLine;

@property (strong, nonatomic) UILabel *linkLab;

@property (strong, nonatomic) UIView *fouthLine;

@property (strong, nonatomic) UILabel *cpLab;

@property (strong, nonatomic) UIButton *showEarn;

@property (strong, nonatomic) UIButton *showCode;

@property (strong, nonatomic) UIButton *showLink;

@property (strong, nonatomic) UIButton *cpCode;

@property (strong, nonatomic) UIButton *cpLink;

@property (strong, nonatomic) UIView *imgContainer;

@property (strong, nonatomic) UIButton *allSelect;

@property (strong, nonatomic) UIImageView *mainImg;

@property (strong, nonatomic) UIButton *mainPick;

@property (strong, nonatomic) UICollectionView *imgCollection;

@property (strong, nonatomic) UIView *shareView;

@property (strong, nonatomic) UIButton *wxFriend;

@property (strong, nonatomic) UIButton *wxCircle;

@property (strong, nonatomic) UIButton *saveAlbum;

@property (strong, nonatomic) UIButton *cpWriter;

@property (weak, nonatomic) id<ZXShareCellDelegate>delegate;

@property (strong, nonatomic) ZXGoodsDetail *goodsDetail;

@property (strong, nonatomic) NSArray *pickStateList;

@property (strong, nonatomic) ZXGoodsShare *goodsShare;

@property (strong, nonatomic) UIImage *posterImg;

@end

@protocol ZXShareCellDelegate <NSObject>

- (void)shareCellHanleTapBtnsActionWithBtn:(UIButton *)btn andTag:(NSInteger)btnTag;

- (void)shareCellTextViewDidChange:(UITextView *)textView;

- (void)shareCellImgCellHanleTapPickBtnActionWithCell:(ZXShareImgCell *)cell andTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
