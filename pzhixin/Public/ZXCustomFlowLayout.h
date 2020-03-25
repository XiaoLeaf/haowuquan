//
//  ZXCustomFlowLayout.h
//  pzhixin
//
//  Created by zhixin on 2019/11/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXCustomFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat totalWidth;

@property (assign, nonatomic) NSInteger lineNum;

@property (assign, nonatomic) NSInteger itemCount;

//collectionView是否从Xib加载。default is NO
@property (assign, nonatomic) BOOL fromNib;

@end

NS_ASSUME_NONNULL_END
