//
//  ZXPickerManager.h
//  pzhixin
//
//  Created by zhixin on 2019/9/25.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZXPickManagerBlock) (NSString *yearStr, NSString *monthStr);

@interface ZXPickerManager : UIViewController

@property (strong, nonatomic) NSArray *dataSource;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, copy) ZXPickManagerBlock zxPickManagerBlock;

@end

NS_ASSUME_NONNULL_END
