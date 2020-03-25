//
//  ZXCommunityCat.h
//  pzhixin
//
//  Created by zhixin on 2020/3/14.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommunityCat : NSObject

@property (strong, nonatomic) NSArray *child;

@property (strong, nonatomic) NSString *fid;

@property (strong, nonatomic) NSString *cid;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *url_schema;

@end

NS_ASSUME_NONNULL_END
