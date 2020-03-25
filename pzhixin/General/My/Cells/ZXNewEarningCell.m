//
//  ZXNewEarningCell.m
//  pzhixin
//
//  Created by zhixin on 2019/11/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXNewEarningCell.h"

@interface ZXNewEarningCell ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *firstVal;
@property (weak, nonatomic) IBOutlet UIView *secView;
@property (weak, nonatomic) IBOutlet UILabel *secTitle;
@property (weak, nonatomic) IBOutlet UILabel *secVal;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitle;
@property (weak, nonatomic) IBOutlet UILabel *thirdVal;


@end

@implementation ZXNewEarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapItemViewAction:)];
    [_firstView addGestureRecognizer:tapFirst];
    
    UITapGestureRecognizer *tapSec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapItemViewAction:)];
    [_secView addGestureRecognizer:tapSec];
    
    UITapGestureRecognizer *tapThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapItemViewAction:)];
    [_thirdView addGestureRecognizer:tapThird];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapItemViewAction:(UIGestureRecognizer *)recognizer {
    UIView *tapView = recognizer.view;
    NSInteger viewTag = tapView.tag;
    if (_itemList.count > viewTag) {
        ZXProfitSubItem *subItem = (ZXProfitSubItem *)[_itemList objectAtIndex:viewTag];
        if (self.zxNewEarningCellItemClick) {
            self.zxNewEarningCellItemClick(subItem);
        }
    }
}

#pragma mark - Setter

- (void)setItemList:(NSArray *)itemList {
    _itemList = itemList;
    for (int i = 0; i < _itemList.count; i++) {
        ZXProfitSubItem *subItem = (ZXProfitSubItem *)[_itemList objectAtIndex:i];
        switch (i) {
            case 0:
            {
                [_firstTitle setText:subItem.txt];
                [_firstVal setText:subItem.val];
            }
                break;
            case 1:
            {
                [_secTitle setText:subItem.txt];
                [_secVal setText:subItem.val];
            }
                break;
            case 2:
            {
                [_thirdTitle setText:subItem.txt];
                [_thirdVal setText:subItem.val];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
