//
//  ZXFavoritePickHeaderView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFavoritePickHeaderViewDelegate;

@interface ZXFavoritePickHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *pickBtn;
- (IBAction)handleTapPickBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) id<ZXFavoritePickHeaderViewDelegate>delegate;

@end

@protocol ZXFavoritePickHeaderViewDelegate <NSObject>

- (void)favoritePickHeaderViewHandleTapPickBtnActionWithTag:(NSInteger)btnTag;

@end

NS_ASSUME_NONNULL_END
