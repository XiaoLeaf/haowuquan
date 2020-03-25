//
//  ZXCommunityNewCell.h
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommunityNewCell : UITableViewCell

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *headView;

@property (strong, nonatomic) UIImageView *headImg;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIButton *saveBtn;

@property (strong, nonatomic) UIButton *shareBtn;

@property (strong, nonatomic) ZXCopyLabel *contentLabel;

@property (strong, nonatomic) UICollectionView *imgCollectionView;

@property (strong, nonatomic) UIView *commentView;

@property (strong, nonatomic) UILabel *commentLabel;

@property (strong, nonatomic) UITableView *commentsTable;

@property (strong, nonatomic) UIButton *btnCopy;

@property (strong, nonatomic) UIView *earnView;

@property (strong, nonatomic) UILabel *earnLabel;

@property (assign, nonatomic) BOOL singleBlocked;

@property (copy, nonatomic) void(^zxCommunitySingleImgComplete) (NSIndexPath *indexPath);

@property (copy, nonatomic) void(^zxCommunityShareCommunityInfo) (void);

@property (copy, nonatomic) void(^zxCommunityNewCellCheckDetail) (void);

@property (copy, nonatomic) void(^zxCommunityNewCellClickGoods) (void);

@property (copy, nonatomic) void(^zxCommunityNewCellCommentsCellClickCopy) (ZXCommunityComment *comment, NSInteger index);

#pragma mark - Setter

@property (strong, nonatomic) NSDictionary *communityInfo;

@property (strong, nonatomic) ZXCommunity *community;

@property (assign, nonatomic) CGSize itemSize;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
