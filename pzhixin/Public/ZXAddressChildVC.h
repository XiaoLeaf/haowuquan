//
//  ZXAddressChildVC.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPcasJson.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressChildVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *childTable;

@property (strong, nonatomic) NSArray *itemList;

@property (strong, nonatomic) ZXPcasJson *pcasJson;

@property (copy, nonatomic) void (^zxAddressChildVCDidSelect) (ZXPcasJson *pcasJson);

@end

NS_ASSUME_NONNULL_END
