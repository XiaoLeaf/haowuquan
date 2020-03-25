//
//  ZXScoreViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNormalBaseViewController.h"
#import <UIKit/UIKit.h>
#import "ZXScorePop.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXScoreViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UITableView *scoreTableView;

@property (strong, nonatomic) ZXScorePop *scorePop;

@end

NS_ASSUME_NONNULL_END
