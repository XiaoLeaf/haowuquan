//
//  ZXCashDetailVC.h
//  pzhixin
//
//  Created by zhixin on 2019/9/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXCashDetailVCBlcok)(void);

@interface ZXCashDetailVC : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *detailTable;

@property (copy, nonatomic) ZXCashDetailVCBlcok zxCashDetailVCBlcok;

@end

NS_ASSUME_NONNULL_END
