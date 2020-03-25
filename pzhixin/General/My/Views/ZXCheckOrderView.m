//
//  ZXCheckOrderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/8.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCheckOrderView.h"
#import <Masonry/Masonry.h>

@implementation ZXCheckOrderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.orderNumTF.layer setCornerRadius:self.orderNumTF.frame.size.height/2.0];
    [self.checkBtn.layer setCornerRadius:self.checkBtn.frame.size.height/2.0];
    [self.contentView.layer setCornerRadius:5.0];
    
    self.ruleLab = [[UILabel alloc] init];
    [self.ruleLab setTextColor:COLOR_999999];
    [self.ruleLab setNumberOfLines:0];
    [self.ruleLab setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.ruleLab];
    [self.ruleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(17.0);
        make.right.mas_equalTo(self).mas_offset(-17.0);
        make.top.mas_equalTo(self.titleView.mas_bottom).mas_offset(15.0);
        make.height.mas_equalTo(0.0).priorityLow();
    }];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 10.0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    [self.ruleLab setAttributedText:[[NSAttributedString alloc] initWithString:@"1.购买人买有同步的订单可通过订单查询找回。\n2.当查找人查到订单，并且该订单在订单库确实找不到归属时，该订单归属查找人。\n3.已归属的订单不支持继续查询。\n4.受益将按照查找人的当前用户关系进行归属。\n5.建议购买人自查，运营商帮助会员查询时，不要点击确认找回，可让购买人自查并找回。\n6.受益将按照查找人的当前用户关系进行归属。" attributes:dic]];
}

#pragma mark - Button Method

- (IBAction)handleTapCheckBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkOrderViewHandleTapCheckBtnAction)]) {
        [self.delegate checkOrderViewHandleTapCheckBtnAction];
    }
}

@end
