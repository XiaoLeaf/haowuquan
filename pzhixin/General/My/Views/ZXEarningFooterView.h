//
//  ZXEarningFooterView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXEarningFooterBtnClick)(void);

@interface ZXEarningFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *issueBtn;

@property (copy, nonatomic) ZXEarningFooterBtnClick zxEarningFooterBtnClick;

@end

NS_ASSUME_NONNULL_END
