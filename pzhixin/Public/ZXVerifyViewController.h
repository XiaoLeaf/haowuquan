//
//  ZXVerifyViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXVerifyViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
- (IBAction)handleTapAtCodeButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)handleTapAtSubmitButtonAction:(id)sender;

@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) NSInteger codeType;

@end

NS_ASSUME_NONNULL_END
