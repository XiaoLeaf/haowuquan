//
//  ZXMyEarnCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyEarnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UILabel *todayTitle;
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UILabel *monthTitle;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthLab;
@property (weak, nonatomic) IBOutlet UILabel *lastHopeLab;

@property (copy, nonatomic) void(^zxMyEarnCellSubViewClick)(NSInteger index);

@property (strong, nonatomic) ZXUser *userInfo;

@end

NS_ASSUME_NONNULL_END
