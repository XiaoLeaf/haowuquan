//
//  ZXLoginViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXLoginViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
- (IBAction)handleTapWxBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phontBtn;
- (IBAction)handleTapPhoneBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *unableBtn;
- (IBAction)handleTapUnableBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dealView;

@property (assign, nonatomic) NSInteger tabIndex;

@end

NS_ASSUME_NONNULL_END
