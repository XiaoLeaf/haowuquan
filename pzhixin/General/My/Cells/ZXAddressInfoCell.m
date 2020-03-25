//
//  ZXAddressInfoCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressInfoCell.h"

@interface ZXAddressInfoCell () <UITextFieldDelegate>

@end

@implementation ZXAddressInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.defaultSwitch setOnTintColor:THEME_COLOR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    [self.contentTextField setText:_contentStr];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.zxAddressInfoCellTFEdited) {
        self.zxAddressInfoCellTFEdited(self.tag, self);
    }
    return YES;
}

- (IBAction)defSwitchValueChange:(id)sender {
    if (self.zxAddressInfoCellSwitchValueChanged) {
        self.zxAddressInfoCellSwitchValueChanged(self.defaultSwitch.isOn);
    }
}

@end
