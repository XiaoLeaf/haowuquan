//
//  ZXCommunityVC.m
//  pzhixin
//
//  Created by zhixin on 2019/10/31.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommunityVC.h"
#import "ZXCommunityCell.h"
#import "ZXCommunityNewCell.h"
#import "ZXCommunityStoreCell.h"

@interface ZXCommunityVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *communityTable;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) ZXRefreshFooter *refreshFooter;

@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSString *keyword;

@property (strong, nonatomic) NSMutableArray *communityList;

@end

@implementation ZXCommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSearchTF];
    // Do any additional setup after loading the view from its nib.
    [self.communityTable setBackgroundColor:COLOR_F1F1F1];
    [self.communityTable setEstimatedRowHeight:300.0];
    [self.communityTable setRowHeight:UITableViewAutomaticDimension];
    [self.communityTable registerClass:[ZXCommunityCell class] forCellReuseIdentifier:@"ZXCommunityCell"];
    [self.communityTable registerClass:[ZXCommunityStoreCell class] forCellReuseIdentifier:@"ZXCommunityStoreCell"];
    [self.communityTable registerClass:[ZXCommunityNewCell class] forCellReuseIdentifier:@"ZXCommunityNewCell"];
    _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCommunityList)];
    [_refreshHeader setTimeKey:[NSString stringWithFormat:@"ZXCommunityVC%@",_communityCat.cid]];
//    [_refreshHeader.stateLab setTextColor:COLOR_999999];
    [self.communityTable setMj_header:_refreshHeader];
    _refreshFooter = [ZXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommunityList)];
    [_refreshHeader beginRefreshing];
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

- (void)configSearchTF {
    [_searchView setBackgroundColor:COLOR_F1F1F1];
    [_searchTF.layer setCornerRadius:5.0];
    [_searchTF setLeftViewMode:UITextFieldViewModeAlways];
    [_searchTF setDelegate:self];
    [_searchTF addTarget:self action:@selector(handleSearchTFEditChanged:) forControlEvents:UIControlEventEditingChanged];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 36.0, 26.0)];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 3.0, 12.0, 20.0)];
    [iconImg setImage:[UIImage imageNamed:@"icon_search"]];
    [iconImg setContentMode:UIViewContentModeScaleAspectFill];
    [leftView addSubview:iconImg];
    [_searchTF setLeftView:leftView];
}

- (void)handleSearchTFEditChanged:(UITextField *)textField {
    if ([UtilsMacro whetherIsEmptyWithObject:textField.text]) {
        _keyword = @"";
        [_searchTF resignFirstResponder];
        [_refreshHeader beginRefreshing];
    }
}

- (void)refreshCommunityList {
    _page = 1;
    [[ZXCommunityListHelper sharedInstance] fetchCommunityListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andFid:_communityCat.fid andCid:_communityCat.cid andKeyword:_keyword completion:^(ZXResponse * _Nonnull response) {
//        NSLog(@"response===>%@",response.data);
        if ([self.refreshHeader isRefreshing]) {
            [self.refreshHeader endRefreshing];
        }
        [ZXProgressHUD hideAllHUD];
        self.communityList = [[NSMutableArray alloc] init];
        NSArray *list = [response.data valueForKey:@"list"];
        for (int i = 0; i < list.count; i++) {
            ZXCommunity *community = [ZXCommunity yy_modelWithJSON:[list objectAtIndex:i]];
            [self.communityList addObject:community];
        }
        if (self.communityList.count > 0) {
            [self.communityTable setMj_footer:self.refreshFooter];
            if (self.communityList.count < [[response.data valueForKey:@"pagesize"] integerValue]) {
                [self.communityTable.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.refreshFooter resetNoMoreData];
            }
        } else {
            [self.communityTable setEmptyDataSetDelegate:self];
            [self.communityTable setEmptyDataSetSource:self];
        }
        [self.communityTable reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.refreshHeader isRefreshing]) {
            [self.refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:response.info];
    }];
}

- (void)loadMoreCommunityList {
    _page++;
    [[ZXCommunityListHelper sharedInstance] fetchCommunityListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andFid:_communityCat.fid andCid:_communityCat.cid andKeyword:_keyword completion:^(ZXResponse * _Nonnull response) {
        if ([self.refreshHeader isRefreshing]) {
            [self.refreshHeader endRefreshing];
        }
        [ZXProgressHUD hideAllHUD];
        NSMutableArray *resultList = [[NSMutableArray alloc] init];
        NSArray *list = [response.data valueForKey:@"list"];
        for (int i = 0; i < list.count; i++) {
            ZXCommunity *community = [ZXCommunity yy_modelWithJSON:[list objectAtIndex:i]];
            [resultList addObject:community];
        }
        [self.communityList addObjectsFromArray:resultList];
        [self.communityTable setMj_footer:self.refreshFooter];
        if (resultList.count < [[response.data valueForKey:@"pagesize"] integerValue]) {
            [self.communityTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.refreshFooter resetNoMoreData];
        }
        [self.communityTable reloadData];
    } error:^(ZXResponse * _Nonnull response) {
        if ([self.refreshHeader isRefreshing]) {
            [self.refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:response.info];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_communityList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXCommunityNewCell";
    ZXCommunityNewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXCommunity *community = (ZXCommunity *)[_communityList objectAtIndex:indexPath.row];
    [cell setCommunity:community];
    [cell setIndexPath:indexPath];
    cell.zxCommunitySingleImgComplete = ^(NSIndexPath * _Nonnull indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.communityTable beginUpdates];
            [self.communityTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.communityTable endUpdates];
        });
    };
    cell.zxCommunityNewCellCheckDetail = ^{
        if (![UtilsMacro whetherIsEmptyWithObject:community.detail.url_schema]) {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, community.detail.url_schema] andUserInfo:nil viewController:self];
        }
    };
    cell.zxCommunityNewCellClickGoods = ^{
        ZXGoods *goods = [[ZXGoods alloc] init];
        [goods setTaobao_id:community.grow.gid];
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, GOODS_DETAIL_VC] andUserInfo:goods viewController:self];
    };
    cell.zxCommunityNewCellCommentsCellClickCopy = ^(ZXCommunityComment * _Nonnull comment, NSInteger index) {
        if ([UtilsMacro whetherIsEmptyWithObject:comment.params]) {
            [UtilsMacro generalPasteboardCopy:comment.txt];
            [ZXProgressHUD loadSucceedWithMsg:@"文案复制成功"];
        } else {
            if (![[ZXLoginHelper sharedInstance] loginState]) {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
                return;
            }
            if (![[ZXTBAuthHelper sharedInstance] tbAuthState]) {
                [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
                return;
            }
            if ([comment.txt rangeOfString:comment.rstr].location == NSNotFound) {
                [UtilsMacro generalPasteboardCopy:comment.txt];
                [ZXProgressHUD loadSucceedWithMsg:@"文案复制成功"];
            } else {
                //请求接口，根据接口返回的结果复制文案
                [ZXProgressHUD loading];
                [[ZXGetWordHelper sharedInstance] fetchCommunityWordWithParams:comment.params completion:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD hideAllHUD];
                    [comment setTxt:[comment.txt stringByReplacingOccurrencesOfString:comment.rstr withString:[response.data valueForKey:@"word"]]];
                    [UtilsMacro generalPasteboardCopy:comment.txt];
                    [ZXProgressHUD loadSucceedWithMsg:@"文案复制成功"];
                } error:^(ZXResponse * _Nonnull response) {
                    [ZXProgressHUD loadFailedWithMsg:response.info];
                }];
            }
        }
    };
    cell.zxCommunityShareCommunityInfo = ^{
        [UtilsMacro generalPasteboardCopy:community.content];
        [ZXProgressHUD loadSucceedWithMsg:@"文案复制成功"];
        ZXCommonShareVC *shareVC = [[ZXCommonShareVC alloc] init];
        [shareVC setProvidesPresentationContextTransitionStyle:YES];
        [shareVC setDefinesPresentationContext:YES];
        [shareVC setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [shareVC setCommunity:community];
        shareVC.zxCommShareVCShareSucceed = ^{
            [community setShare_times:[NSString stringWithFormat:@"%ld",[community.share_times integerValue] + 1]];
            [self.communityTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [[[AppDelegate sharedInstance] homeTabBarController] presentViewController:shareVC animated:YES completion:nil];
    };
    return cell;
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"ic_general_absent"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyStr = @"还没有相关数据呢~";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName: COLOR_999999};
    return [[NSAttributedString alloc] initWithString:emptyStr attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -80.0;
}

#pragma makr - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchTF resignFirstResponder];
    _keyword = textField.text;
    if ([UtilsMacro whetherIsEmptyWithObject:_keyword]) {
        return YES;
    }
    [_refreshHeader beginRefreshing];
    return YES;
}

//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    [_searchTF resignFirstResponder];
//    _keyword = @"";
//    [_refreshHeader beginRefreshing];
//    return YES;
//}

@end
