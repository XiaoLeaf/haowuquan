//
//  ZXOrderView.h
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXNotice.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXOrderViewTimeListBlock)(NSArray *timeList);

typedef void(^ZXOrderViewHeaderClick)(void);

@protocol ZXOrderViewDelegate;

@interface ZXOrderView : UIView

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;

@property (strong, nonatomic) NSDictionary *paratemers;

@property (strong, nonatomic) NSArray *defaultResult;

@property (strong, nonatomic) ZXCommonNotice *notice;

@property (weak, nonatomic) id<ZXOrderViewDelegate>delegate;

@property (copy, nonatomic) ZXOrderViewTimeListBlock zxOrderViewTimeListBlock;

@property (copy, nonatomic) ZXOrderViewHeaderClick zxOrderViewHeaderClick;

@end

@protocol ZXOrderViewDelegate <NSObject>

- (void)orderViewTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
