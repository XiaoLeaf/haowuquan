//
//  ZXScoreDetailViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/29.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXScoreDetailViewController.h"
#import "ZXScoreDetailCell.h"
#import "ZXBalanceCell.h"
#import "ZXScoreDetailHeader.h"

@interface ZXScoreDetailViewController () <UITableViewDelegate, UITableViewDataSource> {
    
}

@end

@implementation ZXScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"积分明细" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self.detailTableView setEstimatedRowHeight:100.0];
    [self.detailTableView setRowHeight:UITableViewAutomaticDimension];
    [self.detailTableView registerClass:[ZXScoreDetailCell class] forCellReuseIdentifier:@"ZXScoreDetailCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    __weak typeof(self) weakSelf = self;
    ZXScoreDetailHeader *headerView = [[ZXScoreDetailHeader alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 40.0)];
    headerView.zxScoreDetailHeaderBtnClick = ^(NSInteger btnTag) {
        switch (btnTag) {
            case 0:
            {
                [ZXProgressHUD loadSucceedWithMsg:@"类型选择"];
            }
                break;
            case 1:
            {
                [ZXProgressHUD loadSucceedWithMsg:@"时间选择"];
            }
                break;
                
            default:
                break;
        }
    };
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXScoreDetailCell";
    ZXScoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

@end
