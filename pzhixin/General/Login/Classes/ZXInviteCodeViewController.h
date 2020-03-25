//
//  ZXInviteCodeViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXInviteCodeViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
- (IBAction)handleTapBindBtnAction:(id)sender;

@property (assign, nonatomic) NSInteger fromType;

@property (assign, nonatomic) NSInteger tabIndex;

@end

NS_ASSUME_NONNULL_END
