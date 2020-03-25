//
//  ZXAddressListCell.m
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressListCell.h"

@implementation ZXAddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.defImg.layer setCornerRadius:2.0];
    [self.htImg.layer setCornerRadius:2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setAddrItem:(ZXAddrItem *)addrItem {
    _addrItem = addrItem;
    [self.nameLabel setText:_addrItem.realname];
    [self.phoneLabel setText:_addrItem.tel];
    if ([_addrItem.is_def integerValue] == 1) {
        _defLeft.constant = 6.0;
        _defWidth.constant = 30.0;
    } else {
        _defLeft.constant = 0.0;
        _defWidth.constant = 0.0;
    }
    if ([_addrItem.is_ht integerValue] == 1) {
        _htWidth.constant = 30.0;
    } else {
        _htWidth.constant = 0.0;
    }
    [self.addressLabel setText:[NSString stringWithFormat:@"%@ %@", _addrItem.pcas, _addrItem.address]];
}

#pragma mark - Button Actions

- (IBAction)handleTapEditBtnAction:(id)sender {
    if (self.zxAddressListCellClickEdit) {
        self.zxAddressListCellClickEdit();
    }
}

@end
