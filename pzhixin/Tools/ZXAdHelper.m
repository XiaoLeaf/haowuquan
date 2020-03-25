//
//  ZXAdHelper.m
//  pzhixin
//
//  Created by zhixin on 2019/12/24.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAdHelper.h"

#define ERROR_MSG @"暂无广告"

@interface ZXAdHelper () <GDTRewardedVideoAdDelegate, BUNativeExpressRewardedVideoAdDelegate>

@property (strong, nonatomic) GDTRewardVideoAd *rewardVideoAd;

@property (strong, nonatomic) BUNativeExpressRewardedVideoAd *buRewardVideoAd;

@property (weak, nonatomic) UIViewController *parentVC;

@property (assign, nonatomic) BOOL isVideoLoaded;

@end

@implementation ZXAdHelper

+ (ZXAdHelper *)sharedInstance {
    static ZXAdHelper *adHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (adHelper == nil) {
            adHelper = [[ZXAdHelper alloc] init];
        }
    });
    return adHelper;
}

#pragma mark - 激励广告

//初始化腾讯rewardAd
- (void)fetchTencentRewardAdWithDelegate:(UIViewController *)viewController loadSucceedBlock:(void (^) (void))loadSucceedBlock {
    _parentVC = viewController;
    _zxRewardAdLoadSucceed = loadSucceedBlock;
    _rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:TencentAppID placementId:TencentReward];
    _rewardVideoAd.delegate = self;
    _rewardVideoAd.videoMuted = YES;
    [_rewardVideoAd loadAd];
}

//播放腾讯激励广告
- (void)playTencentRewardAdVideo {
    if (!_isVideoLoaded) {
        return;
    }
    if (!_rewardVideoAd.isAdValid) {
        [ZXProgressHUD loadFailedWithMsg:ERROR_MSG];
        return;
    }
    [_rewardVideoAd showAdFromRootViewController:_parentVC];
}

//初始化穿山甲rewardAd
- (void)fetchBURewardAdWithDelegate:(UIViewController *)viewController loadSucceedBlock:(void (^) (void))loadSucceedBlock {
    _parentVC = viewController;
    _zxRewardAdLoadSucceed = loadSucceedBlock;
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = @"111";
    _buRewardVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:BUADReward rewardedVideoModel:model];
    _buRewardVideoAd.delegate = self;
    [_buRewardVideoAd loadAdData];
}

//播放穿山甲激励广告
- (void)playBURewardAdVideo {
    if (!_isVideoLoaded) {
        return;
    }
    if (!_buRewardVideoAd.adValid) {
        [ZXProgressHUD loadFailedWithMsg:ERROR_MSG];
        return;
    }
    [_buRewardVideoAd showAdFromRootViewController:_parentVC];
//    [_buRewardVideoAd showAdFromRootViewController:_parentVC ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
}

#pragma mark - GDTRewardedVideoAdDelegate

//激励视频广告加载广告数据成功回调
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    _isVideoLoaded = YES;
    if (self.zxRewardAdLoadSucceed) {
        self.zxRewardAdLoadSucceed();
    }
}

//激励视频数据下载成功回调，已经下载过的视频会直接回调
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    
}

//激励视频播放页即将展示回调
- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd {
    
}

//激励视频广告曝光回调
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd {
    
}

//激励视频广告播放页关闭回调
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd {
    
}

//激励视频广告信息点击回调
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd {
    
}

//激励视频广告各种错误信息回调
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [ZXProgressHUD loadFailedWithMsg:ERROR_MSG];
    return;
//    if (error.code == 4014) {
//        [ZXProgressHUD loadFailedWithMsg:@"请拉取到广告后再调用展示接口"];
//        return;
//    }
//    if (error.code == 4016) {
//        [ZXProgressHUD loadFailedWithMsg:@"应用方向与广告位支持方向不一致"];
//        return;
//    }
//    if (error.code == 5012) {
//        [ZXProgressHUD loadFailedWithMsg:@"广告已过期"];
//        return;
//    }
//    if (error.code == 4015) {
//        [ZXProgressHUD loadFailedWithMsg:@"广告已经播放过，请重新拉取"];
//        return;
//    }
//    if (error.code == 5002) {
//        [ZXProgressHUD loadFailedWithMsg:@"视频下载失败"];
//        return;
//    }
//    if (error.code == 5003) {
//        [ZXProgressHUD loadFailedWithMsg:@"视频播放失败"];
//        return;
//    }
//    if (error.code == 5004) {
//        [ZXProgressHUD loadFailedWithMsg:@"没有合适的广告"];
//        return;
//    }
}

//激励视频广告播放达到激励条件回调，以此回调作为奖励依据
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd {
    NSLog(@"%s====>%@",__FUNCTION__, [NSDate date]);
}

//激励视频广告播放完成回调
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd {
    NSLog(@"%s====>%@",__FUNCTION__, [NSDate date]);
}

#pragma mark - BURewardedVideoAdDelegate

- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    _isVideoLoaded = YES;
    if (self.zxRewardAdLoadSucceed) {
        self.zxRewardAdLoadSucceed();
    }
    
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    [ZXProgressHUD loadFailedWithMsg:ERROR_MSG];
}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSLog(@"%s",__FUNCTION__);
    
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__FUNCTION__);
    
}

@end
