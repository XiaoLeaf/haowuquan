//
//  ZXCommunityCommentsCell.m
//  pzhixin
//
//  Created by zhixin on 2020/3/10.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXCommunityCommentsCell.h"
#import <Masonry/Masonry.h>

@interface ZXCommunityCommentsCell ()

@property (strong, nonatomic) UIView *commentView;

@property (strong, nonatomic) UIButton *btnCopy;

@end

@implementation ZXCommunityCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

#pragma mark - Setter

- (void)setComment:(ZXCommunityComment *)comment {
    _comment = comment;
    [self.commentLab setText:comment.txt];
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_commentView) {
        _commentView = [[UIView alloc] init];
        [_commentView setBackgroundColor:COLOR_F1F1F1];
        [_commentView setClipsToBounds:YES];
        [_commentView.layer setCornerRadius:2.0];
        [self.contentView addSubview:_commentView];
        [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_commentLab) {
        _commentLab = [[UILabel alloc] init];
        [_commentLab setNumberOfLines:0];
        [_commentLab setText:@"自购/分享，预估得【 2.91】\n 限时抢途径:好物券app首页—好店 \n 搜索关键词【捞旺】"];
        [_commentLab setTextColor:HOME_TITLE_COLOR];
        [_commentLab setFont:[UIFont systemFontOfSize:12.0]];
        [_commentView addSubview:_commentLab];
        [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_commentView).offset(10.0);
            make.left.mas_equalTo(self->_commentView).offset(10.0);
            make.right.mas_equalTo(self->_commentView).offset(-10.0);
            make.height.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_btnCopy) {
        _btnCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCopy setImage:[UIImage imageNamed:@"ic_community_copy"] forState:UIControlStateNormal];
        [_btnCopy setTitle:@"复制评论" forState:UIControlStateNormal];
        [_btnCopy.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_btnCopy.layer setCornerRadius:10.0];
        [_btnCopy setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_btnCopy setBackgroundColor:[UtilsMacro colorWithHexString:@"FFE5CE"]];
        [_btnCopy addTarget:self action:@selector(copyCommunityComment) forControlEvents:UIControlEventTouchUpInside];
        [_commentView addSubview:_btnCopy];
        [_btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.commentLab.mas_bottom).offset(10.0);
            make.bottom.mas_equalTo(self->_commentView.mas_bottom).offset(-10.0);
            make.right.mas_equalTo(self->_commentView.mas_right).offset(-10.0);
            make.width.mas_equalTo(70.0);
            make.height.mas_equalTo(20.0);
        }];
    }
}

#pragma mark - Button Method

- (void)copyCommunityComment {
    if (self.zxCommunityCommentsCellClickCopy) {
        self.zxCommunityCommentsCellClickCopy(_comment);
        return;
    }
}

@end
