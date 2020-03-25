//
//  ZXFansFirstCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXFans.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFansFirstCellDelegate;

@interface ZXFansFirstCell : UITableViewCell

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *userView;

@property (strong, nonatomic) UIImageView *userImg;

@property (strong, nonatomic) UILabel *nameLab;

@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIImageView *levelImg;

@property (strong, nonatomic) UIView *fansView;

@property (strong, nonatomic) UILabel *fansLab;

@property (weak, nonatomic) id<ZXFansFirstCellDelegate>delegate;

@property (strong, nonatomic) ZXFans *fans;

@end

@protocol ZXFansFirstCellDelegate <NSObject>

- (void)fansFirstCellHandleTapButtonActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
