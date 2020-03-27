//
//  AppMacro.h
//  zhixin
//
//  Created by zhixin on 16/3/2.
//  Copyright © 2016年 zhixin. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


#endif /* AppMacro_h */


#if DEBUG
#    define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#    define DLog(...)
#endif

#define RESULT_DICTIONARY [NSDictionary dictionaryWithObjectsAndKeys:state,@"state", info,@"info", code,@"code", nil]

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define IOS7_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define SCREENWIDTH [[[UIApplication sharedApplication] delegate] window].frame.size.width
#define SCREENHEIGHT [[[UIApplication sharedApplication] delegate] window].frame.size.height

#define STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_HEIGHT self.navigationController.navigationBar.frame.size.height

#define APP_KEY @"123456789012345678901234"

#define THEME_COLOR [UIColor colorWithRed:213/255.0 green:24/255.0 blue:30/255.0 alpha:1.0]
#define BG_COLOR [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]
#define DEDEDE_COLOR [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0]
#define HOME_TITLE_COLOR [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define COLOR_999999 [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define COLOR_666666 [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define COLOR_4B729D [UIColor colorWithRed:75.0/255.0 green:114.0/255.0 blue:157.0/255.0 alpha:1.0]
#define COLOR_F1F1F1 [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0]
#define TITLE_FONT [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]



