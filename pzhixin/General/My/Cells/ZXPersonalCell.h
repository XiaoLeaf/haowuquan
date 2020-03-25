//
//  ZXPersonalCell.h
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXPersonalCellDelegate;

@interface ZXPersonalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentRight;

@property (weak, nonatomic) id<ZXPersonalCellDelegate>delegate;

@end

@protocol ZXPersonalCellDelegate <NSObject>

- (void)personalCellHandleTapHeadImgAction;

@end

NS_ASSUME_NONNULL_END
