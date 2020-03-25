//
//  ZXEditAddressVC.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXEditAddressVC : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *editTable;

@property (copy, nonatomic) void (^zxEditAddressVCBlcok) (void);

@property (copy, nonatomic) ZXAddrItem *editItem;

@end

NS_ASSUME_NONNULL_END
