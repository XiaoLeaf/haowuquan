//
//  ZXCheckOrderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXCheckOrderViewDelegate;

@interface ZXCheckOrderView : UIView

@property (weak, nonatomic) IBOutlet UITextField *orderNumTF;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)handleTapCheckBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (strong, nonatomic) UILabel *ruleLab;

@property (strong, nonatomic) id<ZXCheckOrderViewDelegate>delegate;

@end

@protocol ZXCheckOrderViewDelegate <NSObject>

- (void)checkOrderViewHandleTapCheckBtnAction;

@end

NS_ASSUME_NONNULL_END
