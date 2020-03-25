//
//  ZXRankListCell.m
//  pzhixin
//
//  Created by zhixin on 2019/10/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXRankListCell.h"

@interface ZXRankListCell ()

@property (weak, nonatomic) IBOutlet UIButton *rankBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *earningLab;

@end

@implementation ZXRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImg.layer setCornerRadius:17.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRanking:(ZXRanking *)ranking {
    _ranking = ranking;
    switch ([_ranking.no integerValue]) {
        case 1:
            [_rankBtn setImage:[UIImage imageNamed:@"ic_rank_first"] forState:UIControlStateNormal];
            [_rankBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case 2:
            [_rankBtn setImage:[UIImage imageNamed:@"ic_rank_second"] forState:UIControlStateNormal];
            [_rankBtn setTitle:@"" forState:UIControlStateNormal];
            break;
        case 3:
            [_rankBtn setImage:[UIImage imageNamed:@"ic_rank_third"] forState:UIControlStateNormal];
            [_rankBtn setTitle:@"" forState:UIControlStateNormal];
            break;
            
        default:
            [_rankBtn setImage:[UIImage new] forState:UIControlStateNormal];
            [_rankBtn setTitle:_ranking.no forState:UIControlStateNormal];
            break;
    }
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:_ranking.user.icon] imageView:_headImg placeholderImage:DEFAULT_HEAD_IMG options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    [_nameLab setText:_ranking.user.nickname];
    [_phoneLab setText:_ranking.user.tel];
    [_earningLab setText:[NSString stringWithFormat:@"￥%@", _ranking.amount]];
}

@end
