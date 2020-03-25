//
//  UtilsMacro.h
//  zhixin
//
//  Created by zhixin on 16/3/2.
//  Copyright © 2016年 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppMacro.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import <GTMBase64/GTMBase64.h>
#include <stdio.h>
#include <stdlib.h>
#import <YBImageBrowser/YBImageBrowser.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ImageIO/ImageIO.h>
#import "ZXLoadingAsset.h"
#import <LBXScan/ZXingWrapper.h>
//#import <PGDatePicker/PGDatePickManager.h>

#define kDefaultIP @"service.bestwin.net"

#define kYNIdentifier @"kYNIdentifier"

NS_ASSUME_NONNULL_BEGIN

@interface UtilsMacro : NSObject

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor

+ (UIColor *_Nonnull)colorWithHexString:(NSString *_Nonnull)color;

#pragma mark - 手机号码验证

+ (BOOL)validatePhoneNumber:(NSString *_Nonnull)phone;

#pragma mark - 网络状态监测

+ (BOOL)isCanReachableNetWork;

#pragma mark - 设备型号检测

+ (BOOL)currentDeviceVersionModel;

#pragma mark - 判断对象是否为空值

+ (BOOL)whetherIsEmptyWithObject:(id _Nonnull)obj;

+ (NSString * _Nonnull)DataTOjsonString:(id _Nonnull)object;

#pragma mark - 添加缩放动画

+ (void)addBasicAnimationForViewWithFromValue:(id)fromValue andToValue:(id)toValue andView:(UIView *)view endRemove:(BOOL)remove;

+ (CABasicAnimation * _Nonnull)creatTransformScaleAnimationWithFromValue:(id _Nonnull)fromValue andToValue:(id _Nonnull)toValue;

+ (void)addWidthAnimationForViewWithFromValue:(id _Nonnull)fromValue andToValue:(id _Nonnull)toValue andView:(UIView * _Nonnull)view endRemove:(BOOL)remove;

#pragma mark - 背景色渐变动画

+ (void)addBackgoundColorAnimationForViewWithFrom:(id)fromValue toValue:(id)toValue view:(UIView *)view endRemove:(BOOL)remove;

#pragma mark - 添加位移动画

+ (void)addPositionAnimationWithFromValue:(id)fromValue andToValue:(id)toValue andView:(UIView *)view;

+ (CABasicAnimation *)creatPositionAnimationWithFromValue:(id)fromValue andToValue:(id)toValue;

+ (void)addKeyFrameAnimationWithValues:(NSArray *)values forView:(UIView *)view;

+ (CAKeyframeAnimation *)creatKeyFrameAnimationWithValues:(NSArray *)values;

#pragma mark - 新建翻转动画

+ (void)addRotationAnimationWithFromValue:(id)fromValue AndToValue:(id)toValue andView:(UIView *)view andDuration:(CFTimeInterval)duration;

+ (CABasicAnimation *)creatRotationAnimationWithFromValue:(id)fromValue AndToValue:(id)toValue;

+ (void)addRotationAnimationWithFrom:(id)fromValue toValue:(id)toValue view:(UIView *)view duration:(CFTimeInterval)duration;

#pragma mark - 新建透明度动画

+ (void)addOpacityAnimationFromValue:(id)fromValue toValue:(id)toValue andView:(UIView *)view andDuration:(CFTimeInterval)duration;

#pragma mark - 添加组合动画

+ (void)addGroupAnimationWithGroupAnimations:(NSArray *)groups AndView:(UIView *)view;

#pragma mark - 添加UIViewAnimation

+ (void)addViewAnimationWithFinalFrame:(CGRect)newFrame andView:(UIView *)view;

#pragma mark - 根据日期计算当前是周几

+ (NSString*)weekdayStringFromDate:(NSString *)inputDate;

#pragma mark - 为View的特定角添加圆角

+ (void)addCornerRadiusForView:(UIView *)view andRadius:(CGFloat)radius andCornes:(UIRectCorner)corners;

#pragma mark - 两个日期的比较

+ (BOOL)compareFirtstDate:(NSString*)firstDate withSecondDate:(NSString*)secondDate;

#pragma mark -  两个时间点的比较

+ (BOOL)compareStartTime:(NSString *)startTime withEndTime:(NSString *)endTime;

#pragma mark - 十进制转十六进制

+ (NSString *)toHex:(long long int)tmpid;

#pragma mark - 根据日期算出当前的周数

+ (NSInteger)getWeekCountInYearWithDate:(NSDate *)date;

#pragma mark - 计算文字高度

+ (CGFloat)heightForString:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width;

+ (CGFloat)heightForString2:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width;

+ (CGFloat)heightForString3:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width;

#pragma mark - 计算文字宽度

+ (CGFloat)widthForString:(NSString *)value font:(UIFont *)font andHeight:(CGFloat)height;

+ (CGRect)widthForString2:(NSString *)value font:(UIFont *)font andHeight:(CGFloat)height;

//#pragma mark - 根据图片的URL获取size
//
//+ (CGSize)getImageSizeWithURL:(id)URL;

#pragma mark - 获取设备IP地址

+(NSString *)getIPAddress;

#pragma mark - SHA1编码

+ (NSString *)sha1WithString:(NSString *)str;

#pragma mark - 3DES加密

+ (NSString *)doEncryptStr:(NSString *)originalStr;

#pragma mark - 3DES解密

+ (NSString*)doDecEncryptStr:(NSString *)encryptStr;

#pragma mark - 获取随机数

+ (NSString *)creatRandNum;

#pragma mark - 获取当前时间戳（13位）

+ (NSString *)getNowTimeTimestamp;

+ (NSString *)getDateTimeToMilliSeconds;

#pragma mark - 照片获取本地路径转换

+ (NSString *)getImagePath:(UIImage *)Image;

#pragma mark - 获取当前时间 格式yyyy-MM-dd

+ (NSString *)fetchCurrentDate;

#pragma mark - 获取当前月份 格式yyyy-MM

+ (NSString *)fetchCurrentMonth;

#pragma mark - 国际时间转换为yyyy-MM-dd

+ (NSString *)GMTTimeToNormalTimeWithTimeStr:(NSString *)timeStr;

#pragma mark - 时间戳转时间 yyyy-MM-dd HH:mm

+ (NSString *)timeStampToDateStrWithStamp:(NSString *)timeStamp;

#pragma mark - 时间戳转时间 HH:mm

+ (NSString *)timeStampToHourMinuteWithStamp:(NSString *)timeStamp;

#pragma mark - 获取当前时间 格式 HH:mm:ss

+ (NSString *)fetchCurrentHourMinute;

#pragma mark - 获取当前时间的秒的个位数

+ (NSInteger)fetchCurrentSecondSingleDigit;

#pragma mark - MD5加密

+ (NSString *)MD5ForLower32Bate:(NSString *)str;

#pragma mark - 添加View的顶部阴影

+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor;

#pragma mark - NSDictionary根据key值排序

+ (NSString *)sortedDictionary:(NSDictionary *)dict;

#pragma mark - 获取UUID

+ (NSString *)fetchUUID;

#pragma mark - 绘制虚线

+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

#pragma mark - 计算缓存大小

+ (NSString *)getCachesSize;

#pragma mark - 清除缓存

+ (void)removeCache;

#pragma mark - 文本的行字间距

+ (NSDictionary *)contentAttributes;

#pragma mark - 淘宝二次账号授权

+ (void)taobaoSecAuthWithCode:(NSString *)authCode;

#pragma mark - 检测图片是否有二维码

+ (BOOL)checkQRCodeWithData:(YBIBImageData *)data;

#pragma mark - 获取视频的时长

+ (NSInteger)getVideoTimeByUrlString:(NSString*)urlString;

#pragma mark - 获取运营商

+ (NSString *)getCarrierName;

#pragma mark - 获取网络图片size

+ (CGSize)getImageSizeWithURL:(id)URL;

#pragma mark - 获取当前日期后N天的日期

+ (NSArray *)fetchFutureDatesWithNum:(NSInteger)num;

#pragma mark - ScrollView的BackgroundView

+ (UIView *)createBgViewWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

#pragma mark - 统一的UIAlertController

+ (UIAlertController *)zxAlertControllerWithTitle:(NSString *_Nullable)title andMessage:(NSString *_Nullable)message style:(UIAlertControllerStyle)style andAction:(NSArray *)actions alertActionClicked:(void (^) (NSInteger actionTag))actionClicked;

#pragma mark - 淘宝授权相关

+ (void)taobaoAuthWithAuthCodeBlock:(void(^) (NSString *codeStr))authBlock;

+ (void)taobaoLogout;

#pragma mark - 导航栏相关

+ (UIButton *)createLeftBarButtonWithImage:(UIImage *)image;

+ (UIButton *)createLeftBarButtonWithTitle:(NSString *)title andFont:(UIFont *)font andColor:(UIColor *)color;

+ (UIButton *)createRightBarButtonWithImage:(UIImage *)image single:(BOOL)single;

+ (UIButton *)createRighttBarButtonWithTitle:(NSString *)title andFont:(UIFont *)font andColor:(UIColor *)color single:(BOOL)single;

//#pragma mark - 创建时间选择器

//+ (PGDatePickManager *)createDatePickManager;

#pragma mark - 自定义导航栏

+ (UIView *)customNavigationViewWithLeftContent:(id)left title:(NSString *)title titleColor:(UIColor *)color andRightContent:(id)right;

#pragma mark - 系统粘贴板复制

+ (void)generalPasteboardCopy:(NSString *)str;

#pragma mark - 图片渐显

+ (void)zxSD_setImageWithURL:(nullable NSURL *)url imageView:(UIImageView *_Nullable)imageView placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock;

//#pragma mark - 根据开始和结束时间计算年份数和月份数
//
//+ (void)fetchYearsAndMonthesWithS_time:(NSString *_Nonnull)s_time andE_time:(NSString *_Nonnull)e_time;

#pragma mark - Small_PlaceHolder

+ (UIImage *)small_placeHolder;

#pragma mark - Big_PlaceHolder

+ (UIImage *)big_placeHolder;

#pragma mark - 预加载loading资源图片

+ (void)preloadLoadingAssetsWithLoadingAsset:(ZXLoadingAsset *_Nonnull)loadingAsset;

#pragma mark - 生成二维码图片

+ (UIImage *_Nonnull)qrCodeImgWithContent:(NSString *_Nonnull)content size:(CGSize)size;

#pragma mark - 获取顶层VC

+ (UIViewController *_Nonnull)topViewController;

#pragma mark - 手机振动

+ (void)phoneShake;

#pragma mark - 打开淘宝授权弹窗

+ (void)openTBAuthViewWithVC:(UIViewController *_Nonnull)vc completion:(void(^)(void))completionBlock;

#pragma mark - 打开日期选择器

+ (void)openZXDatePickerWithViewController:(UIViewController *_Nonnull)vc datePickerResultBlock:(void (^_Nonnull) (NSString * _Nonnull resultStr))resultBlock;

#pragma mark - 颜色相关

+ (NSArray *_Nonnull)getRGBDictionaryByColor:(UIColor *_Nonnull)originColor;

+ (NSArray *_Nonnull)transColorBeginColor:(UIColor *_Nonnull)beginColor andEndColor:(UIColor *)endColor;

+ (UIColor *_Nonnull)getColorWithColor:(UIColor *_Nonnull)beginColor andCoe:(double)coe  andEndColor:(UIColor *)endColor;

#pragma mark - APP版本检查更新

+ (void)checkAppVersionUpdateWithViewController:(UIViewController *)viewController needToast:(BOOL)needToast;

#pragma mark - 存储退到后台时的当前时间戳

+ (void)saveEnterBackgroundTimeStamp;

#pragma mark - 比较进入到前台的时间戳和存储的时间戳是否需要展示开屏广告

+ (BOOL)checkWhetherNeedSplashAd;

NS_ASSUME_NONNULL_END

@end
