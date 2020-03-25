//
//  ZXFeedbackView.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFeedbackViewDelegate;

@interface ZXFeedbackView : UIView

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UITextView *contentTextView;

@property (strong, nonatomic) UICollectionView *imgCollectionView;

@property (strong, nonatomic) UIButton *submitBtn;

@property (weak, nonatomic) id<ZXFeedbackViewDelegate>delegate;

#pragma mark - Setter

@property (strong, nonatomic) NSMutableArray *imgList;

@end

@protocol ZXFeedbackViewDelegate <NSObject>

- (void)feedbackSubmitButtonAction;

- (void)feedbackCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
