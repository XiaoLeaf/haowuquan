//
//  ZXBannerView.h
//  pzhixin
//
//  Created by zhixin on 2019/6/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXBannerViewDelegate;

@interface ZXBannerView : UIView

//传入的图片地址数组
@property (strong, nonatomic) NSArray *imgUrlList;

//原图地址
@property (strong, nonatomic) NSArray *orignalList;

//视频地址========（在传入图片数组前调用）
@property (strong, nonatomic) NSString *videoUrl;

//视频播放器
@property (strong, nonatomic) ZFPlayerController *player;

@property (strong, nonatomic, nullable) UIView *containerView;

@property (strong, nonatomic) ZFPlayerControlView *controllView;

@property (assign, nonatomic) NSTimeInterval currentTime;

@property (strong, nonatomic) UIView *playView;

@property (strong, nonatomic) UIView *positionView;

@property (strong, nonatomic) SDCycleScrollView *cycleScroll;

//是否正在播放视频
@property (assign, nonatomic) BOOL isPlaying;

////是否开启自动轮播
//@property (assign, nonatomic) BOOL autoScroll;
//
////轮播时间间隙
//@property (assign, nonatomic) CGFloat duration;
//
//@property (weak, nonnull) NSTimer *timer;

@property (strong, nonatomic) id <ZXBannerViewDelegate>delegate;

@end

@protocol ZXBannerViewDelegate <NSObject>

- (void)zxBannerView:(ZXBannerView *)bannerView withImgTag:(NSInteger)imgTag;

- (void)zxBannerViewPlayVideo;

- (void)zxBannerViewLeftSwipe;

- (void)zxBannerViewRightSwipe;

- (void)zxBannerViewScrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
