//
//  ZXAddressPicker.h
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYPagerController/TYTabPagerController.h>
#import "ZXPcasJson.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAddressPicker : TYTabPagerController

@property (strong, nonatomic) NSMutableArray *titleList;

@property (strong, nonatomic) ZXPcasJson *proPcasJosn;

@property (strong, nonatomic) ZXPcasJson *cityPcasJosn;

@property (strong, nonatomic) ZXPcasJson *areaPcasJosn;

@property (strong, nonatomic) ZXPcasJson *streetPcasJosn;

@property (copy, nonatomic) void (^zxAddressPickerResult) (ZXPcasJson * _Nullable proJson, ZXPcasJson * _Nullable cityJson, ZXPcasJson * _Nullable areaJson, ZXPcasJson  * _Nullable  streetJson);

@end

NS_ASSUME_NONNULL_END
