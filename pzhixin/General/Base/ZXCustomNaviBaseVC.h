//
//  ZXCustomNaviBaseVC.h
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCustomNaviBaseVC : UIViewController

//标题
- (ZXCustomNaviBaseVC *(^)(NSString *titleStr))titleStr;

//标题字体颜色
- (ZXCustomNaviBaseVC *(^)(UIColor *titleColor))titleColor;

//标题Font
- (ZXCustomNaviBaseVC *(^)(UIFont *titleFont))titleFont;

//是否隐藏返回按钮
- (ZXCustomNaviBaseVC *(^)(BOOL hideLeft))hideLeft;

//返回按钮是深色还是白色 YES == 白色 NO == 黑色
- (ZXCustomNaviBaseVC *(^)(BOOL light))light;

//导航栏背景色
- (ZXCustomNaviBaseVC *(^)(UIColor *bgColor))bgColor;

//右边按钮对象 rightItems可传UIView NSString UIImage NSArray
- (ZXCustomNaviBaseVC *(^)(id rightItems))rightItems;

//右边按钮点击回调
@property (copy, nonatomic) void(^zxCustonNavBarRightBtnClick) (NSInteger btnTag);

@end

NS_ASSUME_NONNULL_END
