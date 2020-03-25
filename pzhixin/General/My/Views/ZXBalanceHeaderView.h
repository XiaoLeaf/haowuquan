//
//  ZXBalanceHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXBalanceHeaderViewDelegate;

@interface ZXBalanceHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UICountingLabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
- (IBAction)handleTapWithdrawBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *alreadyLabel;
@property (weak, nonatomic) IBOutlet UILabel *notLabel;

@property (weak, nonatomic) id<ZXBalanceHeaderViewDelegate>delegate;

@end

@protocol ZXBalanceHeaderViewDelegate <NSObject>

- (void)balanceHeaderViewHandleTapWithDrawBtnAction;

@end

NS_ASSUME_NONNULL_END
