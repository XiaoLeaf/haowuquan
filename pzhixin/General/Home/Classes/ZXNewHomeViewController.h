//
//  ZXNewHomeViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/9/26.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNewHomeViewController : TYTabPagerController

- (void)setPagerViewSelectIndexWithId:(NSInteger)cid;

@property (nonatomic, strong) NSMutableArray *titleList;

@property (nonatomic, strong) NSMutableArray *typeList;

@property (strong, nonatomic) NSMutableArray *menuList;

@property (strong, nonatomic) NSMutableArray *classifyList;

@end

NS_ASSUME_NONNULL_END
