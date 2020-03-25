//
//  ZXNoFansCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXNoFansCellDelegate;

@interface ZXNoFansCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
- (IBAction)handleTapInviteBtn:(id)sender;

@property (weak, nonatomic) id<ZXNoFansCellDelegate>delegate;

@end

@protocol ZXNoFansCellDelegate <NSObject>

- (void)noFansCellHandleTapInviteBtnAction;

@end

NS_ASSUME_NONNULL_END
