//
//  ZXNewHomeHeadLineCell.h
//  pzhixin
//
//  Created by zhixin on 2019/12/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNewHomeHeadLineCell : UITableViewCell

@property (strong, nonatomic) NSArray *main_ads;

@property (strong, nonatomic) NSArray *notices;

@property (copy, nonatomic) void (^zxNewHomeHeadLineCellImgClick) (NSInteger imgTag);

@property (copy, nonatomic) void (^zxNewHomeHeadLineCellAdvertDidSelected) (NSInteger index);

@end

NS_ASSUME_NONNULL_END
