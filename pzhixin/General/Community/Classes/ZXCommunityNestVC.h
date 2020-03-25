//
//  ZXCommunityNestVC.h
//  pzhixin
//
//  Created by zhixin on 2019/10/31.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCommunityNestVC : TYTabPagerController

@property (strong, nonatomic) ZXCommunityCat *communityCat;

@property (strong, nonatomic) NSString * _Nullable cid;

- (void)setPagerViewSelectIndexWithId:(NSString *)subCid;

@end

NS_ASSUME_NONNULL_END
