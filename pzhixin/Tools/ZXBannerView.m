//
//  ZXBannerView.m
//  pzhixin
//
//  Created by zhixin on 2019/6/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXBannerView.h"
#import "UtilsMacro.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define SELF_WIDTH self.bounds.size.width
#define SELF_HEIGHT self.bounds.size.height

#define PLAY_WIDTH 60.0
#define PLAY_HEIGHT 25.0

#define POSITION_WIDTH 40.0
#define POSITION_HEIGHT 20.0

@interface ZXBannerView () <UIScrollViewDelegate, SDCycleScrollViewDelegate> {
    UIScrollView *bannerScroll;
    ZFAVPlayerManager *playerManager;
//    UITapGestureRecognizer *tapImage;
    BOOL existVideo;
    UILabel *timeLabel;
    UILabel *positionLabel;
}

@end

@implementation ZXBannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
//        tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageActionWithTag:)];
//        [self createBannerScroll];
        [self createCycleScroll];
        [self initialization];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self createBannerScroll];
        [self createCycleScroll];
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _isPlaying = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_positionView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [UtilsMacro addCornerRadiusForView:_positionView andRadius:10.0 andCornes:UIRectCornerTopLeft | UIRectCornerBottomLeft];
}

#pragma mark - Private Methods

- (void)createCycleScroll {
    if (!_cycleScroll) {
        _cycleScroll = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENWIDTH)];
        [_cycleScroll setBackgroundColor:[UIColor whiteColor]];
        [_cycleScroll setPageControlStyle:SDCycleScrollViewPageContolStyleNone];
        [_cycleScroll setDelegate:self];
        [_cycleScroll setAutoScroll:YES];
        [_cycleScroll setPlaceholderImage:[UtilsMacro small_placeHolder]];
        [_cycleScroll setBannerImageViewContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_cycleScroll];
    }
}

- (void)createBannerScroll {
    if (!bannerScroll) {
        bannerScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENWIDTH)];
        [bannerScroll setPagingEnabled:YES];
        [bannerScroll setDelegate:self];
        [bannerScroll setShowsVerticalScrollIndicator:NO];
        [bannerScroll setShowsHorizontalScrollIndicator:NO];
    }
    [self addSubview:bannerScroll];
}

- (void)createPositionView {
//    _positionView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - POSITION_WIDTH, SCREENWIDTH - POSITION_HEIGHT - 26.0, POSITION_WIDTH, POSITION_HEIGHT)];
    _positionView = [[UIView alloc] init];
    [_positionView setClipsToBounds:YES];
    [_positionView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self addSubview:_positionView];
    [_positionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(-30.0);
        make.width.mas_equalTo(POSITION_WIDTH);
        make.height.mas_equalTo(POSITION_HEIGHT);
    }];
    
    if (!positionLabel) {
        positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, POSITION_WIDTH, POSITION_HEIGHT)];
        [positionLabel setTextAlignment:NSTextAlignmentCenter];
        [positionLabel setFont:[UIFont systemFontOfSize:10.0]];
        [positionLabel setTextColor:[UIColor whiteColor]];
        [positionLabel setBackgroundColor:[UIColor clearColor]];
        [positionLabel setText:[NSString stringWithFormat:@"1/%lu",(unsigned long)[_imgUrlList count]]];
    }
    [_positionView addSubview:positionLabel];
    [_positionView bringSubviewToFront:positionLabel];
}

////重置计时器
//- (void)invalidateTimer {
//    [_timer invalidate];
//    _timer = nil;
//}
//
////设置timer
//- (void)setupTimer {
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(bannerScrollAutoScroll) userInfo:nil repeats:YES];
//    _timer = timer;
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//}
//
//- (void)bannerScrollAutoScroll {
//    if ([_imgUrlList count] == 0) {
//        return;
//    }
//
//}

#pragma mark - Setter

- (void)setImgUrlList:(NSArray *)imgUrlList {
    _imgUrlList = imgUrlList;
//    for (int i = 0 ; i < [imgUrlList count]; i++) {
//        //创建&&添加UIImageView
//        [bannerScroll addSubview:[self createSubImageViewWithTag:i]];
//    }
//    [bannerScroll setContentSize:CGSizeMake(SCREENWIDTH * [imgUrlList count], SCREENWIDTH)];
    [_cycleScroll setImageURLStringsGroup:_imgUrlList];
    [self createPositionView];
}

- (UIImageView *)createSubImageViewWithTag:(int)tag {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(tag * SCREENWIDTH, 0.0, SCREENWIDTH, SCREENWIDTH)];
    [imageView setTag:tag];
    [imageView setUserInteractionEnabled:YES];
    [imageView setClipsToBounds:YES];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageActionWithTag:)];
    [imageView addGestureRecognizer:tapImage];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imgUrlList objectAtIndex:tag]]] imageView:imageView placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    return imageView;
}

//- (void)setVideoUrl:(NSString *)videoUrl {
//    _videoUrl = videoUrl;
//    //创建视频播放器
//    if (!_containerView) {
//        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENWIDTH)];
//        [bannerScroll addSubview:_containerView];
//    }
//
//    playerManager = [[ZFAVPlayerManager alloc] init];
//    if (!_controllView) {
//        _controllView = [ZFPlayerControlView new];
//    }
//
//    _player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:_containerView];
//    [_player setDisableGestureTypes:(ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch)];
//    [_player setControlView:_controllView];
//    if (videoUrl) {
//        existVideo = YES;
//        _playView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - PLAY_WIDTH)/2.0, SCREENWIDTH - PLAY_HEIGHT - 20.0, PLAY_WIDTH, PLAY_HEIGHT)];
//        [_playView setBackgroundColor:[UIColor clearColor]];
//        [_playView setUserInteractionEnabled:YES];
//        if ([UtilsMacro whetherIsEmptyWithObject:self.videoUrl]) {
//            [_playView setHidden:YES];
//        } else {
//            [_playView setHidden:NO];
//        }
//        UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVieo)];
//        [_playView addGestureRecognizer:tapPlay];
//        [self addSubview:_playView];
//
//        UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, PLAY_WIDTH, PLAY_HEIGHT)];
//        [backImg setContentMode:UIViewContentModeScaleAspectFill];
//        [backImg setImage:[UIImage imageNamed:@"ic_play_video"]];
//        [_playView addSubview:backImg];
//
//        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(23.0, 0.0, PLAY_WIDTH - 25.0, PLAY_HEIGHT)];
//        [timeLabel setFont:[UIFont systemFontOfSize:9.0]];
//        if ([UtilsMacro whetherIsEmptyWithObject:self.videoUrl]) {
//            [timeLabel setHidden:YES];
//            [timeLabel setText:@""];
//        } else {
//            [timeLabel setHidden:NO];
//
//            NSInteger totalSeconds = [UtilsMacro getVideoTimeByUrlString:_videoUrl];
//            NSString *minuteStr;
//            if (floor(totalSeconds/60.0) > 0) {
//                minuteStr = [NSString stringWithFormat:@"0%f", floor(totalSeconds/60.0)];
//            } else {
//                minuteStr = @"00";
//            }
//            NSString *secondStr = [NSString stringWithFormat:@"%d", (int)totalSeconds % 60];
//            if (secondStr.length < 2) {
//                secondStr = [NSString stringWithFormat:@"0%@",secondStr];
//            }
//            [timeLabel setText:[NSString stringWithFormat:@"%@′%@″",minuteStr, secondStr]];
//        }
//        [timeLabel setTextColor:[UIColor whiteColor]];
//        [timeLabel setBackgroundColor:[UIColor clearColor]];
//        [timeLabel setTextAlignment:NSTextAlignmentCenter];
//        [_playView addSubview:timeLabel];
//
//    } else {
//        existVideo = NO;
//    }
//}

- (void)leftSwipe {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxBannerViewLeftSwipe)]) {
        [self.delegate zxBannerViewLeftSwipe];
    }
    _currentTime = [_player currentTime];
    [_player stop];
    [UtilsMacro addPositionAnimationWithFromValue:[NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH/2.0, SCREENWIDTH/2.0)] andToValue:[NSValue valueWithCGPoint:CGPointMake(-SCREENWIDTH/2.0, SCREENWIDTH/2.0)] andView:_containerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.containerView setAlpha:0.0];
        [self.containerView.layer removeAnimationForKey:@"position"];
        [self.positionView setHidden:NO];
        [self.playView setHidden:NO];
        [self.cycleScroll setAutoScroll:YES];
    });
}

- (void)rightSwipe {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxBannerViewRightSwipe)]) {
        [self.delegate zxBannerViewRightSwipe];
    }
    _currentTime = [_player currentTime];
    [_player stop];
    [UtilsMacro addPositionAnimationWithFromValue:[NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH/2.0, SCREENWIDTH/2.0)] andToValue:[NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH + SCREENWIDTH/2.0, SCREENWIDTH/2.0)] andView:_containerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.containerView setAlpha:0.0];
        [self.containerView.layer removeAnimationForKey:@"position"];
        [self.positionView setHidden:NO];
        [self.playView setHidden:NO];
        [self.cycleScroll setAutoScroll:YES];
    });
}

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    //创建视频播放器
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, SCREENWIDTH)];
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
        [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_containerView addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
        [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [_containerView addGestureRecognizer:rightSwipe];
        [_containerView setAlpha:0.0];
        [_containerView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_containerView];
    }
    
    playerManager = [[ZFAVPlayerManager alloc] init];
    if (!_controllView) {
        _controllView = [ZFPlayerControlView new];
    }
    
    _player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:_containerView];
    [_player setStopWhileNotVisible:YES];
    [_player setDisableGestureTypes:(ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch)];
    [_player setOrientationWillChange:^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        if (!isFullScreen) {
            [player setDisableGestureTypes:(ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch)];
        } else {
            [player setDisableGestureTypes:ZFPlayerDisableGestureTypesNone];
        }
    }];
    [_player setControlView:_controllView];
    if (videoUrl) {
        existVideo = YES;
        _playView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - PLAY_WIDTH)/2.0, SCREENWIDTH - PLAY_HEIGHT - 20.0, PLAY_WIDTH, PLAY_HEIGHT)];
        [_playView setBackgroundColor:[UIColor clearColor]];
        [_playView setUserInteractionEnabled:YES];
        if ([UtilsMacro whetherIsEmptyWithObject:self.videoUrl]) {
            [_playView setHidden:YES];
        } else {
            [_playView setHidden:NO];
        }
        UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVieo)];
        [_playView addGestureRecognizer:tapPlay];
        [self addSubview:_playView];
        
        UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, PLAY_WIDTH, PLAY_HEIGHT)];
        [backImg setContentMode:UIViewContentModeScaleAspectFill];
        [backImg setImage:[UIImage imageNamed:@"ic_play_video"]];
        [_playView addSubview:backImg];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(23.0, 0.0, PLAY_WIDTH - 25.0, PLAY_HEIGHT)];
        [timeLabel setFont:[UIFont systemFontOfSize:9.0]];
        if ([UtilsMacro whetherIsEmptyWithObject:self.videoUrl]) {
            [timeLabel setHidden:YES];
            [timeLabel setText:@""];
        } else {
            [timeLabel setHidden:NO];
            
            NSInteger totalSeconds = [UtilsMacro getVideoTimeByUrlString:_videoUrl];
            NSString *minuteStr;
            if (floor(totalSeconds/60.0) > 0) {
                minuteStr = [NSString stringWithFormat:@"0%f", floor(totalSeconds/60.0)];
            } else {
                minuteStr = @"00";
            }
            NSString *secondStr = [NSString stringWithFormat:@"%d", (int)totalSeconds % 60];
            if (secondStr.length < 2) {
                secondStr = [NSString stringWithFormat:@"0%@",secondStr];
            }
            [timeLabel setText:[NSString stringWithFormat:@"%@′%@″",minuteStr, secondStr]];
        }
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [_playView addSubview:timeLabel];
        
    } else {
        existVideo = NO;
    }
}

//- (void)setAutoScroll:(BOOL)autoScroll {
//    _autoScroll = autoScroll;
//    [self invalidateTimer];
//    if (_autoScroll) {
//
//    }
//}

#pragma mark - UITapGestureRecognizer

//图片点击
- (void)handleTapImageActionWithTag:(UITapGestureRecognizer *)recognizer {
    UIView *tapView = recognizer.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxBannerView:withImgTag:)]) {
        [self.delegate zxBannerView:self withImgTag:tapView.tag];
    }
}

//播放按钮点击
- (void)playVieo {
    [_cycleScroll setAutoScroll:NO];
    [_containerView setAlpha:1.0];
    NSString *URLString = [_videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    playerManager.assetURL = [NSURL URLWithString:URLString];
    [_player seekToTime:_currentTime completionHandler:^(BOOL finished) {}];
    [_positionView setHidden:YES];
    [_playView setHidden:YES];
    _isPlaying = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxBannerViewPlayVideo)]) {
        [self.delegate zxBannerViewPlayVideo];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = bannerScroll.contentOffset.x;
    int index = (int)offsetX/SCREENWIDTH;
    if (index != 0) {
        if (_isPlaying) {
            [_player stop];
            _isPlaying = NO;
            [_positionView setHidden:NO];
            [_playView setHidden:NO];
        }
    } else {
        if (_isPlaying) {
            [_positionView setHidden:YES];
            [_playView setHidden:YES];
        } else {
            [_positionView setHidden:NO];
            [_playView setHidden:NO];
        }
    }
    [positionLabel setText:[NSString stringWithFormat:@"%d/%lu",index + 1, (unsigned long)[_imgUrlList count]]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxBannerViewScrollViewDidScroll:)]) {
        [self.delegate zxBannerViewScrollViewDidScroll:scrollView];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    [positionLabel setText:[NSString stringWithFormat:@"%ld/%lu",index + 1, (unsigned long)[_imgUrlList count]]];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxBannerView:withImgTag:)]) {
        [self.delegate zxBannerView:self withImgTag:index];
    }
}

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    
}

@end
