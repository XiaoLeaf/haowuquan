//
//  ZXAddressInfoDetailCell.h
//  pzhixin
//
//  Created by zhixin on 2019/7/5.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXAddressInfoDetailCellDelegate;

@interface ZXAddressInfoDetailCell : UITableViewCell <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;

@property (weak, nonatomic) id<ZXAddressInfoDetailCellDelegate>delegate;

@property (copy, nonatomic) void(^zxAddressInfoDetailCellLayouBlock) (void);

@end

@protocol ZXAddressInfoDetailCellDelegate <NSObject>

- (void)addressInfoDetailCellTextViewDidChange:(UITextView *)textView;

@end

NS_ASSUME_NONNULL_END
