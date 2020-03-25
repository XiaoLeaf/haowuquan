//
//  ZXCheckOrderResultVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCheckOrderResultVC.h"
#import "ZXCheckNoOrderView.h"

@interface ZXCheckOrderResultVC () <ZXCheckNoOrderViewDelegate> {
    ZXCheckNoOrderView *noOrderView;
}

@end

@implementation ZXCheckOrderResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"查询结果" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self createNoOrderView];
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

- (void)createNoOrderView {
    if (!noOrderView) {
        noOrderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXCheckNoOrderView class]) owner:nil options:nil] lastObject];
        [noOrderView setFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 450.0)];
        [noOrderView setDelegate:self];
        [self.resultScrollView addSubview:noOrderView];
    }
}

#pragma mark - ZXCheckNoOrderViewDelegate

- (void)checkNoOrderViewHanldeTapCheckBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
