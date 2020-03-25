//
//  ZXShareVC.h
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import "ZXGoodsDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXShareVC : ZXNormalBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *shareTable;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *cpBtn;
- (IBAction)handleTapShareBtnsAction:(id)sender;

@property (strong, nonatomic) NSString *item_id;

@property (strong, nonatomic) NSString *idStr;

@end

NS_ASSUME_NONNULL_END
