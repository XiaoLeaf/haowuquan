//
//  ZXHomeHeadLineCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/30.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAdvertScrollView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXHomeHeadLineCellImgClick)(NSInteger imgTag);

typedef void(^ZXHomeHeadLineCellAdvertDidSelected)(NSInteger index);

@interface ZXHomeHeadLineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) SGAdvertScrollView *wordScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *firstSpecial;
@property (weak, nonatomic) IBOutlet UIImageView *secondSpecial;
@property (weak, nonatomic) IBOutlet UIImageView *thirdSpecial;
@property (weak, nonatomic) IBOutlet UIImageView *fouthSpecial;

@property (strong, nonatomic) NSArray *main_ads;

@property (strong, nonatomic) NSArray *notices;

@property (copy, nonatomic) ZXHomeHeadLineCellImgClick zxHomeHeadLineCellImgClick;

@property (copy, nonatomic) ZXHomeHeadLineCellAdvertDidSelected zxHomeHeadLineCellAdvertDidSelected;

@end

NS_ASSUME_NONNULL_END
