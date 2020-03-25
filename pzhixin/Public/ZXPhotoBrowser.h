//
//  ZXPhotoBrowser.h
//  pzhixin
//
//  Created by zhixin on 2019/7/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXPhotoBrowserDismissBlock)(void);

@protocol ZXPhotoBrowserDelegate;

@interface ZXPhotoBrowser : NSObject <YBImageBrowserDelegate, YBImageBrowserDataSource>

+ (ZXPhotoBrowser *)sharedInstance;

@property (copy, nonatomic) ZXPhotoBrowserDismissBlock browserDismissBlock;

#pragma mark - Public Methods

- (void)showPhotoBrowserWithImgList:(NSArray *)imgList currentIndex:(NSInteger)index andThumdList:(NSArray *)thumbList;

- (void)showPhotoBrowserWithImgList:(NSArray *)imgList currentIndex:(NSInteger)index andThumdList:(NSArray *)thumbList dismissBlock:(void (^) (void))dismissBlock;

@end

NS_ASSUME_NONNULL_END
