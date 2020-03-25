//
//  ZXAddAddressVC.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddAddressVC : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *addTable;

@property (strong, nonatomic) ZXPcasJson *proPcasJosn;

@property (strong, nonatomic) ZXPcasJson *cityPcasJosn;

@property (strong, nonatomic) ZXPcasJson *areaPcasJosn;

@property (strong, nonatomic) ZXPcasJson *streetPcasJosn;

@property (copy, nonatomic) void (^zxAddAddressVCBlcok) (void);

@end

NS_ASSUME_NONNULL_END
