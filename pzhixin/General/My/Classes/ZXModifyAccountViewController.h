//
//  ZXModifyAccountViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXModifyAccountBlock)(NSString *account);

@interface ZXModifyAccountViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;
- (IBAction)handleTapFetchBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)handleTapConfirmBtnAction:(id)sender;

@property (copy, nonatomic) ZXModifyAccountBlock zxModifyAccountBlock;

//来源，修改账户信息==1  新增账户信息==2
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *tel;

@property (strong, nonatomic) NSString *realName;

@property (strong, nonatomic) NSString *accountStr;

@end

NS_ASSUME_NONNULL_END
