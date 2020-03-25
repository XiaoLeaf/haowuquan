//
//  ZXFansLatentCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFansLatentCellDelegate;

@interface ZXFansLatentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *wakeBtn;
- (IBAction)handleTapWakeBtnAction:(id)sender;

@property (weak, nonatomic) id<ZXFansLatentCellDelegate>delegate;

@end

@protocol ZXFansLatentCellDelegate <NSObject>

- (void)fansLatentCellHandleTapWakeBtnActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
