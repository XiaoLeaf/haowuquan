//
//  ZXMemberScoreCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/9.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXMemberScoreCellBtnClick)(void);

@interface ZXMemberScoreCell : UITableViewCell

@property (strong, nonatomic) NSArray *taskList;

@property (copy, nonatomic) ZXMemberScoreCellBtnClick zxMemberScoreCellBtnClick;

@end

NS_ASSUME_NONNULL_END
