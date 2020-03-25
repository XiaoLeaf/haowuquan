//
//  ZXCheckOrderVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/6.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCheckOrderVC.h"
#import "ZXCheckOrderView.h"
#import "ZXCheckOrderResultVC.h"
#import <Masonry/Masonry.h>
#import "ZXCheckOrderResultVC.h"

@interface ZXCheckOrderVC () <ZXCheckOrderViewDelegate> {
    ZXCheckOrderView *checkOrderView;
}

@end

@implementation ZXCheckOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"订单查询" font:TITLE_FONT color:HOME_TITLE_COLOR];
    
    self.checkOrderScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.checkOrderScrollView setShowsVerticalScrollIndicator:NO];
    [self.checkOrderScrollView setShowsHorizontalScrollIndicator:NO];
//    [self.checkOrderScrollView setDelegate:self];
    [self.view addSubview:self.checkOrderScrollView];
    
    [self createCheckOrderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void)createCheckOrderView {
    NSString *ruleStr = @"1.购买人买有同步的订单可通过订单查询找回；\n2.当查找人查到订单，并且该订单在订单库确实找不到归属时，该订单归属查找人；\n3.已归属的订单不支持继续查询；\n4.受益将按照查找人的当前用户关系进行归属；\n5.建议购买人自查，运营商帮助会员查询时，不要点击确认找回，可让购买人自查并找回；\n6.受益将按照查找人的当前用户关系进行归属。";
    if (!checkOrderView) {
        checkOrderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXCheckOrderView class]) owner:nil options:nil] lastObject];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 10.0;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
        CGSize sizeToFit = [ruleStr boundingRectWithSize:CGSizeMake(SCREENWIDTH - 34.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        
        [checkOrderView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 873.0 + 40.0 + sizeToFit.height)];
        [checkOrderView setDelegate:self];
    }
    [self.checkOrderScrollView addSubview:checkOrderView];
    [self.checkOrderScrollView setContentSize:CGSizeMake(SCREENWIDTH, checkOrderView.frame.size.height + NAVIGATION_HEIGHT + STATUS_HEIGHT)];
}

#pragma mark - ZXCheckOrderViewDelegate

- (void)checkOrderViewHandleTapCheckBtnAction {
    ZXCheckOrderResultVC *checkResult = [[ZXCheckOrderResultVC alloc] init];
    [self.navigationController pushViewController:checkResult animated:YES];
}

@end
