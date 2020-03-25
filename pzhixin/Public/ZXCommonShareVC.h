//
//  ZXCommonShareVC.h
//  pzhixin
//
//  Created by zhixin on 2019/11/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCommunity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommonShare : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *desc;

@property (strong, nonatomic) NSArray *imgs;

@end

@interface ZXCommonShareVC : UIViewController

@property (strong, nonatomic) ZXCommonShare *commonShare;

@property (strong, nonatomic) NSDictionary *communityInfo;

@property (strong, nonatomic) ZXCommunity *community;

@property (copy, nonatomic) void(^zxCommShareVCShareSucceed) (void);

@end

NS_ASSUME_NONNULL_END
