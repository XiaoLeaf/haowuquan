//
//  ZXSpendSortHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXSpendSortHeaderBtnClick)(UIButton *button);

@interface ZXSpendSortHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *synBtn;
@property (weak, nonatomic) IBOutlet UIButton *awardBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
- (IBAction)handleTapRankBtnAction:(id)sender;

@property (nonatomic, copy) ZXSpendSortHeaderBtnClick spendSortHeaderBtnClick;

@end

NS_ASSUME_NONNULL_END
