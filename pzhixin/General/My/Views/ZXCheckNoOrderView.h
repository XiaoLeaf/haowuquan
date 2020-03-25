//
//  ZXCheckNoOrderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXCheckNoOrderViewDelegate;

@interface ZXCheckNoOrderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)handleTapCheckBtnAction:(id)sender;

@property (weak, nonatomic) id<ZXCheckNoOrderViewDelegate>delegate;

@end

@protocol ZXCheckNoOrderViewDelegate <NSObject>

- (void)checkNoOrderViewHanldeTapCheckBtnAction;

@end

NS_ASSUME_NONNULL_END
