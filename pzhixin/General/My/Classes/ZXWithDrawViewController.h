//
//  ZXWithDrawViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXBalanceChangeBlock)(void);

@interface ZXWithDrawViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)handleTapEditBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
- (IBAction)handleTapAllBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
- (IBAction)handleTapWithDrawBtnAction:(id)sender;

@property (copy, nonatomic) ZXBalanceChangeBlock zxBalanceChangeBlock;

@end

NS_ASSUME_NONNULL_END
