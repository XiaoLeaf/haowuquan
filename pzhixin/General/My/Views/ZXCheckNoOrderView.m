//
//  ZXCheckNoOrderView.m
//  pzhixin
//
//  Created by zhixin on 2019/9/12.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCheckNoOrderView.h"

@implementation ZXCheckNoOrderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.checkBtn.layer setCornerRadius:2.0];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 10.0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    [self.reasonLab setAttributedText:[[NSAttributedString alloc] initWithString:@"1、订单有延迟，建议下单后15分钟再查询。\n2、非您购买或推广的订单。\n3、不是通过好物券APP下的订单。\n4、创建订单超过40分钟付款，次日才能同步。" attributes:dic]];
}

#pragma mark - Button Method

- (IBAction)handleTapCheckBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkNoOrderViewHanldeTapCheckBtnAction)]) {
        [self.delegate checkNoOrderViewHanldeTapCheckBtnAction];
    }
}

@end
