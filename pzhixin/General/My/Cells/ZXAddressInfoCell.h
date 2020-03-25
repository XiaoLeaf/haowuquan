//
//  ZXAddressInfoCell.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;

@property (strong, nonatomic) NSString *contentStr;

@property (copy, nonatomic) void (^zxAddressInfoCellTFEdited) (NSInteger cellTag, ZXAddressInfoCell *infoCell);

@property (copy, nonatomic) void (^zxAddressInfoCellSwitchValueChanged) (BOOL isOn);

@end

NS_ASSUME_NONNULL_END
