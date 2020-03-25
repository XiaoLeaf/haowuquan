//
//  ZXRankListView.h
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXRankListViewDidScroll)(UIScrollView *scrollView);

@interface ZXRankListView : UIView

@property (copy, nonatomic) ZXRankListViewDidScroll zxRankListViewDidScroll;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSArray *defaultResult;

@property (assign, nonatomic) BOOL isDefault;

@end

NS_ASSUME_NONNULL_END
