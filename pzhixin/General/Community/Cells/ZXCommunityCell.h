//
//  ZXCommunityCell.h
//  pzhixin
//
//  Created by zhixin on 2019/7/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXCommunityCellDelegate;

@interface ZXCommunityCell : UITableViewCell

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

@property (strong, nonatomic) UIView *earnView;

@property (strong, nonatomic) UILabel *earnLabel;

@property (copy, nonatomic) void(^zxCommunityCellCheckDetail) (void);

#pragma mark - Setter

@property (strong, nonatomic) NSDictionary *communityInfo;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) CGSize itemSize;

@property (weak, nonatomic) id<ZXCommunityCellDelegate>delegate;

@end

@protocol ZXCommunityCellDelegate <NSObject>

- (void)refreshCommunityCell:(ZXCommunityCell *)cell;

- (void)communityCellShareCommunityInfo;

@end

NS_ASSUME_NONNULL_END
