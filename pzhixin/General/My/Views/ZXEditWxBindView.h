//
//  ZXEditWxBindView.h
//  pzhixin
//
//  Created by zhixin on 2019/7/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXEditWxBindViewDelegate;

@interface ZXEditWxBindView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bindedView;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *releaseView;
@property (weak, nonatomic) IBOutlet UIView *unBindView;
@property (weak, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
- (IBAction)handleTapBindBtnAction:(id)sender;

@property (weak, nonatomic) id<ZXEditWxBindViewDelegate>delegate;

@end

@protocol ZXEditWxBindViewDelegate <NSObject>

- (void)editWxBindViewHandleTapUnBindViewAction;

- (void)editWxBindViewHanldeTapBindBtnAction;

@end

NS_ASSUME_NONNULL_END
