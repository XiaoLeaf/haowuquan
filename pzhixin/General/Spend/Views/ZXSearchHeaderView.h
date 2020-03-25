//
//  ZXSearchHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/7/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXSearchHeaderViewDelegate;

@interface ZXSearchHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *replaceBtn;
- (IBAction)handleTapDeleteBtnAction:(id)sender;

@property (copy, nonatomic) void(^zxSearchHeaderViewReplaceClick) (void);

@property (weak, nonatomic) id<ZXSearchHeaderViewDelegate>delegate;

@end

@protocol ZXSearchHeaderViewDelegate <NSObject>

- (void)searchHeaderViewHandleTapDeleteBtn;

@end

NS_ASSUME_NONNULL_END
