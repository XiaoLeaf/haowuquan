//
//  ZXFansView.m
//  pzhixin
//
//  Created by zhixin on 2019/10/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXFansView.h"
#import <Masonry/Masonry.h>
#import "ZXFansFirstCell.h"
#import "ZXFansHeaderView.h"
#import "ZXFansSecondCell.h"
#import "ZXFansSecHeaderView.h"
#import "ZXFansLatentCell.h"
#import "ZXFansLatentHeaderView.h"
#import "ZXNoFansCell.h"

@interface ZXFansView () <UITableViewDelegate, UITableViewDataSource, ZXNoFansCellDelegate, ZXFansHeaderViewDelegate>

@property (strong, nonatomic) UITableView *fansTable;

@property (strong, nonatomic) NSMutableArray *fansList;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSString *order;

@property (strong, nonatomic) ZXFansHeaderView *firstHeaderView;

@property (strong, nonatomic) ZXFansSecHeaderView *secHeaderView;

@end

@implementation ZXFansView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    _order = @"";
    return self;
}

#pragma mark - Setter

- (void)setDefaultResult:(NSArray *)defaultResult {
    _defaultResult = defaultResult;
    _fansList = [[NSMutableArray alloc] init];
    NSArray *resultList = [[NSArray alloc] initWithArray:defaultResult];
    for (int i = 0; i < [resultList count]; i++) {
        ZXFans *fans = [ZXFans yy_modelWithJSON:[resultList objectAtIndex:i]];
        [_fansList addObject:fans];
    }
    if ([_fansList count] >= 20) {
        ZXRefreshFooter *refresgFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFansList)];
        _fansTable.mj_footer = refresgFooter;
    } else {
        _fansTable.mj_footer = nil;
    }
    [_fansTable reloadData];
}

- (void)setIsDefault:(BOOL)isDefault {
    _isDefault  = isDefault;
    if (!isDefault) {
        [_fansTable.mj_header beginRefreshing];
    }
}

#pragma mark - Private Methods

- (void)createSubviews {
    if (!_fansTable) {
        _fansTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_fansTable setShowsVerticalScrollIndicator:NO];
        [_fansTable setShowsHorizontalScrollIndicator:NO];
        [_fansTable setDelegate:self];
        [_fansTable setDataSource:self];
        [_fansTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_fansTable setBackgroundColor:[UIColor whiteColor]];
        [_fansTable registerClass:[ZXFansFirstCell class] forCellReuseIdentifier:@"ZXFansFirstCell"];
        [_fansTable registerClass:[ZXFansSecondCell class] forCellReuseIdentifier:@"ZXFansSecondCell"];
        [self addSubview:_fansTable];
        [_fansTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0.0);
        }];
        ZXRefreshHeader *refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFanList)];
        [refreshHeader.stateLab setTextColor:COLOR_999999];
        _fansTable.mj_header = refreshHeader;
    }
}

- (void)refreshFanList {
    if ([UtilsMacro isCanReachableNetWork]) {
        _page = 1;
        [[ZXFansHelper sharedInstance] fetchFansWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andType:[NSString stringWithFormat:@"%ld",(long)_fansType] andOrder:_order completion:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD hideAllHUD];
            if ([self.fansTable.mj_header isRefreshing]) {
                [self.fansTable.mj_header endRefreshing];
            }
            self.fansList = [[NSMutableArray alloc] init];
            NSArray *resultList;
            if ([[response.data valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
                resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"list"]];
            } else {
                resultList = [[NSArray alloc] init];
            }
            for (int i = 0; i < [resultList count]; i++) {
                ZXFans *fans = [ZXFans yy_modelWithJSON:[resultList objectAtIndex:i]];
                [self.fansList addObject:fans];
            }
            if ([self.fansList count] >= [[response.data valueForKey:@"pagesize"] integerValue]) {
                ZXRefreshFooter *refresgFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFansList)];
                self.fansTable.mj_footer = refresgFooter;
            } else {
                self.fansTable.mj_footer = nil;
            }
            [self.fansTable reloadData];
        } error:^(ZXResponse * _Nonnull response) {
            if ([self.fansTable.mj_header isRefreshing]) {
                [self.fansTable.mj_header endRefreshing];
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        if ([self.fansTable.mj_header isRefreshing]) {
            [self.fansTable.mj_header endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)loadMoreFansList {
    _page++;
    [[ZXFansHelper sharedInstance] fetchFansWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andType:[NSString stringWithFormat:@"%ld",(long)_fansType] andOrder:_order completion:^(ZXResponse * _Nonnull response) {
        if ([self.fansTable.mj_footer isRefreshing]) {
            [self.fansTable.mj_footer endRefreshing];
        }
        NSArray *resultList;
        if ([[response.data valueForKey:@"list"] isKindOfClass:[NSArray class]]) {
            resultList = [[NSArray alloc] initWithArray:[response.data valueForKey:@"list"]];
        } else {
            resultList = [[NSArray alloc] init];
        }
        if ([resultList count] <= [[response.data valueForKey:@"pagesize"] integerValue]) {
            [self.fansTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.fansTable.mj_footer resetNoMoreData];
            for (int i = 0; i < [resultList count]; i++) {
                ZXFans *fans = [ZXFans yy_modelWithJSON:[resultList objectAtIndex:i]];
                [self.fansList addObject:fans];
            }
            [self.fansTable reloadData];
        }
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.fansTable.mj_footer isRefreshing]) {
            [self.fansTable.mj_footer endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:response.info];
        return;
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_fansList) {
        return 0;
    }
    if ([_fansList count] == 0) {
        return 1;
    }
    return [_fansList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_fansList count] == 0) {
        return 290.0;
    }
    return 68.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_fansList count] == 0) {
        return 0.001;
    }
    return 32.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_fansList count] == 0) {
        return nil;
    }
    switch (_fansType) {
        case 1:
        {
            if (!_firstHeaderView) {
                _firstHeaderView = [[ZXFansHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 32.0)];
            }
            [_firstHeaderView setDelegate:self];
            return _firstHeaderView;
        }
            break;
        case 2:
        {
            if (!_secHeaderView) {
                _secHeaderView = [[ZXFansSecHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 32.0)];
            }
            __weak typeof(self) weakSelf = self;
            _secHeaderView.zxFansSecHeaderViewBtnClick = ^(NSInteger btnTag) {
                switch (btnTag) {
                    case 0:
                    {
                        weakSelf.order = @"1";
                        [weakSelf.secHeaderView.lastBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
                        [weakSelf.secHeaderView.lastBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightBold]];
                        [weakSelf.secHeaderView.fansBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                        [weakSelf.secHeaderView.fansBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
                    }
                        break;
                    case 1:
                    {
                        weakSelf.order = @"3";
                        [weakSelf.secHeaderView.lastBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
                        [weakSelf.secHeaderView.lastBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
                        [weakSelf.secHeaderView.fansBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
                        [weakSelf.secHeaderView.fansBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightBold]];
                    }
                        break;
                        
                    default:
                        break;
                }
                [ZXProgressHUD loadingNoMask];
                [weakSelf refreshFanList];
            };
            return _secHeaderView;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_fansList count] == 0) {
        static NSString *identifier = @"ZXNoFansCell";
        ZXNoFansCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXNoFansCell class]) bundle:[NSBundle mainBundle]];
            [tableView registerNib:nib forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setDelegate:self];
        return cell;
    }
    ZXFans *fans = (ZXFans *)[_fansList objectAtIndex:indexPath.row];
    switch (_fansType) {
        case 1:
        {
            static NSString *identifier = @"ZXFansFirstCell";
            ZXFansFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setFans:fans];
            return cell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"ZXFansSecondCell";
            ZXFansSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setFans:fans];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fansType == 1) {
        if (self.zxFansViewNCellSelected) {
            ZXFans *fans = (ZXFans *)[_fansList objectAtIndex:indexPath.row];
            self.zxFansViewNCellSelected(fans);
        }
    }
}

#pragma mark - ZXNoFansCellDelegate

- (void)noFansCellHandleTapInviteBtnAction {
    if (self.zxFansViewNoFansCellBtnClick) {
        self.zxFansViewNoFansCellBtnClick();
    }
}

#pragma mark - ZXFansHeaderViewDelegate

- (void)fansHeaderViewHandleTapBtnActionWithTag:(NSInteger)btnTag {
    switch (btnTag) {
        case 0:
        {
            _order = @"1";
            [_firstHeaderView.lastBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
            [_firstHeaderView.fansBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            _order = @"3";
            [_firstHeaderView.lastBtn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [_firstHeaderView.fansBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [ZXProgressHUD loadingNoMask];
    [self refreshFanList];
}

@end
