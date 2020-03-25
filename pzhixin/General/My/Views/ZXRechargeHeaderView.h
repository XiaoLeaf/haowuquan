//
//  ZXRechargeHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXRechargeHeaderViewDelegate;

@interface ZXRechargeHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *flagLab;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
- (IBAction)handleTapContactBtnAction:(id)sender;

@property (weak, nonatomic) id<ZXRechargeHeaderViewDelegate>delegate;

@end

@protocol ZXRechargeHeaderViewDelegate <NSObject>

- (void)rechargeHeaderViewHandleTapContactBtnAction;

@end

NS_ASSUME_NONNULL_END
