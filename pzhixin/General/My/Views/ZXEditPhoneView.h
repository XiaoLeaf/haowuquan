//
//  ZXEditPhoneView.h
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXEditPhoneViewDelegate;

@interface ZXEditPhoneView : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
- (IBAction)handleTapCodeBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)handleTapSubmitBtnAction:(id)sender;

@property (weak, nonatomic) id <ZXEditPhoneViewDelegate>delegate;

@end

@protocol ZXEditPhoneViewDelegate <NSObject>

- (void)editPhoneHandleTapCodeBtnAction;

- (void)editPhoneHandleTapSubmitBtnAction;

@end

NS_ASSUME_NONNULL_END
