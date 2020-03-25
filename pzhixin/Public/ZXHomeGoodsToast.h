//
//  ZXHomeGoodsToast.h
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXHomeGoodsToastBtnClick)(NSInteger tag);

@interface ZXHomeGoodsToast : UIView

@property (strong, nonatomic, readonly) UIView *containerView;

@property (strong, nonatomic) NSString *imgUrl;

@property (copy, nonatomic) ZXHomeGoodsToastBtnClick zxHomeGoodsToastBtnClick;

@end

NS_ASSUME_NONNULL_END
