//
//  ZXCommunity.h
//  pzhixin
//
//  Created by zhixin on 2020/3/13.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCommunityGrow.h"
#import "ZXCommunityAuthor.h"
#import "ZXCommunityDetail.h"
#import "ZXCommunityComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommunity : NSObject

@property (strong, nonatomic) NSString *community_id;

@property (strong, nonatomic) NSString *cid;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *share_times;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) ZXCommunityGrow *grow;

@property (strong, nonatomic) NSArray *imgs;

@property (strong, nonatomic) NSArray *first_img_wh;

@property (strong, nonatomic) NSString *g_comment;

@property (strong, nonatomic) NSString *s_time;

@property (strong, nonatomic) ZXCommunityAuthor *author;

@property (strong, nonatomic) NSMutableArray *comment;

@property (strong, nonatomic) ZXCommunityDetail *detail;

@end

NS_ASSUME_NONNULL_END
