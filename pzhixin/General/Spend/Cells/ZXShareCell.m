//
//  ZXShareCell.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXShareCell.h"
#import <Masonry/Masonry.h>

@interface ZXShareCell () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZXShareImgCellDelegate> {
    
}

@end

@implementation ZXShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.showEarn setSelected:YES];
    [self.showCode setSelected:YES];
    [self.showLink setSelected:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    [self setBackgroundColor:BG_COLOR];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Setter

- (void)setPickStateList:(NSArray *)pickStateList {
    _pickStateList = pickStateList;
    [_imgCollection reloadData];
}

- (void)setGoodsShare:(ZXGoodsShare *)goodsShare {
    _goodsShare = goodsShare;
    [_secLine setNeedsLayout];
    [_secLine layoutIfNeeded];
    [UtilsMacro drawLineOfDashByCAShapeLayer:_secLine lineLength:2.0 lineSpacing:1.0 lineColor:[UtilsMacro colorWithHexString:@"AAAAAA"] lineDirection:YES];
    [_thirdLine setNeedsLayout];
    [_thirdLine layoutIfNeeded];
    [UtilsMacro drawLineOfDashByCAShapeLayer:_thirdLine lineLength:2.0 lineSpacing:1.0 lineColor:[UtilsMacro colorWithHexString:@"AAAAAA"] lineDirection:YES];
    [_fouthLine setNeedsLayout];
    [_fouthLine layoutIfNeeded];
    [UtilsMacro drawLineOfDashByCAShapeLayer:_fouthLine lineLength:2.0 lineSpacing:1.0 lineColor:[UtilsMacro colorWithHexString:@"AAAAAA"] lineDirection:YES];
    NSMutableParagraphStyle *titleStyle = [[NSMutableParagraphStyle alloc] init];
    titleStyle.alignment = NSTextAlignmentLeft;
    titleStyle.lineSpacing = 9.0;
    NSDictionary *titleDict = @{NSParagraphStyleAttributeName:titleStyle};
    [_titleTV setAttributedText:[[NSAttributedString alloc] initWithString:_goodsShare.desc attributes:titleDict]];
    
    NSMutableParagraphStyle *writeStyle = [[NSMutableParagraphStyle alloc] init];
    writeStyle.alignment = NSTextAlignmentLeft;
    writeStyle.lineSpacing = 0.0;
    NSDictionary *titleDict1 = @{NSParagraphStyleAttributeName:writeStyle};
    [_writeTV setAttributedText:[[NSAttributedString alloc] initWithString:_goodsShare.title attributes:titleDict1]];
    
    [_originalPrice setText:[NSString stringWithFormat:@"【原价】%@元", _goodsShare.ori_price]];
    [_currentPrice setText:[NSString stringWithFormat:@"【券后价】%@元", _goodsShare.price]];
    [_earningLab setText:[NSString stringWithFormat:@"%@", _goodsShare.top_txt]];
    
    if ([UtilsMacro whetherIsEmptyWithObject:_goodsShare.tpwd]) {
        [_cpLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.thirdLine.mas_bottom);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
            make.height.mas_equalTo(0.0);
        }];
    } else {
        [_cpLab setText:_goodsShare.tpwd];
        [_cpLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.thirdLine.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
        }];
    }
    
    if (_showEarn.isSelected) {
        [_saveLab setText:[NSString stringWithFormat:@"%@%@元", _goodsShare.commission_txt, _goodsShare.commission]];
        [_saveLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentPrice.mas_bottom).mas_offset(5.0);
            make.height.mas_equalTo(15.0);
        }];
    } else {
        [_saveLab setText:@""];
        [_saveLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentPrice.mas_bottom).mas_offset(0.0);
            make.height.mas_equalTo(0.0);
        }];
    }
    
    if ([UtilsMacro whetherIsEmptyWithObject:_goodsShare.icode]) {
        [_thirdLine setHidden:YES];
        [_thirdLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inviteCode.mas_bottom).mas_offset(0.0);
            make.height.mas_equalTo(0.0);
        }];
        [_inviteCode mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.secLine.mas_bottom);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
            make.height.mas_equalTo(0.0);
        }];
        [_showCode mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.0).priorityHigh();
            make.left.mas_equalTo(self.showEarn.mas_right).mas_offset(0.0);
        }];
        [_showCode mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showEarn.mas_right).mas_offset(0.0);
            make.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(0.0);
        }];
    } else {
        [_showCode mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showEarn.mas_right).mas_offset(10.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
        [_inviteCode setText:_goodsShare.icode];
        if (_showCode.isSelected) {
            [_thirdLine setHidden:NO];
            [_inviteCode mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.secLine.mas_bottom).mas_offset(10.0);
                make.left.mas_equalTo(16.0);
                make.right.mas_equalTo(-16.0);
            }];
            [_thirdLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.inviteCode.mas_bottom).mas_offset(10.0);
                make.height.mas_equalTo(0.5);
            }];
        } else {
            [_thirdLine setHidden:YES];
            [_inviteCode mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.secLine.mas_bottom).mas_offset(0.0);
                make.left.mas_equalTo(16.0);
                make.right.mas_equalTo(-16.0);
                make.height.mas_equalTo(0.0);
            }];
            [_thirdLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.inviteCode.mas_bottom).mas_offset(0.0);
                make.height.mas_equalTo(0.0);
            }];
        }
    }
    
    if ([UtilsMacro whetherIsEmptyWithObject:_goodsShare.share_url]) {
        [_fouthLine setHidden:YES];
        [_fouthLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cpLab.mas_bottom).mas_offset(0.0);
            make.height.mas_equalTo(0.0);
        }];
        [_linkLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fouthLine.mas_bottom);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
            make.height.mas_equalTo(0.0);
            make.bottom.mas_equalTo(-13.0).priorityHigh();
        }];
        [_showLink mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showCode.mas_right).mas_offset(0.0);
            make.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(0.0);
        }];
    } else {
        [_showLink mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showCode.mas_right).mas_offset(10.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
        [_linkLab setText:_goodsShare.share_url];
        if (_showLink.isSelected) {
            [_fouthLine setHidden:NO];
            [_fouthLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.cpLab.mas_bottom).mas_offset(10.0);
                make.height.mas_equalTo(0.5);
            }];
            [_linkLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.fouthLine.mas_bottom).mas_offset(10.0);
                make.left.mas_equalTo(16.0);
                make.right.mas_equalTo(-16.0);
                make.bottom.mas_equalTo(self.goodsContentView.mas_bottom).mas_offset(-13.0);
            }];
        } else {
            [_fouthLine setHidden:YES];
            [_fouthLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.cpLab.mas_bottom).mas_offset(0.0);
                make.height.mas_equalTo(0.0);
            }];
            [_linkLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.fouthLine.mas_bottom);
                make.left.mas_equalTo(16.0);
                make.right.mas_equalTo(-16.0);
                make.height.mas_equalTo(0.0);
                make.bottom.mas_equalTo(-13.0).priorityHigh();
            }];
        }
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        [_mainView setBackgroundColor:BG_COLOR];
        [self.contentView addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_topView) {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UtilsMacro colorWithHexString:@"FD4F05"]];
        [_mainView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.mainView);
            make.height.mas_equalTo(35.0);
        }];
    }
    
    UIImageView *earnImg = [[UIImageView alloc] init];
    [earnImg setImage:[UIImage imageNamed:@"ic_share_earning"]];
    [_topView addSubview:earnImg];
    [earnImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15.0);
        make.left.mas_equalTo(10.0);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    if (!_earningLab) {
        _earningLab = [[UILabel alloc] init];
        [_earningLab setTextColor:[UIColor whiteColor]];
        [_earningLab setFont:[UIFont systemFontOfSize:14.0]];
        [_topView addSubview:_earningLab];
        [_earningLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.left.mas_equalTo(earnImg.mas_right).mas_offset(5.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.topView.mas_bottom);
        }];
    }
    
    if (!_titleTV) {
        _titleTV = [[UITextView alloc] init];
        [_titleTV setTextColor:HOME_TITLE_COLOR];
        [_titleTV setScrollEnabled:NO];
        [_titleTV setDelegate:self];
        [_titleTV setFont:[UIFont systemFontOfSize:12.0]];
        [_titleView addSubview:_titleTV];
        [_titleTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13.0);
            make.right.mas_equalTo(-13.0);
            make.top.mas_equalTo(15.0);
        }];
    }
    
    if (!_cpBtn) {
        _cpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_cpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cpBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_cpBtn setTag:0];
        [_cpBtn addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cpBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"FD4F05"]];
        [_cpBtn.layer setCornerRadius:7.5];
        [_titleView addSubview:_cpBtn];
        [_cpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleTV.mas_bottom).mas_offset(10.0);
            make.right.mas_equalTo(-13.0);
            make.width.mas_equalTo(36.0);
            make.height.mas_equalTo(15.0);
            make.bottom.mas_equalTo(-10.0).priorityHigh();
        }];
    }
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
        [_mainView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleView.mas_bottom);
            make.left.mas_equalTo(13.0);
            make.right.mas_equalTo(-13.0);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    if (!_writerView) {
        _writerView = [[UIView alloc] init];
        [_writerView setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_writerView];
        [_writerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom);
            make.left.right.mas_equalTo(0.0);
            make.height.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    UIView *writeHeader = [[UIView alloc] init];
    [_writerView addSubview:writeHeader];
    [writeHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(44.0);
    }];
    
    UIView *writeTip = [[UIView alloc] init];
    [writeTip setBackgroundColor:THEME_COLOR];
    [writeTip.layer setCornerRadius:1.0];
    [writeHeader addSubview:writeTip];
    [writeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0);
        make.height.mas_equalTo(15.0);
        make.centerY.mas_equalTo(writeHeader);
        make.width.mas_equalTo(2.0);
    }];
    
    UILabel *writeHeaderTitle = [[UILabel alloc] init];
    [writeHeaderTitle setFont:[UIFont systemFontOfSize:15.0]];
    [writeHeaderTitle setTextColor:HOME_TITLE_COLOR];
    [writeHeaderTitle setText:@"编辑分享文案"];
    [writeHeader addSubview:writeHeaderTitle];
    [writeHeaderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(writeTip.mas_right).mas_offset(6.0);
        make.top.bottom.mas_equalTo(writeHeader);
        make.width.mas_equalTo(0.0).priorityLow();
    }];
    
    _goodsContentView = [[UIView alloc] init];
    [_goodsContentView.layer setCornerRadius:2.0];
    [_goodsContentView setBackgroundColor:[UtilsMacro colorWithHexString:@"F9F9F9"]];
    [_writerView addSubview:_goodsContentView];
    [_goodsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(writeHeader.mas_bottom);
        make.left.mas_equalTo(13.0);
        make.right.mas_equalTo(-13.0);
    }];
    
    if (!_writeTV) {
        _writeTV = [[UITextView alloc] init];
        [_writeTV setScrollEnabled:NO];
        [_writeTV setDelegate:self];
        [_writeTV setTextColor:HOME_TITLE_COLOR];
        [_writeTV setBackgroundColor:[UIColor clearColor]];
        [_writeTV setFont:[UIFont systemFontOfSize:14.0]];
        [_goodsContentView addSubview:_writeTV];
        [_writeTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(13.0).priorityHigh();
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
        }];
    }
    
    if (!_originalPrice) {
        _originalPrice = [[UILabel alloc] init];
        [_originalPrice setFont:[UIFont systemFontOfSize:12.0]];
        [_originalPrice setTextColor:COLOR_666666];
        [_goodsContentView addSubview:_originalPrice];
        [_originalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.writeTV.mas_bottom).mas_offset(20.0);
            make.height.mas_equalTo(15.0);
            make.left.mas_equalTo(16.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_currentPrice) {
        _currentPrice = [[UILabel alloc] init];
        [_currentPrice setFont:[UIFont systemFontOfSize:12.0]];
        [_currentPrice setTextColor:COLOR_666666];
        [_goodsContentView addSubview:_currentPrice];
        [_currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.originalPrice.mas_bottom).mas_offset(5.0);
            make.height.mas_equalTo(15.0);
            make.left.mas_equalTo(16.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_saveLab) {
        _saveLab = [[UILabel alloc] init];
        [_saveLab setFont:[UIFont systemFontOfSize:12.0]];
        [_saveLab setTextColor:COLOR_666666];
        [_goodsContentView addSubview:_saveLab];
        [_saveLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentPrice.mas_bottom).mas_offset(5.0);
            make.height.mas_equalTo(15.0);
            make.left.mas_equalTo(16.0);
            make.width.mas_equalTo(0.0).priorityLow();
        }];
    }
    
    if (!_secLine) {
        _secLine = [[UIView alloc] init];
        [_goodsContentView addSubview:_secLine];
        [_secLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.saveLab.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(16.0);
            make.height.mas_equalTo(0.5);
            make.width.mas_equalTo(130.0);
        }];
        [UtilsMacro drawLineOfDashByCAShapeLayer:_secLine lineLength:2.0 lineSpacing:1.0 lineColor:[UtilsMacro colorWithHexString:@"AAAAAA"] lineDirection:YES];
    }

    if (!_inviteCode) {
        _inviteCode = [[UILabel alloc] init];
        [_inviteCode setFont:[UIFont systemFontOfSize:12.0]];
        [_inviteCode setTextColor:COLOR_666666];
        [_inviteCode setNumberOfLines:0];
        [_inviteCode setPreferredMaxLayoutWidth:SCREENWIDTH - 29.0];
        [_inviteCode setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_goodsContentView addSubview:_inviteCode];
        [_inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.secLine.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
        }];
    }

    if (!_thirdLine) {
        _thirdLine = [[UIView alloc] init];
        [_goodsContentView addSubview:_thirdLine];
        [_thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.inviteCode.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(16.0);
            make.height.mas_equalTo(0.5);
            make.width.mas_equalTo(130.0);
        }];
    }

    if (!_cpLab) {
        _cpLab = [[UILabel alloc] init];
        [_cpLab setFont:[UIFont systemFontOfSize:12.0]];
        [_cpLab setTextColor:COLOR_666666];
        [_cpLab setNumberOfLines:0];
        [_cpLab setPreferredMaxLayoutWidth:SCREENWIDTH - 29.0];
        [_cpLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_goodsContentView addSubview:_cpLab];
        [_cpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
            make.top.mas_equalTo(self.thirdLine.mas_bottom).mas_offset(10.0);
        }];
    }

    if (!_fouthLine) {
        _fouthLine = [[UIView alloc] init];
        [_goodsContentView addSubview:_fouthLine];
        [_fouthLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cpLab.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(16.0);
            make.height.mas_equalTo(0.5);
            make.width.mas_equalTo(130.0);
        }];
    }
    
    if (!_linkLab) {
        _linkLab = [[UILabel alloc] init];
        [_linkLab setFont:[UIFont systemFontOfSize:12.0]];
        [_linkLab setTextColor:COLOR_666666];
        [_linkLab setNumberOfLines:0];
        [_linkLab setPreferredMaxLayoutWidth:SCREENWIDTH - 29.0];
        [_linkLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_goodsContentView addSubview:_linkLab];
        [_linkLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fouthLine.mas_bottom).mas_offset(10.0);
            make.left.mas_equalTo(16.0);
            make.right.mas_equalTo(-16.0);
            make.bottom.mas_equalTo(-13.0).priorityHigh();
        }];
    }
    
    UIView *btnView = [[UIView alloc] init];
    [_writerView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.0);
        make.right.mas_equalTo(-12.0);
        make.top.mas_equalTo(self.goodsContentView.mas_bottom);
        make.height.mas_equalTo(40.0);
        make.bottom.mas_equalTo(0.0).priorityHigh();
    }];
    
    if (!_cpCode) {
        _cpCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpCode setTitle:@" 复制口令 " forState:UIControlStateNormal];
        [_cpCode setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_cpCode setBackgroundColor:[UtilsMacro colorWithHexString:@"FFF0E3"]];
        [_cpCode.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_cpCode.layer setCornerRadius:8.0];
        [_cpCode setTag:4];
        [_cpCode addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_cpCode];
        [_cpCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0.0);
            make.centerY.mas_equalTo(btnView);
            make.height.mas_equalTo(16.0);
        }];
    }
    
    if (!_cpLink) {
        _cpLink = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpLink setTitle:@" 复制链接 " forState:UIControlStateNormal];
        [_cpLink setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_cpLink setBackgroundColor:[UtilsMacro colorWithHexString:@"FFF0E3"]];
        [_cpLink.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_cpLink.layer setCornerRadius:8.0];
        [_cpLink setTag:5];
        [_cpLink addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_cpLink];
        [_cpLink mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cpCode.mas_left).mas_offset(-10.0);
            make.centerY.mas_equalTo(btnView);
            make.height.mas_equalTo(16.0);
        }];
    }
    
    if (!_showEarn) {
        _showEarn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showEarn setTitle:@"收益" forState:UIControlStateNormal];
        [_showEarn setImage:[UIImage imageNamed:@"ic_share_pick_nor"] forState:UIControlStateNormal];
        [_showEarn setImage:[UIImage imageNamed:@"ic_share_pick_selected"] forState:UIControlStateSelected];
        [_showEarn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_showEarn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_showEarn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_showEarn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0)];
        [_showEarn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_showEarn setSelected:YES];
        [_showEarn setTag:1];
        [_showEarn addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_showEarn];
        [_showEarn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_showCode) {
        _showCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showCode setTitle:@"邀请码" forState:UIControlStateNormal];
        [_showCode setImage:[UIImage imageNamed:@"ic_share_pick_nor"] forState:UIControlStateNormal];
        [_showCode setImage:[UIImage imageNamed:@"ic_share_pick_selected"] forState:UIControlStateSelected];
        [_showCode setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_showCode setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_showCode setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0)];
        [_showCode.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_showCode setSelected:YES];
        [_showCode setTag:2];
        [_showCode addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_showCode];
        [_showCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showEarn.mas_right).mas_offset(10.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_showLink) {
        _showLink = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showLink setTitle:@"链接" forState:UIControlStateNormal];
        [_showLink setImage:[UIImage imageNamed:@"ic_share_pick_nor"] forState:UIControlStateNormal];
        [_showLink setImage:[UIImage imageNamed:@"ic_share_pick_selected"] forState:UIControlStateSelected];
        [_showLink setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_showLink setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_showLink setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0)];
        [_showLink.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_showLink setSelected:YES];
        [_showLink setTag:3];
        [_showLink addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_showLink];
        [_showLink mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.showCode.mas_right).mas_offset(10.0);
            make.top.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_imgContainer) {
        CGFloat containerHeight = 45.0 + (SCREENWIDTH - 32.0) / 2.0 * 108.0 / 64.0;
        _imgContainer = [[UIView alloc] init];
        [_imgContainer setBackgroundColor:[UIColor whiteColor]];
        [_mainView addSubview:_imgContainer];
        [_imgContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(self.writerView.mas_bottom).mas_offset(10.0);
            make.height.mas_equalTo(containerHeight);
            make.bottom.mas_equalTo(-10.0).priorityHigh();
        }];
    }
    
    UIView *imgHeader = [[UIView alloc] init];
    [_imgContainer addSubview:imgHeader];
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0.0);
        make.height.mas_equalTo(44.0);
    }];
    
    UIView *imgTip = [[UIView alloc] init];
    [imgTip setBackgroundColor:THEME_COLOR];
    [imgTip.layer setCornerRadius:1.0];
    [imgHeader addSubview:imgTip];
    [imgTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13.0);
        make.height.mas_equalTo(15.0);
        make.centerY.mas_equalTo(imgHeader);
        make.width.mas_equalTo(2.0);
    }];
    
    UILabel *imgHeaderTitle = [[UILabel alloc] init];
    [imgHeaderTitle setFont:[UIFont systemFontOfSize:15.0]];
    [imgHeaderTitle setTextColor:HOME_TITLE_COLOR];
    [imgHeaderTitle setText:@"选择图片"];
    [imgHeader addSubview:imgHeaderTitle];
    [imgHeaderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgTip.mas_right).mas_offset(6.0);
        make.top.bottom.mas_equalTo(imgHeader);
        make.width.mas_equalTo(0.0).priorityLow();
    }];
    
    if (!_allSelect) {
        _allSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelect setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelect setImage:[UIImage imageNamed:@"ic_share_pick_nor"] forState:UIControlStateNormal];
        [_allSelect setImage:[UIImage imageNamed:@"ic_share_pick_selected"] forState:UIControlStateSelected];
        [_allSelect setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [_allSelect setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_allSelect setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 2.5, 0.0, -2.5)];
        [_allSelect setImageEdgeInsets:UIEdgeInsetsMake(0.0, -2.5, 0.0, 2.5)];
        [_allSelect.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_allSelect setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_allSelect setTag:6];
        [_allSelect addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [imgHeader addSubview:_allSelect];
        [_allSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13.0);
            make.width.mas_equalTo(100.0);
            make.height.mas_equalTo(30.0);
            make.centerY.mas_equalTo(imgHeader);
        }];
    }
    
    UIView *imgContent = [[UIView alloc] init];
    [_imgContainer addSubview:imgContent];
    [imgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.0);
        make.right.mas_equalTo(-16.0);
        make.top.mas_equalTo(imgHeader.mas_bottom).mas_offset(1.0);
        make.bottom.mas_equalTo(-15.0);
    }];
    
    if (!_mainImg) {
        _mainImg = [[UIImageView alloc] init];
        [_mainImg setContentMode:UIViewContentModeScaleAspectFill];
        [_mainImg setBackgroundColor:[UtilsMacro colorWithHexString:@"F4F4F4"]];
        [_mainImg setClipsToBounds:YES];
        [_mainImg setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapMainImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMainImgAction)];
        [_mainImg addGestureRecognizer:tapMainImg];
        [imgContent addSubview:_mainImg];
        [_mainImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(imgContent.mas_width).multipliedBy(0.5);
        }];
    }
    
    if (!_mainPick) {
        _mainPick = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainPick setImage:[UIImage imageNamed:@"ic_share_pick_nor"] forState:UIControlStateNormal];
        [_mainPick setImage:[UIImage imageNamed:@"ic_share_pick_selected"] forState:UIControlStateSelected];
        [_mainPick setImageEdgeInsets:UIEdgeInsetsMake(5.0, 0.0, 0.0, 5.0)];
        [_mainPick addTarget:self action:@selector(handleTapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainPick setTag:7];
        [_mainPick setSelected:YES];
        [imgContent addSubview:_mainPick];
        [_mainPick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20.0);
            make.right.mas_equalTo(self.mainImg.mas_right).mas_offset(-5.0);
            make.top.mas_equalTo(self.mainImg.mas_top).mas_equalTo(5.0);
        }];
    }
    
    if (!_imgCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _imgCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_imgCollection setShowsVerticalScrollIndicator:NO];
        [_imgCollection setShowsHorizontalScrollIndicator:NO];
        [_imgCollection setDelegate:self];
        [_imgCollection setDataSource:self];
        [_imgCollection setBackgroundColor:[UIColor whiteColor]];
        [_imgCollection registerNib:[UINib nibWithNibName:NSStringFromClass([ZXShareImgCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXShareImgCell"];
        [imgContent addSubview:_imgCollection];
        [_imgCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.mas_equalTo(0.0);
            make.left.mas_equalTo(self.mainImg.mas_right).mas_offset(10.0);
        }];
    }
}

#pragma mark - Button Method

- (void)handleTapButtonAction:(UIButton *)button {
    switch (button.tag) {
        case 1:
        {
            [_showEarn setSelected:!_showEarn.isSelected];
        }
            break;
        case 2:
        {
            [_showCode setSelected:!_showCode.isSelected];
        }
            break;
        case 3:
        {
            [_showLink setSelected:!_showLink.isSelected];
        }
            break;
        case 6:
        {
            [_allSelect setSelected:!_allSelect.isSelected];
        }
            break;
        case 7:
        {
            [_mainPick setSelected:!_mainPick.isSelected];
        }
            break;
            
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareCellHanleTapBtnsActionWithBtn:andTag:)]) {
        [self.delegate shareCellHanleTapBtnsActionWithBtn:button andTag:button.tag];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareCellTextViewDidChange:)]) {
        [self.delegate shareCellTextViewDidChange:textView];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_goodsShare.slides count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = ((SCREENWIDTH - 32.0)/2.0 - 20.0)/2.0;
    return CGSizeMake(itemWidth, itemWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXShareImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXShareImgCell" forIndexPath:indexPath];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[_goodsShare.slides_thumb objectAtIndex:indexPath.row]] imageView:cell.mainImg placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:nil completed:nil];
    [cell.pickBtn setTag:indexPath.row];
    [cell.pickBtn setSelected:[[_pickStateList objectAtIndex:indexPath.row] boolValue]];
    [cell setDelegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *imgList = [[NSMutableArray alloc] initWithArray:_goodsShare.slides];
    NSMutableArray *thumbList = [[NSMutableArray alloc] initWithArray:_goodsShare.slides_thumb];
    [imgList insertObject:_posterImg atIndex:0];
    [thumbList insertObject:@"" atIndex:0];
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:indexPath.row + 1 andThumdList:thumbList];
}

#pragma mark - ZXShareImgCellDelegate

- (void)shareImgCellHanleTapPickBtnActionWithCell:(ZXShareImgCell *)cell andTag:(NSInteger)btnTag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareCellImgCellHanleTapPickBtnActionWithCell:andTag:)]) {
        [self.delegate shareCellImgCellHanleTapPickBtnActionWithCell:cell andTag:btnTag];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapMainImgAction {
    NSMutableArray *imgList = [[NSMutableArray alloc] initWithArray:self.goodsShare.slides];
    NSMutableArray *thumbList = [[NSMutableArray alloc] initWithArray:self.goodsShare.slides_thumb];
    [imgList insertObject:_posterImg atIndex:0];
    [thumbList insertObject:@"" atIndex:0];
    [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:imgList currentIndex:0 andThumdList:thumbList];
}

@end
