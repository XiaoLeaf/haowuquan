//
//  ZXBalanceCell.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXUdMoney.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBalanceCell : UITableViewCell

@property (strong, nonatomic) ZXUdMoney *udMoney;

@property (strong, nonatomic) UILabel *reasonLab;

@end

NS_ASSUME_NONNULL_END
