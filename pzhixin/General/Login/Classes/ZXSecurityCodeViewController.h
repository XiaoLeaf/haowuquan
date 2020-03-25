//
//  ZXSecurityCodeViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import <CRBoxInputView/CRBoxInputView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSecurityCodeViewController : ZXNormalBaseViewController

@property (strong, nonatomic) NSString *phoneStr;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)handleTapSendBtnAction:(id)sender;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *user_id;

@property (strong, nonatomic) NSString *unionid;

@property (strong, nonatomic) NSString *phone;

@property (assign, nonatomic) NSInteger tabIndex;

@end

NS_ASSUME_NONNULL_END
