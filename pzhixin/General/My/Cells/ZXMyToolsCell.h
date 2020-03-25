//
//  ZXMyToolsCell.h
//  pzhixin
//
//  Created by zhixin on 2019/10/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZXMyToolsCellDidSelectedBlock)(NSInteger index);

@interface ZXMyToolsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UICollectionView *toolCollectionView;

@property (copy, nonatomic) ZXMyToolsCellDidSelectedBlock zxMyToolsCellDidSelectedBlock;

@property (strong, nonatomic) ZXMyMenu *myMenu;

@end

NS_ASSUME_NONNULL_END
