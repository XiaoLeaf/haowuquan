//
//  ZXCommunityCommentsCell.h
//  pzhixin
//
//  Created by zhixin on 2020/3/10.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommunityCommentsCell : UITableViewCell

@property (strong, nonatomic) UILabel *commentLab;

@property (strong, nonatomic) ZXCommunityComment *comment;

@property (copy, nonatomic) void(^zxCommunityCommentsCellClickCopy) (ZXCommunityComment *comment);

@end

NS_ASSUME_NONNULL_END
