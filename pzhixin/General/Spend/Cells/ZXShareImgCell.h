//
//  ZXShareImgCell.h
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXShareImgCellDelegate;

@interface ZXShareImgCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UIButton *pickBtn;
- (IBAction)handleTapPickBtnAction:(id)sender;

@property (weak, nonatomic) id<ZXShareImgCellDelegate>delegate;

@end

@protocol ZXShareImgCellDelegate <NSObject>

- (void)shareImgCellHanleTapPickBtnActionWithCell:(ZXShareImgCell *)cell andTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
