//
//  ZXWelfareCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXWelfare.h"
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXWelfareCellDelegate;

@interface ZXWelfareCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *testImg;

@property (strong, nonatomic) ZXWelfare *welfare;

@property (weak, nonatomic) id<ZXWelfareCellDelegate>delegate;

@end

@protocol ZXWelfareCellDelegate <NSObject>

- (void)welfareCellImgDownloadCompletedWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
