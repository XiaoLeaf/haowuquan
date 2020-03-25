//
//  ZXDatabaseUtil.m
//  pzhixin
//
//  Created by zhixin on 2019/7/23.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXDatabaseUtil.h"
#import <YYModel/YYModel.h>

static ZXDatabaseUtil *dataBaseUtil = nil;

#define MAX_HISTORY_COUNT 100

@interface ZXDatabaseUtil () {
    FMDatabase *dataBase;
}

@end

@implementation ZXDatabaseUtil

+ (instancetype)sharedDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataBaseUtil == nil) {
            dataBaseUtil = [[ZXDatabaseUtil alloc] init];
            [dataBaseUtil createDataBase];
        }
    });
    return dataBaseUtil;
}

#pragma mark - Private Methods

- (void)createDataBase {
    NSString *doucumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBasePath = [doucumentsPath stringByAppendingPathComponent:@"zx_dataBase"];
    dataBase = [FMDatabase databaseWithPath:dataBasePath];
    [dataBase open];
    if ([dataBase isOpen]) {
        NSString *searchHistory = @"CREATE TABLE IF NOT EXISTS zx_search_history (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, content VARCHAR(255), modify_time INT(11))";
        if ([dataBase executeUpdate:searchHistory]) {
//            NSLog(@"创建搜索历史表成功");
            if (![dataBase columnExists:@"modify_time" inTableWithName:@"zx_search_history"]) {
                if ([dataBase executeUpdate:@"ALTER TABLE zx_search_history ADD modify_time INT(11)"]) {
                    NSLog(@"新增字段成功");
                } else {
                    NSLog(@"新增字段失败");
                }
            }
        } else {
            NSLog(@"创建搜索历史表失败");
        }
        NSString *user = @"CREATE TABLE IF NOT EXISTS zx_user (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name VARCHAR(255), icon VARCHAR(255), authorization TEXT(0))";
        if ([dataBase executeUpdate:user]) {
//            NSLog(@"创建用户表成功");
        } else {
            NSLog(@"创建用户表失败");
        }
        [dataBase close];
    } else {
        NSLog(@"数据库尚未打开");
        return;
    }
}

#pragma mark - 搜索历史

//插入搜索历史数据
- (void)insertHistory:(NSString *)searchStr {
    [dataBase open];
    if ([dataBase isOpen]) {
        [dataBase beginTransaction];
        BOOL isRollBack = NO;
        @try {
            if ([self searchHistoryExistWithStr:searchStr]) {
                [self updateHistoryLastTimeWithContent:searchStr];
                return;
            }
            [self searchListIsFull];
            [dataBase executeUpdate:@"INSERT INTO zx_search_history (content, modify_time) VALUES (?, ?)", searchStr, [UtilsMacro getNowTimeTimestamp]];
        } @catch (NSException *exception) {
            isRollBack = YES;
            [dataBase rollback];
        } @finally {
            if (!isRollBack) {
                [dataBase commit];
            }
        }
        [dataBase close];
    } else {
        return;
    }
}

//判断当前插入的搜索数据，在表中是否存在
- (BOOL)searchHistoryExistWithStr:(NSString *)searchStr {
    FMResultSet *resultSet = nil;
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT * FROM zx_search_history WHERE content = ?", searchStr];
        while ([resultSet next]) {
            NSString *searchHis = [NSString stringWithFormat:@"%@",[resultSet stringForColumnIndex:1]];
            [resultList addObject:searchHis];
        }
    }
    if ([resultList count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

//判断当前数据库中是否已有100个搜索历史,若有则删除最早的搜索历史
- (BOOL)searchListIsFull {
    FMResultSet *resultSet = nil;
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT id FROM zx_search_history"];
        while ([resultSet next]) {
            [resultList addObject:@([resultSet longLongIntForColumnIndex:0])];
        }
    }
    if ([resultList count] <= 0) {
        return NO;
    } else {
        if ([resultList count] == MAX_HISTORY_COUNT) {
            [dataBase executeUpdate:@"DELETE FROM zx_search_history WHERE id = ?", [resultList objectAtIndex:0]];
            return NO;
        } else {
            return NO;
        }
    }
}

//查询搜索历史数据
- (NSArray *)selectSearchHistory {
    [dataBase open];
    FMResultSet *resultSet = nil;
    NSMutableArray *searchHisList = [[NSMutableArray alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT * FROM zx_search_history ORDER BY modify_time DESC, id DESC"];
        while ([resultSet next]) {
            NSString *searchHis = [NSString stringWithFormat:@"%@",[resultSet stringForColumnIndex:1]];
            [searchHisList addObject:searchHis];
        }
        [dataBase close];
        return searchHisList;
    }
    return searchHisList;
}

//更新搜索历史的修改时间
- (void)updateHistoryLastTimeWithContent:(NSString *)content {
//    [dataBase open];
    if ([dataBase isOpen]) {
        [dataBase executeUpdate:@"UPDATE zx_search_history SET modify_time = ? WHERE content = ?",[UtilsMacro getNowTimeTimestamp], content];
    }
}

//清空所有搜索历史数据
- (void)clearSearchHistory {
    [dataBase open];
    if ([dataBase isOpen]) {
        if ([dataBase executeUpdate:@"DELETE FROM zx_search_history"]) {
            NSLog(@"zx_search_history清空成功");
        } else {
            NSLog(@"zx_search_history清空失败");
        }
    }
    return;
}

#pragma mark - 用户信息

//插入用户数据
- (void)insertUser:(ZXUser *)user {
    [dataBase open];
    if ([dataBase isOpen]) {
        [dataBase beginTransaction];
        BOOL isRollBack = NO;
        @try {
            if ([self userExistWithName:user.nickname]) {
                [dataBase executeUpdate:@"UPDATE zx_user SET `name` = ?, icon = ?, authorization = ?", (user.nickname ? user.nickname : @""), (user.icon ? user.icon : @""), (user.authorization ? user.authorization : @"")];
            } else {
                [dataBase executeUpdate:@"INSERT INTO zx_user (`name`, icon, authorization) VALUES (?, ?, ?)", (user.nickname ? user.nickname : @""), (user.icon ? user.icon : @""), (user.authorization ? user.authorization : @"")];
            }
        } @catch (NSException *exception) {
            isRollBack = YES;
            [dataBase rollback];
        } @finally {
            if (!isRollBack) {
                [dataBase commit];
            }
        }
        [dataBase close];
    }
}

//根据昵称判断当前用户数据是否已存在
- (BOOL)userExistWithName:(NSString *)user_name {
    [dataBase open];
    FMResultSet *resultSet = nil;
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT * FROM zx_user WHERE `name` = ?", user_name];
        while ([resultSet next]) {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[resultSet stringForColumnIndex:1], @"nickname", [resultSet stringForColumnIndex:2], @"icon", [resultSet stringForColumnIndex:3], @"authorization", nil];
            ZXUser *user = [ZXUser yy_modelWithDictionary:userInfo];
            [resultList addObject:user];
        }
    }
    if ([resultList count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

//根据Authorizationh判断当前用户数据是否已存在
- (BOOL)userExistWithAuth:(NSString *)auth {
    [dataBase open];
    FMResultSet *resultSet = nil;
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT * FROM zx_user WHERE authorization = ?", auth];
        while ([resultSet next]) {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[resultSet stringForColumnIndex:1], @"nickname", [resultSet stringForColumnIndex:2], @"icon", [resultSet stringForColumnIndex:3], @"authorization", nil];
            ZXUser *user = [ZXUser yy_modelWithDictionary:userInfo];
            [resultList addObject:user];
        }
    }
    if ([resultList count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

//查询所有用户数据
- (NSArray *)selectUser {
    [dataBase open];
    FMResultSet *resultSet = nil;
    NSMutableArray *searchHisList = [[NSMutableArray alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT * FROM zx_user"];
        while ([resultSet next]) {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[resultSet stringForColumnIndex:1], @"nickname", [resultSet stringForColumnIndex:2], @"icon", [resultSet stringForColumnIndex:3], @"authorization", nil];
            ZXUser *user = [ZXUser yy_modelWithDictionary:userInfo];
            [searchHisList addObject:user];
        }
        [dataBase close];
        return searchHisList;
    }
    return searchHisList;
}

//清除所有用户数据
- (void)clearUser {
    [dataBase open];
    if ([dataBase isOpen]) {
        if ([dataBase executeUpdate:@"DELETE FROM zx_user"]) {
            NSLog(@"zx_user清空成功");
        } else {
            NSLog(@"zx_user清空失败");
        }
        [dataBase close];
    }
    return;
}

//清除指定用户数据
- (void)clearUserWithUser:(ZXUser *)user {
    [dataBase open];
    if ([dataBase isOpen]) {
        if ([dataBase executeUpdate:@"DELETE FROM zx_user WHERE authorization = ?", user.authorization]) {
            NSLog(@"user删除成功");
        } else {
            NSLog(@"user删除失败");
        }
        [dataBase close];
    }
}

//根据昵称检索用户数据
- (ZXUser *)selectUserWithName:(NSString *)user_name {
    [dataBase open];
    FMResultSet *resultSet = nil;
    ZXUser *user = [[ZXUser alloc] init];
    if ([dataBase isOpen]) {
        resultSet = [dataBase executeQuery:@"SELECT * FROM zx_user WHERE `name` = ?", user_name];
        while ([resultSet next]) {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[resultSet stringForColumnIndex:1], @"nickname", [resultSet stringForColumnIndex:2], @"icon", [resultSet stringForColumnIndex:3], @"authorization", nil];
            user = [ZXUser yy_modelWithDictionary:userInfo];
        }
        [dataBase close];
        return user;
    }
    return user;
}

//根据authorization更新用户信息
- (void)updateUserWithAuth:(NSString *)auth {
    [dataBase open];
    if ([dataBase isOpen]) {
        [dataBase beginTransaction];
        BOOL isRollBack = NO;
        @try {
            [dataBase executeUpdate:@"UPDATE zx_user SET authorization = ?", auth];
        } @catch (NSException *exception) {
            isRollBack = YES;
            [dataBase rollback];
        } @finally {
            if (!isRollBack) {
                [dataBase commit];
            }
        }
        [dataBase close];
    }
}

//根据ZXUser更新用户信息
- (void)updateUserWithUser:(ZXUser *)user {
//    NSLog(@"authorization:%@",user.authorization);
    [dataBase open];
    if ([dataBase isOpen]) {
        [dataBase beginTransaction];
        BOOL isRollBack = NO;
        @try {
            [dataBase executeUpdate:@"UPDATE zx_user SET `name` = ?, icon = ?, authorization = ?", user.nickname, user.icon, user.authorization];
        } @catch (NSException *exception) {
            isRollBack = YES;
            [dataBase rollback];
        } @finally {
            if (!isRollBack) {
                [dataBase commit];
            }
        }
        [dataBase close];
    }
}

@end
