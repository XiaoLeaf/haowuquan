//
//  ZXClassify.h
//  pzhixin
//
//  Created by zhixin on 2019/8/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXClassify : NSObject

@property (strong, nonatomic) NSString *fid;

@property (strong, nonatomic) NSString *icon;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *classifyId;

@property (strong, nonatomic) NSArray *subcats;

@end

NS_ASSUME_NONNULL_END
