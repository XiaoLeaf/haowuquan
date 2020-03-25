//
//  UtilsMacro.m
//  HTG
//
//  Created by Shareted on 16/3/2.
//  Copyright © 2016年 Shareted. All rights reserved.
//

#import "UtilsMacro.h"
#import "AppMacro.h"
#import "Reachability.h"
#import <sys/utsname.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <AlibabaAuthSDK/ALBBSDK.h>

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define UPGRADE_TIME @"UPGRADE_TIME"

static UIView *progressBacgroundView;


@implementation UtilsMacro


#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark - 手机号码验证

+ (BOOL)validatePhoneNumber:(NSString *)phone {
//    NSString *phoneRegex = @"^((13[0-9])|(14[4-8])|(15([0-3]|[5-9]))|(166)|(17[0|8])|(18[0-9]|(19[8|9])))\\d{8}$";
    NSString *phoneRegex = @"^((13[0-9])|(14[4-8])|(15([0-3]|[5-9]))|(166)|(17[0|8])|(18[0-9]|(19[8|9])))\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (BOOL)isCanReachableNetWork {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"internet" object:@NO];
            return NO;
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"internet" object:@YES];
            return YES;
            break;
            
        default:
            break;
    }
}

+ (BOOL)currentDeviceVersionModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"] || [deviceString isEqualToString:@"iPhone3,2"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)whetherIsEmptyWithObject:(id)obj {
    if (obj == [NSNull null] || obj == nil || [@"" isEqual:obj] || [@"<null>" isEqual:obj] || [obj isEqual:@"ISNULL"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - 新建缩放动画

+ (void)addBasicAnimationForViewWithFromValue:(id)fromValue andToValue:(id)toValue andView:(UIView *)view endRemove:(BOOL)remove {
    CABasicAnimation *shrinkAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrinkAni.fromValue = fromValue;
    shrinkAni.toValue = toValue;
    shrinkAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shrinkAni.removedOnCompletion = remove;
    shrinkAni.duration = 0.2;
    shrinkAni.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:shrinkAni forKey:@"transform.scale"];
}

+ (CABasicAnimation *)creatTransformScaleAnimationWithFromValue:(id)fromValue andToValue:(id)toValue {
    CABasicAnimation *transformAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAni.fromValue = fromValue;
    transformAni.toValue = toValue;
    transformAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transformAni.removedOnCompletion = NO;
    transformAni.duration = 0.2;
    transformAni.fillMode = kCAFillModeForwards;
    return transformAni;
}

+ (void)addWidthAnimationForViewWithFromValue:(id)fromValue andToValue:(id)toValue andView:(UIView *)view endRemove:(BOOL)remove {
    CABasicAnimation *shrinkAni = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAni.fromValue = fromValue;
    shrinkAni.toValue = toValue;
    shrinkAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shrinkAni.removedOnCompletion = remove;
    shrinkAni.duration = 0.2;
    shrinkAni.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:shrinkAni forKey:@"bounds.size.width"];
}

#pragma mark - 背景色渐变动画

+ (void)addBackgoundColorAnimationForViewWithFrom:(id)fromValue toValue:(id)toValue view:(UIView *)view endRemove:(BOOL)remove {
    CABasicAnimation *shrinkAni = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    shrinkAni.fromValue = fromValue;
    shrinkAni.toValue = toValue;
    shrinkAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shrinkAni.removedOnCompletion = remove;
    shrinkAni.duration = 0.5;
    shrinkAni.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:shrinkAni forKey:@"backgroundColor"];
}

#pragma mark - 新建位移动画

+ (void)addPositionAnimationWithFromValue:(id)fromValue andToValue:(id)toValue andView:(UIView *)view {
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.fromValue = fromValue;
    positionAni.toValue = toValue;
    positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    positionAni.removedOnCompletion = NO;
    positionAni.duration = 0.2;
    positionAni.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:positionAni forKey:@"position"];
}

+ (CABasicAnimation *)creatPositionAnimationWithFromValue:(id)fromValue andToValue:(id)toValue {
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.fromValue = fromValue;
    positionAni.toValue = toValue;
    positionAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    positionAni.removedOnCompletion = NO;
    positionAni.duration = 0.2;
    positionAni.fillMode = kCAFillModeForwards;
    return positionAni;
}

+ (void)addKeyFrameAnimationWithValues:(NSArray *)values forView:(UIView *)view {
    CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animation];
    keyFrameAni.removedOnCompletion = NO;
    keyFrameAni.keyPath = @"position";
    keyFrameAni.duration = 0.2;
    keyFrameAni.fillMode = kCAFillModeForwards;
    keyFrameAni.values = values;
    keyFrameAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [view.layer addAnimation:keyFrameAni forKey:@"position"];
}

+ (CAKeyframeAnimation *)creatKeyFrameAnimationWithValues:(NSArray *)values {
    CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animation];
    keyFrameAni.removedOnCompletion = NO;
    keyFrameAni.keyPath = @"position";
    keyFrameAni.duration = 0.2;
    keyFrameAni.fillMode = kCAFillModeForwards;
    keyFrameAni.values = values;
    keyFrameAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return keyFrameAni;
}

#pragma mark - 新建翻转动画

+ (void)addRotationAnimationWithFromValue:(id)fromValue AndToValue:(id)toValue andView:(UIView *)view andDuration:(CFTimeInterval)duration {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.duration = duration;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basicAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:basicAnimation forKey:@"transform.rotation"];
}

+ (CABasicAnimation *)creatRotationAnimationWithFromValue:(id)fromValue AndToValue:(id)toValue {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basicAnimation.fillMode = kCAFillModeForwards;
    return basicAnimation;
}

+ (void)addRotationAnimationWithFrom:(id)fromValue toValue:(id)toValue view:(UIView *)view duration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"transform.rotation.z"];
}

#pragma mark - 新建透明度动画

+ (void)addOpacityAnimationFromValue:(id)fromValue toValue:(id)toValue andView:(UIView *)view andDuration:(CFTimeInterval)duration {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.duration = duration;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    basicAnimation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:basicAnimation forKey:@"opacity"];
}

#pragma mark - 添加组合动画

+ (void)addGroupAnimationWithGroupAnimations:(NSArray *)groups AndView:(UIView *)view {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = groups;
    animationGroup.duration = 0.2;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animationGroup forKey:@"group"];
}

#pragma mark - 添加UIViewAnimation

+ (void)addViewAnimationWithFinalFrame:(CGRect)newFrame andView:(UIView *)view {
    [UIView beginAnimations:@"FrameAni" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationDelay:0.05];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.frame = newFrame;
    [UIView commitAnimations];
}

#pragma mark - 根据日期计算当前是周几

+ (NSString*)weekdayStringFromDate:(NSString *)inputDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:inputDate]];
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma mark - 为View的特定角添加圆角

+ (void)addCornerRadiusForView:(UIView *)view andRadius:(CGFloat)radius andCornes:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - 两个日期的比较

+ (BOOL)compareFirtstDate:(NSString*)firstDate withSecondDate:(NSString*)secondDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *current = [[NSDate alloc] init];
    NSDate *end = [[NSDate alloc] init];
    current = [df dateFromString:firstDate];
    end = [df dateFromString:secondDate];
    NSComparisonResult result = [current compare:end];
    BOOL ture;
    switch (result) {
            //secondDate > firstDate
        case NSOrderedAscending:
            ture = YES;
            break;
            //secondDate < firstDate
        case NSOrderedDescending:
            ture = NO;
            break;
            //secondDate = firstDate
        case NSOrderedSame:
            ture = YES;
            break;
        default:
            break;
    }
    return ture;
}

#pragma mark -  两个时间点的比较

+ (BOOL)compareStartTime:(NSString *)startTime withEndTime:(NSString *)endTime {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSDate *start = [[NSDate alloc] init];
    NSDate *end = [[NSDate alloc] init];
    start = [df dateFromString:startTime];
    end = [df dateFromString:endTime];
    NSComparisonResult result = [start compare:end];
    BOOL ture;
    switch (result) {
            //endDate比startDate大
        case NSOrderedAscending:
            //            NSLog(@"比较0000");
            ture = YES;
            break;
            //endDate比startDate小
        case NSOrderedDescending:
            //            NSLog(@"比较1111");
            ture = NO;
            break;
            //endDate=startDate
        case NSOrderedSame:
            //            NSLog(@"比较2222");
            ture = YES;
            break;
        default:
            break;
    }
    return ture;
}

#pragma mark - 十进制转十六进制

+ (NSString *)toHex:(long long int)tmpid {
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i < 9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

#pragma mark - 根据日期算出当前的周数

+ (NSInteger)getWeekCountInYearWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    NSDateComponents *comps;
    comps = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:date];
    NSInteger week = [comps weekOfYear];
    return week;
}

#pragma mark - 计算文字高度

+ (CGFloat)heightForString:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3.0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0.0;
    paraStyle.tailIndent = 0.0;
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:value attributes:dic];
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return sizeToFit.height;
}

+ (CGFloat)heightForString2:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 10.0)];
    [textView setFont:font];
    [textView setText:value];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    CGSize newSize = [textView sizeThatFits:size];
    return newSize.height;
}

+ (CGFloat)heightForString3:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width {
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size;
    return sizeToFit.height;
}

#pragma mark - 计算文字宽度

+ (CGFloat)widthForString:(NSString *)value font:(UIFont *)font andHeight:(CGFloat)height {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3.0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0.0;
    paraStyle.tailIndent = 0.0;
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    //    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:value attributes:dic];
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return sizeToFit.width;
}

+ (CGRect)widthForString2:(NSString *)value font:(UIFont *)font andHeight:(CGFloat)height {
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGRect rect = [value boundingRectWithSize:CGSizeMake(0.0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}

#pragma mark - 获取设备IP地址

+(NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - SHA1编码

+ (NSString *)sha1WithString:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

#pragma mark - 3DES加密

+ (NSString *)doEncryptStr:(NSString *)originalStr {
    //把string 转NSData
    NSData* data = [originalStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [APP_KEY UTF8String];
    
    //配置CCCrypt
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,    //key
                       kCCKeySize3DES,
                       nil,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return [self convertDataToHexStr:myData];
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


#pragma mark - 3DES解密

+ (NSString*)doDecEncryptStr:(NSString *)encryptStr {
    NSData *encryptData = [GTMBase64 decodeData:[encryptStr dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [APP_KEY UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark - 获取随机数

static const char Hex[] = "0123456789ABCDEF";
int bin2hex(const char *bin, const unsigned int len, char * hex, unsigned int cap) {
    if(bin == NULL || hex == NULL) {
        printf("%s input params NULL\n", __FUNCTION__);
        return -1;
    }
    if (len == 0) {
        printf("%s input len[%u] must greater than zero\n", __FUNCTION__, len);
        return -1;
    }
    
    if ((cap) < ((len << 1) + 1)) {
        printf("%s input cap[%u] must greater than twice the len[%u] plus one\n", __FUNCTION__, cap, len);
        return -1;
    }
    
    unsigned int  i;
    unsigned char v;
    for (i = 0; i < len; i++) {
        v = bin[i];
        *(hex++) = Hex[v >> 4];
        *(hex++) = Hex[v & 0x0f];
    }
    (*hex) = '\0';
    return 0;
}

+ (NSString *)creatRandNum {
    unsigned long long rand_no = arc4random()%(100*10000);
//    printf("randno is :%lld,  0x%llx\n",rand_no, rand_no);
    
    rand_no <<= 32;
//    printf("prepare for hex-convert: 0x%llx\n", rand_no);
    
    char buf[17] = {0};
    bin2hex((const char *)&rand_no, sizeof(long long), buf, sizeof(buf));
    return [NSString stringWithFormat:@"%s",buf];

}

#pragma mark - 获取当前时间戳（10位）

+ (NSString *)getNowTimeTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSLog(@"datenow:%@",datenow);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)getDateTimeToMilliSeconds {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    double totalMilliseconds = interval * 1000;
    return [NSString stringWithFormat:@"%.0f",totalMilliseconds];
}

#pragma mark - 照片获取本地路径转换

+ (NSString *)getImagePath:(UIImage *)Image {
    NSString *filePath = nil;
    NSData *data = nil;
    if (UIImagePNGRepresentation(Image) == nil) {
        data = UIImageJPEGRepresentation(Image, 1.0);
    } else {
        data = UIImagePNGRepresentation(Image);
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

#pragma mark - 获取当前时间 格式yyyy-MM-dd

+ (NSString *)fetchCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

#pragma mark - 获取当前月份 格式yyyy-MM

+ (NSString *)fetchCurrentMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [NSDate date];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

#pragma mark - 国际时间转换为yyyy-MM-dd

+ (NSString *)GMTTimeToNormalTimeWithTimeStr:(NSString *)timeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *str = [dateFormatter dateFromString:timeStr];
//    NSLog(@"dateStr:%@",str);
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSLog(@"dateStr:%@",[dateFormatter stringFromDate:str]);
    return [dateFormatter stringFromDate:str];
}

#pragma mark - 时间戳转时间 yyyy-MM-dd HH:mm

+ (NSString *)timeStampToDateStrWithStamp:(NSString *)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]]];
    return dateStr;
}

#pragma mark - 时间戳转时间 HH:mm

+ (NSString *)timeStampToHourMinuteWithStamp:(NSString *)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]]];
    return dateStr;
}

#pragma mark - 获取当前时间 格式 HH:mm:ss

+ (NSString *)fetchCurrentHourMinute {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    return currentTime;
}

#pragma mark - 获取当前时间的秒的个位数

+ (NSInteger)fetchCurrentSecondSingleDigit {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    NSInteger singleDigit = [[currentTime substringFromIndex:currentTime.length - 1] integerValue];
    return singleDigit;
}

#pragma mark - MD5加密

+ (NSString *)MD5ForLower32Bate:(NSString *)str {
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

#pragma mark - 添加View的顶部阴影

+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(1.0, 0.0);
    theView.layer.shadowOpacity = 0.1;
    theView.layer.shadowRadius = 5;
    
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}

#pragma mark - NSDictionary根据key值排序

+ (NSString *)sortedDictionary:(NSDictionary *)dict {
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2 options:NSLiteralSearch];
        return resuest;
    }];
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    //    NSLog(@"valueArray:%@",valueArray);
    if (@available(iOS 11.0, *)) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < afterSortKeyArray.count; i++) {
            [result addEntriesFromDictionary:@{[afterSortKeyArray objectAtIndex:i]: [valueArray objectAtIndex:i]}];
        }
        //    NSLog(@"result:%@",result);
        NSData *jsonData;
        if (@available(iOS 11.0, *)) {
            jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingSortedKeys error:nil];
        } else {
            jsonData = [NSJSONSerialization dataWithJSONObject:result options:-1 error:nil];
        }
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //    NSLog(@"jsonStr==>%@",jsonStr);
        return jsonStr;
    } else {
        NSMutableString *testStr = [[NSMutableString alloc] initWithString:@"{"];
        for (int i = 0; i < afterSortKeyArray.count; i++) {
            if (i == afterSortKeyArray.count - 1) {
                [testStr appendFormat:@"%@", [NSString stringWithFormat:@"\"%@\":\"%@\"",[afterSortKeyArray objectAtIndex:i], [valueArray objectAtIndex:i]]];
            } else {
                [testStr appendFormat:@"%@", [NSString stringWithFormat:@"\"%@\":\"%@\",",[afterSortKeyArray objectAtIndex:i], [valueArray objectAtIndex:i]]];
            }
        }
        [testStr appendString:@"}"];
        return testStr;
    }
}

#pragma mark - 获取UUID

+ (NSString *)fetchUUID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark - 绘制虚线

+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

#pragma mark - 计算缓存大小

+ (NSString *)getCachesSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat totalSize = 0;
    if ([manager fileExistsAtPath:cachePath]) {
        // 目录下的文件计算大小
        NSArray *childrenFile = [manager subpathsAtPath:cachePath];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [cachePath stringByAppendingPathComponent:fileName];
            totalSize += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        //SDWebImage的缓存计算
        totalSize += [[SDImageCache sharedImageCache] totalDiskSize]/1024.0/1024.0;
    }
    
    // 2.将文件夹大小转换为 M/KB/B
    NSString *totalSizeString = nil;
    if (totalSize > 1024 * 1024) {
        totalSizeString = [NSString stringWithFormat:@"%.1fM",totalSize / 1024.0f /1024.0f];
    } else if (totalSize > 1024) {
        totalSizeString = [NSString stringWithFormat:@"%.1fKB",totalSize / 1024.0f ];
    } else {
        totalSizeString = [NSString stringWithFormat:@"%.1fB",totalSize / 1024.0f];
    }
    return totalSizeString;
}

#pragma mark - 清除缓存

+ (void)removeCache {
    // 1.拿到cachePath路径的下一级目录的子文件夹
    // contentsOfDirectoryAtPath:error:递归
    // subpathsAtPath:不递归
    NSArray *subpathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:nil];
    // 2.如果数组为空，说明没有缓存或者用户已经清理过，此时直接return
    if (subpathArray.count == 0) {
        [ZXProgressHUD loadSucceedWithMsg:@"缓存已清理"];
        return ;
    }
    
    NSError *error = nil;
    NSString *filePath = nil;
    BOOL flag = NO;
    NSString *size = [self getCachesSize];
    for (NSString *subpath in subpathArray) {
        filePath = [cachePath stringByAppendingPathComponent:subpath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            // 删除子文件夹
            BOOL isRemoveSuccessed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (isRemoveSuccessed) {
                // 删除成功
                flag = YES;
            }
        }
    }
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearMemory];
    
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
    
    if (NO == flag) {
        [ZXProgressHUD loadSucceedWithMsg:@"缓存已清理"];
    } else {
        [ZXProgressHUD loadSucceedWithMsg:[NSString stringWithFormat:@"为您腾出%@空间",size]];
    }
    return ;
    
}

#pragma mark - 文本的行字间距

+ (NSDictionary *)contentAttributes {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 1.5;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0.0;
    paraStyle.tailIndent = 0.0;
    return @{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.5f};
}

#pragma mark - 淘宝二次账号授权

+ (void)taobaoSecAuthWithCode:(NSString *)authCode {
//    NSLog(@"淘宝二次账号授权");
}

#pragma mark - 检测图片是否有二维码

+ (BOOL)checkQRCodeWithData:(YBIBImageData *)data {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *imageCI = [[CIImage alloc] initWithImage:data.originImage];
    NSArray<CIFeature *> *features = [detector featuresInImage:imageCI];
    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
    if (codef) {
//        NSString *qrcodeInfoStr = codef.messageString;
        return YES;
    }
    return NO;
}

#pragma mark - 获取视频的时长

+ (NSInteger)getVideoTimeByUrlString:(NSString *)urlString {
    NSURL *videoUrl = [NSURL URLWithString:urlString];
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoUrl];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    return seconds;
}

#pragma mark - 获取运营商

+ (NSString *)getCarrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    return [carrier carrierName];
}

#pragma mark - 获取网络图片size

+ (CGSize)getImageSizeWithURL:(id)URL {
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
//    NSLog(@"imageSourceRef:%@",imageSourceRef);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
//        NSLog(@"imageProperties:%@",imageProperties);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

#pragma mark - 获取当前日期后N天的日期

+ (NSArray *)fetchFutureDatesWithNum:(NSInteger)num {
    NSMutableArray *dateList = [[NSMutableArray alloc] init];
    NSDate *currentDate = [NSDate date];
    for (int i = 1; i <= num; i++) {
        NSDate *subDate = [currentDate initWithTimeIntervalSinceNow:24 * 60 * 60 * i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM.dd"];
        NSString *dateStr = [formatter stringFromDate:subDate];
        [dateList addObject:dateStr];
    }
    return dateList;
}

#pragma mark - ScrollView的BackgroundView

+ (UIView *)createBgViewWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:topColor];
    [bgView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:bottomColor];
    [bgView addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + STATUS_HEIGHT);
        make.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(SCREENHEIGHT/2.0);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0);
        make.top.mas_equalTo(topView.mas_bottom);
    }];
    
//    NSMutableArray *subViewList = [[NSMutableArray alloc] initWithObjects:topView, bottomView, nil];
//    [subViewList mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
//    [subViewList mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0.0);
//    }];
    return bgView;
}

#pragma mark - 统一的UIAlertController

+ (UIAlertController *)zxAlertControllerWithTitle:(NSString *_Nullable)title andMessage:(NSString *_Nullable)message style:(UIAlertControllerStyle)style andAction:(NSArray *)actions alertActionClicked:(void (^) (NSInteger actionTag))actionClicked {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int i = 0; i < [actions count]; i++) {
        UIAlertAction *subAction = [UIAlertAction actionWithTitle:[actions objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            actionClicked(i);
        }];
        [alertVC addAction:subAction];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    return alertVC;
}

#pragma mark - 淘宝授权相关

+ (void)taobaoAuthWithAuthCodeBlock:(void(^) (NSString *codeStr))authBlock {
    AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
    showParam.isNeedPush = YES;
    showParam.nativeFailMode = AlibcNativeFailModeJumpH5;
    showParam.degradeUrl = @"";
    showParam.isNeedCustomNativeFailMode = NO;
    ALiTradeWebViewController *authVC = [[ALiTradeWebViewController alloc] init];
    authVC.taoBaoAuthCodeBlock = ^(NSString *authCode) {
        authBlock(authCode);
    };
//    NSLog(@"taobaoAuthUrl:%@",[[[ZXAppConfigHelper sharedInstance] appConfig] tb_auth_url]);
    [[[AlibcTradeSDK sharedInstance] tradeService] openByUrl:[[[ZXAppConfigHelper sharedInstance] appConfig] tb_auth_url] identity:@"trade" webView:authVC.webView parentController:authVC showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {

        } tradeProcessFailedCallback:^(NSError * _Nullable error) {

    }];
}

+ (void)taobaoLogout {
    [[ALBBSDK sharedInstance] logout];
}

#pragma mark - 导航栏按钮

+ (UIButton *)createLeftBarButtonWithImage:(UIImage *)image {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 44)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setImage:image forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [leftButton setAdjustsImageWhenHighlighted:NO];
    return leftButton;
}

+ (UIButton *)createLeftBarButtonWithTitle:(NSString *)title andFont:(UIFont *)font andColor:(UIColor *)color {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 44)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:color forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:font];
    [leftButton setAdjustsImageWhenHighlighted:NO];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return leftButton;
}

+ (UIButton *)createRightBarButtonWithImage:(UIImage *)image single:(BOOL)single {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (single) {
        [rightButton setFrame:CGRectMake(0, 0, 60, 44)];
    } else {
        [rightButton setFrame:CGRectMake(0, 0, 30, 44)];
    }
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightButton setImage:image forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rightButton setAdjustsImageWhenHighlighted:NO];
    return rightButton;
}

+ (UIButton *)createRighttBarButtonWithTitle:(NSString *)title andFont:(UIFont *)font andColor:(UIColor *)color single:(BOOL)single {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (single) {
        [rightButton setFrame:CGRectMake(0, 0, 60, 44)];
    } else {
        [rightButton setFrame:CGRectMake(0, 0, 30, 44)];
    }
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:font];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rightButton setAdjustsImageWhenHighlighted:NO];
    return rightButton;
}

//#pragma mark - 创建时间选择器
//
//+ (PGDatePickManager *)createDatePickManager {
//    PGDatePickManager *datePickManager = [[PGDatePickManager alloc] init];
//    [datePickManager setHeaderHeight:40.0];
//    [datePickManager setHeaderViewBackgroundColor:[UtilsMacro colorWithHexString:@"EDEDED"]];
//    [datePickManager setCancelButtonFont:[UIFont systemFontOfSize:15.0]];
//    [datePickManager setCancelButtonTextColor:HOME_TITLE_COLOR];
//    [datePickManager setConfirmButtonFont:[UIFont systemFontOfSize:15.0]];
//    [datePickManager setConfirmButtonTextColor:HOME_TITLE_COLOR];
//    PGDatePicker *datePicker = [datePickManager datePicker];
//    [datePicker setDatePickerMode:PGDatePickerModeYearAndMonth];
//    [datePicker setDatePickerType:PGDatePickerTypeLine];
//    [datePicker setTextFontOfSelectedRow:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]];
//    [datePicker setTextColorOfSelectedRow:HOME_TITLE_COLOR];
//    [datePicker setTextFontOfOtherRow:[UIFont systemFontOfSize:15.0]];
//    [datePicker setTextColorOfOtherRow:COLOR_999999];
//    [datePicker setLineBackgroundColor:[UtilsMacro colorWithHexString:@"ECECEA"]];
////    [datePicker setRowHeight:40.0];
//    return datePickManager;
//}

#pragma mark - 自定义导航栏

+ (UIView *)customNavigationViewWithLeftContent:(id)left title:(NSString *)title titleColor:(UIColor *)color andRightContent:(id)right {
    UIView *customNav = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0 + STATUS_HEIGHT)];
    [customNav setBackgroundColor:[UIColor clearColor]];
    
    UIButton *leftBtn;
    if ([left isKindOfClass:[UIImage class]]) {
        leftBtn = [self leftBtnWithImage:left];
    } else {
        leftBtn = [self leftBtnWithTitle:left];
    }
    [customNav addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(60.0);
        make.top.mas_equalTo(STATUS_HEIGHT);
    }];
    
    UIView *titleView = [[UIView alloc] init];
    [customNav addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customNav);
        make.top.mas_equalTo(STATUS_HEIGHT);
        make.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(180.0);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    [titleLab setText:title];
    [titleLab setFont:TITLE_FONT];
    [titleLab setTextColor:color];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0.0);
    }];
    
    if ([right isKindOfClass:[NSArray class]]) {
        NSArray *contentList = (NSArray *)right;
        for (int i = 0; i < [contentList count]; i++) {
            UIButton *tempBtn;
            if ([[contentList objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                tempBtn = [self rightBtnWithImage:[contentList objectAtIndex:i]];
            } else {
                tempBtn = [self rightBtnWithTitle:[contentList objectAtIndex:i]];
            }
            [customNav addSubview:tempBtn];
            [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.right.mas_equalTo(-i * 30.0 - 20.0);
                } else {
                    make.right.mas_equalTo(-i * 30.0 - 25.0);
                }
                make.width.mas_equalTo(30.0);
                make.top.mas_equalTo(STATUS_HEIGHT);
                make.bottom.mas_equalTo(0.0);
            }];
        }
    } else if ([right isKindOfClass:[NSString class]]) {
        UIButton *tempBtn = [self rightBtnWithTitle:right];
        [customNav addSubview:tempBtn];
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
        }];
    } else {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [rightBtn setImage:right forState:UIControlStateNormal];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [rightBtn setAdjustsImageWhenHighlighted:NO];
        [customNav addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(60.0);
            make.top.mas_equalTo(STATUS_HEIGHT);
        }];
    }
    
    return customNav;
}

+ (UIButton *)leftBtnWithImage:(UIImage *)image {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:image forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    return leftBtn;
}

+ (UIButton *)leftBtnWithTitle:(NSString *)title {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [leftBtn setAdjustsImageWhenHighlighted:NO];
    return leftBtn;
}

+ (UIButton *)rightBtnWithImage:(UIImage *)image {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:image forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    return rightBtn;
}

+ (UIButton *)rightBtnWithTitle:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [rightBtn setAdjustsImageWhenHighlighted:NO];
    return rightBtn;
}

#pragma mark - 系统粘贴板复制

+ (void)generalPasteboardCopy:(NSString *)str {
    [[UIPasteboard generalPasteboard] setString:str];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:[UIPasteboard generalPasteboard].changeCount forKey:@"changecount"];
    [userDefaults synchronize];
}

#pragma mark - 图片渐显

+ (void)zxSD_setImageWithURL:(nullable NSURL *)url imageView:(UIImageView *)imageView placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    BOOL isExist = [[SDImageCache sharedImageCache] diskImageDataExistsWithKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
    [imageView sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (isExist) {
            imageView.alpha = 0.0;
        }
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize, targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!isExist) {
            [self addOpacityAnimationFromValue:@0.0 toValue:@1.0 andView:imageView andDuration:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageView setAlpha:1.0];
            });
        }
        [imageView setAlpha:1.0];
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

//#pragma mark - 根据开始和结束时间计算年份数和月份数

//+ (void)fetchYearsAndMonthesWithS_time:(NSString *)s_time andE_time:(NSString *)e_time {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM"];
//
//    NSDate *sDate = [formatter dateFromString:s_time];
//    NSDate *eDate = [formatter dateFromString:e_time];
//
//    [formatter setDateFormat:@"yyyy"];
//    NSInteger sYear = [[formatter stringFromDate:sDate] integerValue];
//    NSInteger eYear = [[formatter stringFromDate:eDate] integerValue];
//
//    [formatter setDateFormat:@"MM"];
//    NSInteger sMonth = [[formatter stringFromDate:sDate] integerValue];
//    NSInteger eMonth = [[formatter stringFromDate:eDate] integerValue];
//
//    NSMutableArray *yearList = [[NSMutableArray alloc] init];
//    for (NSInteger i = sYear ; i < eYear; i++) {
//        [yearList addObject:[NSString stringWithFormat:@"%ld", (long)i]];
//    }
//
//    NSMutableArray *monthList = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [yearList count]; i++) {
//        NSMutableArray *subList = [[NSMutableArray alloc] init];
//
//    }
//}

#pragma mark - Small_PlaceHolder

+ (UIImage *)small_placeHolder {
    NSUserDefaults *imgDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *result = [UIImage imageWithData:[imgDefaults valueForKey:@"Small_PlaceHolder"]];
    return result;
}

#pragma mark - Big_PlaceHolder

+ (UIImage *)big_placeHolder {
    NSUserDefaults *imgDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *result = [UIImage imageWithData:[imgDefaults valueForKey:@"Big_PlaceHolder"]];
    return result;
}

#pragma mark - 预加载loading资源图片

+ (void)preloadLoadingAssetsWithLoadingAsset:(ZXLoadingAsset *_Nonnull)loadingAsset {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.img_placeholder_big] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            NSUserDefaults *imgDefaults = [NSUserDefaults standardUserDefaults];
            [imgDefaults setValue:UIImageJPEGRepresentation(image, 1.0) forKey:@"Big_PlaceHolder"];
            [imgDefaults synchronize];
            
            ZXAppConfig *appConfig = [[ZXAppConfigHelper sharedInstance] appConfig];
            [appConfig setBig_img:image];
            [[ZXAppConfigHelper sharedInstance] setAppConfig:appConfig];
        }
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.img_placeholder_small] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            NSUserDefaults *imgDefaults = [NSUserDefaults standardUserDefaults];
            [imgDefaults setValue:UIImageJPEGRepresentation(image, 1.0) forKey:@"Small_PlaceHolder"];
            [imgDefaults synchronize];
            
            ZXAppConfig *appConfig = [[ZXAppConfigHelper sharedInstance] appConfig];
            [appConfig setSmall_img:image];
            [[ZXAppConfigHelper sharedInstance] setAppConfig:appConfig];
        }
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.index_header_bg] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.load_dark] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.loading_dark] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.load_light] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.loading_light] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:loadingAsset.loading] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
}

#pragma mark - 生成二维码图片

+ (UIImage *)qrCodeImgWithContent:(NSString *_Nonnull)content size:(CGSize)size {
//    UIImage *resultImg = [ZXingWrapper createCodeWithString:content size:size CodeFomart:kBarcodeFormatQRCode];
    UIImage *resultImg;
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:contentData forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outPutImg = [filter outputImage];
    
    UIColor *pointColor = [UIColor blackColor];
    UIColor *bgColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues: @"inputImage", outPutImg, @"inputColor0",[CIColor colorWithCGColor:pointColor.CGColor], @"inputColor1", [CIColor colorWithCGColor:bgColor.CGColor], nil];
    CIImage *qrImg = [colorFilter outputImage];
    
    CGImageRef cgImg = [[CIContext contextWithOptions:nil] createCGImage:qrImg fromRect:qrImg.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImg);
    resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImg);
    
    return resultImg;
}

#pragma mark - 获取顶层VC

+ (UIViewController *)topViewController {
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [((UITabBarController *) vc) selectedViewController];
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [((UINavigationController *) vc) visibleViewController];
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

#pragma mark - 手机振动

+ (void)phoneShake {
    AudioServicesPlaySystemSound(1519);
}

#pragma mark - 打开淘宝授权弹窗

+ (void)openTBAuthViewWithVC:(UIViewController *)vc completion:(void(^)(void))completionBlock {
    NSDictionary *dataDict = @{@"type":@"1", @"params": @{@"pageid": @"1105"}};
    ZXOpenPage *openPage = [ZXOpenPage yy_modelWithJSON:dataDict];
    [[ZXUniversalUtil sharedInstance] openNewPageWithVC:vc openPage:openPage completionBlock:completionBlock];
}

#pragma mark - 打开日期选择器

+ (void)openZXDatePickerWithViewController:(UIViewController *_Nonnull)vc datePickerResultBlock:(void (^_Nonnull) (NSString * _Nonnull resultStr))resultBlock {
    ZXDatePicker *datePicker = [[ZXDatePicker alloc] init];
    [datePicker setProvidesPresentationContextTransitionStyle:YES];
    [datePicker setDefinesPresentationContext:YES];
    [datePicker setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    if (resultBlock) {
        datePicker.zxDatePickerResultBlock = ^(NSString * _Nonnull result) {
            resultBlock(result);
        };
    }
    [vc presentViewController:datePicker animated:YES completion:nil];
}

#pragma mark - 颜色相关

+ (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor {
    CGFloat r = 0,g = 0,b = 0,a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[@(r),@(g),@(b)];
}

+ (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor {
    NSArray<NSNumber *> *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray<NSNumber *> *endColorArr = [self getRGBDictionaryByColor:endColor];
    return @[@([endColorArr[0] doubleValue] - [beginColorArr[0] doubleValue]),@([endColorArr[1] doubleValue] - [beginColorArr[1] doubleValue]),@([endColorArr[2] doubleValue] - [beginColorArr[2] doubleValue])];
}

+ (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe  andEndColor:(UIColor *)endColor {
    NSArray *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray *marginArray = [self transColorBeginColor:beginColor andEndColor:endColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue] + coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark - APP版本检查更新

+ (void)checkAppVersionUpdateWithViewController:(UIViewController *)viewController needToast:(BOOL)needToast {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    long long current = [[self getNowTimeTimestamp] longLongValue];
    if (![self whetherIsEmptyWithObject:[userDefaults valueForKey:UPGRADE_TIME]]) {
        long long last = [[userDefaults valueForKey:UPGRADE_TIME] longLongValue];
        //如果距离上次提示更新未超过7天，则不提示更新。
        if (current - last < 7 * 24 * 60 * 60) {
            return;
        }
    }
    NSString *appStoreUrl = @"http://itunes.apple.com/cn/lookup?id=1474217119";
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [[ZXNewService sharedManager] getRequestWithUri:appStoreUrl completionBlock:^(id  _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZXProgressHUD hideAllHUD];
            NSArray *resultList = result[@"results"];
            if (resultList && resultList.count > 0) {
                NSDictionary *newApp = resultList.firstObject;
                NSString *newVersion = newApp[@"version"];
                NSString *releaseNotes = newApp[@"releaseNotes"];
                if ([UtilsMacro whetherIsEmptyWithObject:releaseNotes]) {
                    releaseNotes = @"好物券上新啦，快去更新吧！";
                }
                if ([currentVersion floatValue] < [newVersion floatValue]) {
                    UIAlertController *upgradeAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //存储当前提示更新，用户点击暂不更新的时间
                        NSUserDefaults *timeDefaults = [NSUserDefaults standardUserDefaults];
                        [timeDefaults setValue:[self getNowTimeTimestamp] forKey:UPGRADE_TIME];
                        [timeDefaults synchronize];
                    }];
                    UIAlertAction *upgrade = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1474217119?mt=8"] options:@{} completionHandler:nil];
                    }];
                    [upgradeAlert addAction:cancel];
                    [upgradeAlert addAction:upgrade];
                    [viewController presentViewController:upgradeAlert animated:YES completion:nil];
                } else {
                    if (needToast) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ZXProgressHUD loadSucceedWithMsg:@"已是最新版本"];
                        });
                    }
                    return;
                }
            } else {
                if (needToast) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ZXProgressHUD loadSucceedWithMsg:@"已是最新版本"];
                    });
                }
                return;
            }
        });
    } errorBlock:^(ZXResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZXProgressHUD hideAllHUD];
        });
        NSLog(@"版本检测更新失败");
    }];
}

#pragma mark - 存储退到后台时的当前时间戳

+ (void)saveEnterBackgroundTimeStamp {
    NSUserDefaults *timeDefaults = [NSUserDefaults standardUserDefaults];
    [timeDefaults setValue:[self getNowTimeTimestamp] forKey:@"SplashAd"];
    [timeDefaults synchronize];
}

#pragma mark - 比较进入到前台的时间戳和存储的时间戳是否需要展示开屏广告

+ (BOOL)checkWhetherNeedSplashAd {
    BOOL result = NO;
    NSUserDefaults *timeDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [timeDefaults valueForKey:@"SplashAd"];
    NSString *currentTime = [self getNowTimeTimestamp];
    if ([currentTime longLongValue] - [lastTime longLongValue] > 1800) {
        result = YES;
    }
    return result;
}

@end
