//
//  ZXSubjectHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSubjectParam : NSObject

@property (strong, nonatomic) NSString *sid;

@end

@interface ZXSubjectCat : NSObject

@property (strong, nonatomic) NSString *catId;

@property (strong, nonatomic) NSString *name;

@end

@interface ZXSubjectSlide : NSObject

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *url_schema;

@end

@interface ZXSubjectResult : NSObject

@property (strong, nonatomic) NSArray *category;

@property (assign, nonatomic) NSInteger display;

@property (assign, nonatomic) NSInteger display_btn;

@property (strong, nonatomic) NSArray *list;

@property (assign, nonatomic) NSInteger pagesize;

@property (strong, nonatomic) NSArray *slides;

@property (strong, nonatomic) NSString *title;

@end

@interface ZXSubjectHelper : NSObject

+ (ZXSubjectHelper *)sharedInstance;

- (void)fetchSubjectWithSid:(NSString *)inSid andCid:(NSString *)inCid andPage:(NSString *)inPage completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
