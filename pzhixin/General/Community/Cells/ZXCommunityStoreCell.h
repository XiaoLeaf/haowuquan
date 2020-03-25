//
//  ZXCommunityStoreCell.h
//  pzhixin
//
//  Created by zhixin on 2019/8/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXCommunityStoreCellDelegate;

@interface ZXCommunityStoreCell : UITableViewCell

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *headView;

@property (strong, nonatomic) UIImageView *headImg;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIButton *saveBtn;

@property (strong, nonatomic) UIButton *shareBtn;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UICollectionView *imgCollectionView;

@property (strong, nonatomic) UIView *commentView;

@property (strong, nonatomic) UILabel *commentLabel;

@property (strong, nonatomic) UIButton *btnCopy;

@property (copy, nonatomic) void(^zxCommunityStoreCellCheckDetail) (void);

#pragma mark - Setter

@property (strong, nonatomic) NSDictionary *communityInfo;

@property (assign, nonatomic) CGSize itemSize;

@property (weak, nonatomic) id<ZXCommunityStoreCellDelegate>delegate;

@end

@protocol ZXCommunityStoreCellDelegate <NSObject>

- (void)refreshCommunityStoreCell:(UITableViewCell *)cell;

- (void)communityStoreCellShareCommunityInfo;

@end

NS_ASSUME_NONNULL_END
