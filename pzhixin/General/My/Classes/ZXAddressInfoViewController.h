//
//  ZXAddressInfoViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressInfoViewController : ZXNormalBaseViewController

@property (assign, nonatomic) NSInteger type;

@property (copy, nonatomic) void (^zxAddressInfoChangeBlcok) (void);

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;

@property (strong, nonatomic) ZXAddrItem *addrItem;

@end

NS_ASSUME_NONNULL_END
