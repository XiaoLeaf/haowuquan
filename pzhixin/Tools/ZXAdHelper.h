//
//  ZXAdHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/12/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAdHelper : NSObject

+ (ZXAdHelper *)sharedInstance;

@property (copy, nonatomic) void(^zxRewardAdLoadSucceed) (void);

#pragma mark - 激励广告

//初始化腾讯rewardAd
- (void)fetchTencentRewardAdWithDelegate:(UIViewController *)viewController loadSucceedBlock:(void (^) (void))loadSucceedBlock;

//播放腾讯激励广告
- (void)playTencentRewardAdVideo;

//初始化穿山甲rewardAd
- (void)fetchBURewardAdWithDelegate:(UIViewController *)viewController loadSucceedBlock:(void (^) (void))loadSucceedBlock;

//播放穿山甲激励广告
- (void)playBURewardAdVideo;

@end

NS_ASSUME_NONNULL_END
