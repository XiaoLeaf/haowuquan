//
//  ZXAddressListCell.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIImageView *defImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defWidth;
@property (weak, nonatomic) IBOutlet UIImageView *htImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *htWidth;
- (IBAction)handleTapEditBtnAction:(id)sender;

@property (strong, nonatomic) ZXAddrItem *addrItem;

@property (copy, nonatomic) void (^zxAddressListCellClickEdit) (void);

@end

NS_ASSUME_NONNULL_END
