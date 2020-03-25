//
//  ZXScanViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/27.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScanViewController.h"
#import "LBXScanVideoZoomView.h"
#import "UtilsMacro.h"
#import "StyleDIY.h"
#import <Masonry/Masonry.h>

@interface ZXScanViewController ()

@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@end

@implementation ZXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNav];
    self.fd_prefersNavigationBarHidden = YES;
    [self setStyle:[StyleDIY ZhiFuBaoStyle]];
    [self setIsOpenInterestRect:YES];
    [self setLibraryType:SLT_ZXing];
    [self setCameraInvokeMsg:@"相机启动中"];
    [self drawBottomItems];
    [self.view bringSubviewToFront:_topTitle];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor clearColor]];
//    [self drawScanView];
//    [self startScan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:_customNav];
    [self.view bringSubviewToFront:_btnFlash];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:BG_COLOR];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)createCustomNav {
    __weak typeof(self) weakSelf = self;
    if (!_customNav) {
        _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_back_white"] title:@"" titleColor:[UIColor blackColor] rightContent:@"相册" leftDot:NO];
        [_customNav setBackgroundColor:[UIColor clearColor]];
        _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
            [weakSelf openLocalPhoto:NO];
        };
        [self.view addSubview:_customNav];
        [_customNav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0.0);
            make.height.mas_equalTo(STATUS_HEIGHT + NAVIGATION_HEIGHT);
        }];
    }
}

#pragma mark - LBXScan

//绘制扫描区域
- (void)drawTitle {
    if (!_topTitle) {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 ) {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}

- (void)cameraInitOver {
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView {
    if (!_zoomView) {
        CGRect frame = self.view.frame;
        int XRetangleLeft = self.style.xScanRetangleOffset;
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        if (self.style.whRatio != 1) {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            sizeRetangle = CGSizeMake(w, h);
        }
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value) {
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    return _zoomView;
}

- (void)tap {
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems {
    CGRect frame = self.view.frame;
    int XRetangleLeft = self.style.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
    CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    self.btnFlash = [[UIButton alloc] init];
    _btnFlash.frame = CGRectMake(sizeRetangle.width/2.0 - 32.5 + self.style.xScanRetangleOffset, YMaxRetangle + 40, 65.0, 87.0);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFlash];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    if (array.count < 1){
        [self reStartDevice];
        return;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    LBXScanResult *scanResult = array[0];
    NSString *strResult = scanResult.strScanned;
    if ([UtilsMacro whetherIsEmptyWithObject:strResult]) {
        [ZXProgressHUD loadFailedWithMsg:@"未扫描到二维码/条形码"];
        return;
    }
    if (self.zxScanVCResultBlock) {
        [self.navigationController popViewControllerAnimated:YES];
        self.zxScanVCResultBlock(strResult);
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXSearchHelper sharedInstance] fetchSearchGoodsWithContent:strResult andFrom:[NSString stringWithFormat:@"%d", FROM_SCAN] completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
//            NSLog(@"response:%@",response.data);
            [UtilsMacro phoneShake];
            ZXCommonSearch *commonSearch = [ZXCommonSearch yy_modelWithJSON:response.data];
            NSDictionary *userInfo = @{@"commonSearch":commonSearch, @"closeBlock":^(void) {
                [self reStartDevice];
            }};
            switch (commonSearch.type) {
                case 1:
                {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_TOAST_POP] andUserInfo:userInfo viewController:self];
                }
                    break;
                case 2:
                {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, HOME_SEARCH_POP] andUserInfo:userInfo viewController:self];
                }
                    break;
                case 3:
                {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, commonSearch.url_schema] andUserInfo:nil viewController:self];
                }
                    break;
                    
                default:
                {
                    [self reStartDevice];
                }
                    break;
            }
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            [self reStartDevice];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        [self reStartDevice];
        return;
    }
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto {
    [self openLocalPhoto:YES];
}

//开关闪光灯
- (void)openOrCloseFlash {
    [super openOrCloseFlash];
    if (self.isOpenFlash) {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    } else {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
}

@end
