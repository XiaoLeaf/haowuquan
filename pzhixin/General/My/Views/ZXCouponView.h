//
//  ZXCouponView.h
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>
#import "ZXCouponCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXCouponViewDelegate;

@interface ZXCouponView : UIView <JXCategoryListContentViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *couponTable;

@property (weak, nonatomic) id<ZXCouponViewDelegate>delegate;

@end

@protocol ZXCouponViewDelegate <NSObject>

- (void)couponViewTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)couponViewCellHandleTapDetailBtnAction:(ZXCouponCell *)cell;

- (void)couponViewRefreshCouponInfo:(ZXCouponView *)couponView;

@end

NS_ASSUME_NONNULL_END
