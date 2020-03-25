//
//  ZXMaterialOptionalHelper.h
//  pzhixin
//
//  Created by zhixin on 2019/8/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMaterial : NSObject

@property (assign, nonatomic) NSInteger pagesize;

@property (strong, nonatomic) NSArray *goods;

@property (strong, nonatomic) NSArray *slides;

@end

@interface ZXMaterialOptionalHelper : NSObject

+ (ZXMaterialOptionalHelper *)sharedInstance;

- (void)fetchMaterialOptionalWithPage:(NSString *)inPage andCat_id:(NSString *_Nullable)inCat_id andSort:(NSString *)inSort completion:(void (^)(ZXResponse * response))completionBlock error:(void (^)(ZXResponse *response))errorBlock;

@end

NS_ASSUME_NONNULL_END
