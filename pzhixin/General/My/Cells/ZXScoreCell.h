//
//  ZXScoreCell.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXScoreIndex.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
- (IBAction)handleTapActionBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainLeft;

@property (strong, nonatomic) ZXScoreRuleItem *scoreRuleItem;

@property (copy, nonatomic) void (^zxScoreCellBtnClick) (void);

@end

NS_ASSUME_NONNULL_END
