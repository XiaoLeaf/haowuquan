//
//  ZXPhotoBrowser.m
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXPhotoBrowser.h"
#import <LBXScan/ZXingWrapper.h>
#import <LBXScan/LBXScanTypes.h>
#import "StyleDIY.h"

static ZXPhotoBrowser *photoBrowser = nil;

@interface ZXPhotoBrowser () {
    NSArray *imageList;
    UIViewController *homeVC;
}

@property (strong, nonatomic) YBImageBrowser *browser;

@property (strong, nonatomic) NSArray *thumbUrlList;

@property (strong, nonatomic) YBIBToolViewHandler *toolBar;

@end

@implementation ZXPhotoBrowser

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (ZXPhotoBrowser *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (photoBrowser == nil) {
            photoBrowser = [[ZXPhotoBrowser alloc] init];
        }
    });
    return photoBrowser;
}

#pragma mark - Public Methods

- (void)showPhotoBrowserWithImgList:(NSArray *)imgList currentIndex:(NSInteger)index andThumdList:(NSArray *)thumbList {
    imageList = imgList;
    _thumbUrlList = thumbList;
    _browser = [YBImageBrowser new];
    _toolBar = [YBIBToolViewHandler new];
    [_toolBar.topView.operationButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_toolBar.topView.operationButton setTitle:@"保存" forState:UIControlStateNormal];
    [_toolBar.topView.operationButton setImage:[UIImage new] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    _toolBar.topView.clickOperation = ^(YBIBTopViewOperationType type) {
        [weakSelf.browser.currentData yb_saveToPhotoAlbum];
    };
    [_browser setToolViewHandlers:@[_toolBar]];
    _browser.delegate = self;
    [_browser setDataSource:self];
    _browser.currentPage = index;
    [_browser show];
}

#pragma mark - YBImageBrowserDelegate && YBImageBrowserDataSource

- (NSInteger)yb_numberOfCellsInImageBrowser:(YBImageBrowser *)imageBrowser {
    return [imageList count];
}

- (id<YBIBDataProtocol>)yb_imageBrowser:(YBImageBrowser *)imageBrowser dataForCellAtIndex:(NSInteger)index {
    YBIBImageData *cellData = [YBIBImageData new];
    if ([[imageList objectAtIndex:index] isKindOfClass:[NSString class]]) {
        [cellData setImageURL:[NSURL URLWithString:[imageList objectAtIndex:index]]];
    } else {
        cellData.image = ^UIImage * _Nullable{
            return [self->imageList objectAtIndex:index];
        };
    }
    if ([_thumbUrlList count] > index) {
        [cellData setThumbURL:[NSURL URLWithString:[_thumbUrlList objectAtIndex:index]]];
    }
    [cellData.defaultLayout setMaxZoomScale:2.2];
    return cellData;
}

- (void)yb_imageBrowser:(YBImageBrowser *)imageBrowser respondsToLongPressWithData:(id<YBIBDataProtocol>)data {
    BOOL checkResult = [UtilsMacro checkQRCodeWithData:data];
    if (checkResult) {
        YBIBSheetView *alert = [YBIBSheetView new];
        YBIBSheetAction *discern;
        discern = [YBIBSheetAction actionWithName:@"识别图中二维码" action:^(id<YBIBDataProtocol> data) {
            UIImage *image;
            if ([[self->imageList objectAtIndex:[imageBrowser currentPage]] isKindOfClass:[NSString class]]) {
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self->imageList objectAtIndex:[imageBrowser currentPage]]]]];
            } else {
                image = [self->imageList objectAtIndex:[imageBrowser currentPage]];
            }
            [ZXingWrapper recognizeImage:image block:^(ZXBarcodeFormat barcodeFormat, NSString *str) {
                LBXScanResult *result = [[LBXScanResult alloc]init];
                result.strScanned = str;
                result.imgScanned = image;
                result.strBarCodeType = [StyleDIY convertZXBarcodeFormat:barcodeFormat];
                [self scanResultWithArray:@[result]];

            }];
            [alert hideWithAnimation:YES];
        }];
        if (checkResult) {
            [alert.actions addObject:discern];
        }
        [alert showToView:_toolBar.yb_containerView orientation:_toolBar.yb_currentOrientation()];
    } else {
        return;
    }
}

- (void)yb_imageBrowserDismiss:(YBImageBrowser *)imageBrowser {
    if (self.browserDismissBlock) {
        self.browserDismissBlock();
    }
}

#pragma mark - Private Metdods

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    if (array.count < 1){
        return;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    LBXScanResult *scanResult = array[0];
    NSString *strResult = scanResult.strScanned;
    NSLog(@"strResult:%@",strResult);
}

@end
