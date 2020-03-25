//
//  ZXCommonShareCell.m
//  pzhixin
//
//  Created by zhixin on 2019/11/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommonShareCell.h"

#define DISTANCE 20.0

@interface ZXCommonShareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation ZXCommonShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setItemInfo:(NSDictionary *)itemInfo {
    _itemInfo = itemInfo;
    [_imgView setImage:[_itemInfo valueForKey:@"img"]];
    [_nameLab setText:[_itemInfo valueForKey:@"title"]];
}

@end
