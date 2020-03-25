//
//  ZXMenuNewCell.m
//  pzhixin
//
//  Created by zhixin on 2019/11/18.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMenuNewCell.h"

@interface ZXMenuNewCell ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UIView *secView;
@property (weak, nonatomic) IBOutlet UIImageView *secImg;
@property (weak, nonatomic) IBOutlet UILabel *secLab;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;
@property (weak, nonatomic) IBOutlet UIView *fouthView;
@property (weak, nonatomic) IBOutlet UIImageView *fouthImg;
@property (weak, nonatomic) IBOutlet UILabel *fouthLab;
@property (weak, nonatomic) IBOutlet UIView *fifthView;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImg;
@property (weak, nonatomic) IBOutlet UILabel *fifthLab;


@end

@implementation ZXMenuNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self setBackgroundColor:BG_COLOR];
    // Initialization code
    UITapGestureRecognizer *tapFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMenuViewAction:)];
    [_firstView addGestureRecognizer:tapFirst];
    
    UITapGestureRecognizer *tapSec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMenuViewAction:)];
    [_secView addGestureRecognizer:tapSec];
    
    UITapGestureRecognizer *tapThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMenuViewAction:)];
    [_thirdView addGestureRecognizer:tapThird];
    
    UITapGestureRecognizer *tapFouth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMenuViewAction:)];
    [_fouthView addGestureRecognizer:tapFouth];
    
    UITapGestureRecognizer *tapFifth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMenuViewAction:)];
    [_fifthView addGestureRecognizer:tapFifth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_firstImg.layer setCornerRadius:_firstImg.frame.size.width/2.0];
    [_secImg.layer setCornerRadius:_secImg.frame.size.width/2.0];
    [_thirdImg.layer setCornerRadius:_thirdImg.frame.size.width/2.0];
    [_fouthImg.layer setCornerRadius:_fouthImg.frame.size.width/2.0];
    [_fifthImg.layer setCornerRadius:_fifthImg.frame.size.width/2.0];
}

#pragma mark - Setter

- (void)setMenuList:(NSArray *)menuList {
    _menuList = [menuList subarrayWithRange:NSMakeRange(self.tag * 5, menuList.count - self.tag * 5)];
    if ([_menuList count] > 0) {
        ZXHomeSlides *homeBtn = (ZXHomeSlides *)[_menuList objectAtIndex:0];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:homeBtn.img] imageView:_firstImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
        [_firstLab setText:homeBtn.name];
    }
    
    if ([_menuList count] > 1) {
        ZXHomeSlides *homeBtn = (ZXHomeSlides *)[_menuList objectAtIndex:1];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:homeBtn.img] imageView:_secImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
        [_secLab setText:homeBtn.name];
    }
    
    if ([_menuList count] > 2) {
        ZXHomeSlides *homeBtn = (ZXHomeSlides *)[_menuList objectAtIndex:2];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:homeBtn.img] imageView:_thirdImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
        [_thirdLab setText:homeBtn.name];
    }
    
    if ([_menuList count] > 3) {
        ZXHomeSlides *homeBtn = (ZXHomeSlides *)[_menuList objectAtIndex:3];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:homeBtn.img] imageView:_fouthImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
        [_fouthLab setText:homeBtn.name];
    }
    
    if ([_menuList count] > 4) {
        ZXHomeSlides *homeBtn = (ZXHomeSlides *)[_menuList objectAtIndex:4];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:homeBtn.img] imageView:_fifthImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
        [_fifthLab setText:homeBtn.name];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapMenuViewAction:(UIGestureRecognizer *)gesture {
    UIView *tapView = gesture.view;
    if (_menuList.count <= tapView.tag) {
        return;
    }
    if (self.zxMenuNewCellMenuClick) {
        self.zxMenuNewCellMenuClick(self.tag, tapView.tag);
    }
}

@end
