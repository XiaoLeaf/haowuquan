//
//  ZXUser.h
//  pzhixin
//
//  Created by zhixin on 2019/7/1.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "ZXWXTmp.h"
#import "ZXUserStat.h"
#import "ZXUserBtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXUserGender : NSObject

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) NSString *val;

@end

@interface ZXUser : NSObject

@property (strong, nonatomic) NSString *nickname;

@property (strong, nonatomic) NSString *icon;

@property (strong, nonatomic) NSString *tel;

@property (strong, nonatomic) NSString *bind_wx;

@property (strong, nonatomic) NSString *wx;

@property (strong, nonatomic) NSString *intro;

@property (strong, nonatomic) NSString *birthday;

@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSArray *gender_arr;

@property (strong, nonatomic) NSString *reg_time;

@property (strong, nonatomic) NSString *bind_tb;

@property (strong, nonatomic) NSString *tb_nickname;

@property (strong, nonatomic) NSString *tb_rid;

@property (strong, nonatomic) NSString *fans_num;

@property (strong, nonatomic) NSString *icode;

@property (strong, nonatomic) NSString *rank;

@property (strong, nonatomic) NSString *authorization;

@property (strong, nonatomic) ZXUserStat *stat;

@property (strong, nonatomic) ZXWXTmp *wxtmp;

@property (strong, nonatomic) NSArray *hbtns;

@property (strong, nonatomic) NSArray *sbtns;

@property (strong, nonatomic) NSString *is_bind;

@property (assign, nonatomic) BOOL isLoaded;

@property (strong, nonatomic) ZXMyMenu *games_menus;

@property (strong, nonatomic) ZXMyMenu *main_menus;

@property (strong, nonatomic) NSArray *public_menus;

@end

NS_ASSUME_NONNULL_END
