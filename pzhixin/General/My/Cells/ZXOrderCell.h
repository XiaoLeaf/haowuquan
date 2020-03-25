//
//  ZXOrderCell.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "ZXOrder.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXOrderCellDelegate;

@interface ZXOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) YYLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UIButton *cpBtn;
- (IBAction)handleTapCpBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *clearTime;
@property (weak, nonatomic) IBOutlet UILabel *benefitLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (strong, nonatomic) ZXOrder *order;

@property (weak, nonatomic) id<ZXOrderCellDelegate>delegate;

@end

@protocol ZXOrderCellDelegate <NSObject>

- (void)orderCellHandleTapCpBtnActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
