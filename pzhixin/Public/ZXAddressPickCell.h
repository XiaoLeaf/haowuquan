//
//  ZXAddressPickCell.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPcasJson.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressPickCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (strong, nonatomic) ZXPcasJson *pcasJson;

@end

NS_ASSUME_NONNULL_END
