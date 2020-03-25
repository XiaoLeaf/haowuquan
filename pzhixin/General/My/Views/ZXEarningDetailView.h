//
//  ZXEarningDetailView.h
//  pzhixin
//
//  Created by zhixin on 2019/9/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"
#import "JXCategoryTitleView.h"
#import "ZXProfitList.h"
#import "ZXProfit.h"
#import "ZXUser.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXEarningDetailViewMonthBtnClick)(void);

@interface ZXEarningDetailView : UIView <JXCategoryListContentViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UITableView *detailTable;

@property (strong, nonatomic) NSDictionary *parameters;

@property (strong, nonatomic) NSDictionary *defaultResult;

@property (copy, nonatomic) ZXEarningDetailViewMonthBtnClick zxEarningDetailViewMonthBtnClick;

@end

NS_ASSUME_NONNULL_END
