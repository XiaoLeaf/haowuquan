//
//  ZXDatabaseUtil.h
//  pzhixin
//
//  Created by zhixin on 2019/7/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "FMDatabase.h"
#import <FMDB/FMDatabaseAdditions.h>
#import "ZXUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXDatabaseUtil : FMDatabase

+ (instancetype)sharedDataBase;

#pragma mark - 搜索历史

//插入搜索历史数据
- (void)insertHistory:(NSString *)searchStr;

//查询搜索历史数据
- (NSArray *)selectSearchHistory;

//清空所有搜索历史数据
- (void)clearSearchHistory;

#pragma mark - 用户信息

//插入用户数据
- (void)insertUser:(ZXUser *)user;

//根据昵称判断当前用户数据是否已存在
- (BOOL)userExistWithName:(NSString *)user_name;

//根据Authorizationh判断当前用户数据是否已存在
- (BOOL)userExistWithAuth:(NSString *)auth;

//查询所有用户数据
- (NSArray *)selectUser;

//清除所有用户数据
- (void)clearUser;

//清除指定用户数据
- (void)clearUserWithUser:(ZXUser *)user;

//根据昵称检索用户数据
- (ZXUser *)selectUserWithName:(NSString *)user_name;

//根据authorization更新用户信息
- (void)updateUserWithAuth:(NSString *)auth;

//根据ZXUser更新用户信息
- (void)updateUserWithUser:(ZXUser *)user;

@end

NS_ASSUME_NONNULL_END
