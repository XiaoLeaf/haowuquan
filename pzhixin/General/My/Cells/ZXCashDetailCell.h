//
//  ZXCashDetailCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCashList.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXCashDetailCellCancelClick)(NSInteger btnTag);

@interface ZXCashDetailCell : UITableViewCell

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UILabel *reasonLab;

@property (strong, nonatomic) ZXCashList *cashList;

@property (copy, nonatomic) ZXCashDetailCellCancelClick zxCashDetailCellCancelClick;

@end

NS_ASSUME_NONNULL_END
