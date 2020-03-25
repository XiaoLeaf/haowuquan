//
//  ZXMemberViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXMemberViewController.h"
#import "ZXScoreViewController.h"
#import <Masonry/Masonry.h>
#import "ZXSubDoubleCell.h"
#import "ZXNewFansVC.h"
#import <LTNavigationBar/UINavigationBar+Awesome.h>
#import "ZXMemberRightsCell.h"
#import "ZXMemberScoreCell.h"
#import "ZXMemberPromoteCell.h"

@interface ZXMemberViewController () <UITableViewDataSource, UITableViewDelegate> {
}

@property (strong, nonatomic) NSArray *taskList;

@property (strong, nonatomic) UITableView *memberTable;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (assign, nonatomic) BOOL isLoaded;

//@property (strong, nonatomic) UITableView *memberTable;

@end

@implementation ZXMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    _taskList = @[@"", @"", @""];
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_memberTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNav.mas_bottom);
        make.right.left.mas_equalTo(0.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(0.0);
        }
    }];
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

- (void)createSubViews {
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_member_bg"]];
    [bgImg setContentMode:UIViewContentModeScaleAspectFill];
    [bgImg setClipsToBounds:YES];
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_greaterThanOrEqualTo(NAVIGATION_HEIGHT + STATUS_HEIGHT + 386.0);
    }];
    
    _customNav = [[ZXCustomNavView alloc] initWithLeftContent:@"" title:@"会员" titleColor:[UIColor whiteColor] rightContent:@"粉丝" leftDot:NO];
    [_customNav setLeftHidden:YES];
    [_customNav setBackgroundColor:[UIColor clearColor]];

    __weak typeof(self) weakSelf = self;
    _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, FANS_VC] andUserInfo:nil viewController:weakSelf];
    };
    [self.view addSubview:_customNav];
    
    _memberTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_memberTable setShowsVerticalScrollIndicator:NO];
    [_memberTable setShowsHorizontalScrollIndicator:NO];
    [_memberTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_memberTable setDelegate:self];
    [_memberTable setDataSource:self];
    [_memberTable registerClass:[ZXMemberRightsCell class] forCellReuseIdentifier:@"ZXMemberRightsCell"];
    [_memberTable registerClass:[ZXMemberScoreCell class] forCellReuseIdentifier:@"ZXMemberScoreCell"];
    [_memberTable registerClass:[ZXMemberPromoteCell class] forCellReuseIdentifier:@"ZXMemberPromoteCell"];
    [_memberTable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_memberTable];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 386.0;
            break;
        case 1:
            return 40.0 + [_taskList count] * 65.0 + 10.0;
            break;
        case 2:
            return 300.0 + 5.0;
            break;
            
        default:
            return 0.0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"ZXMemberRightsCell";
            ZXMemberRightsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:
        {
            static NSString *identifier = @"ZXMemberScoreCell";
            ZXMemberScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (!_isLoaded) {
                [cell setTaskList:_taskList];
            }
            _isLoaded = YES;
            cell.zxMemberScoreCellBtnClick = ^{
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, SCORE_VC] andUserInfo:nil viewController:weakSelf];
            };
            return cell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"ZXMemberPromoteCell";
            ZXMemberPromoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
            
        default:
            return  nil;
            break;
    }
}

@end
