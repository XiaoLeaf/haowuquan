//
//  ZXSpecialVC.h
//  pzhixin
//
//  Created by zhixin on 2019/11/7.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSpecialVC : UIViewController

@property (assign, nonatomic) BOOL single;

@property (strong, nonatomic) NSString *sid;

@property (strong, nonatomic) ZXSubjectCat *subjectCat;

@property (strong, nonatomic) ZXSubjectResult *subjectResult;

@end

NS_ASSUME_NONNULL_END
