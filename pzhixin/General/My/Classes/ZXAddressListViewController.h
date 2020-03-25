//
//  ZXAddressListViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/6/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressListViewController : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *addressListTableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addNewAddress:(id)sender;

@end

NS_ASSUME_NONNULL_END
