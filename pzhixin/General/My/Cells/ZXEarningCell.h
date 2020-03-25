//
//  ZXEarningCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXProfitHome.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXEarningCellDelegate;

@interface ZXEarningCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *explainBtn;
- (IBAction)handleTapExplainBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLab;
@property (weak, nonatomic) IBOutlet UILabel *payLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;

@property (strong, nonatomic) ZXProfitHome *profitHome;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<ZXEarningCellDelegate>delegate;

@end

@protocol ZXEarningCellDelegate <NSObject>

- (void)earningCellHandleTapAtExplainBtnActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
