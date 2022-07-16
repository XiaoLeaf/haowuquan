//
//  ZXCommunityHomeVC.m
//  pzhixin
//
//  Created by zhixin on 2019/7/11.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommunityHomeVC.h"
#import "ZXCommunityVC.h"
#import "ZXCommunityNestVC.h"

@interface ZXCommunityHomeVC () <TYTabPagerBarDelegate, TYTabPagerControllerDelegate,TYTabPagerControllerDataSource>

@property (strong, nonatomic) NSMutableArray *catList;

@property (assign, nonatomic) NSInteger selectIndex;

@property (assign, nonatomic) BOOL loaded;

@end

@implementation ZXCommunityHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self configurationTYTabBar];
    [ZXProgressHUD loading];
    [self fetchCommunityCats];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0.0, STATUS_HEIGHT, SCREENWIDTH, NAVIGATION_HEIGHT);
    self.pagerController.view.frame = CGRectMake(0, NAVIGATION_HEIGHT + STATUS_HEIGHT, SCREENWIDTH, CGRectGetHeight(self.view.frame)- CGRectGetMaxY(self.tabBar.frame));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Setter

- (void)setFid:(NSString *)fid {
    if (!_loaded) {
        _fid = fid;
    } else {
        for (int i = 0; i < [self.catList count]; i++) {
            ZXCommunityCat *subCat = (ZXCommunityCat *)[self.catList objectAtIndex:i];
            if ([subCat.cid integerValue] == [fid integerValue]) {
                self.selectIndex = i;
                break;
            }
        }
        [self scrollToControllerAtIndex:self.selectIndex animate:NO];
    }
}

- (void)setCid:(NSString *)cid {
    _cid = cid;
    UIViewController *tempVC = [self.pagerController controllerForIndex:self.selectIndex];
    if ([tempVC isKindOfClass:[ZXCommunityNestVC class]]) {
        ZXCommunityNestVC *nestVC = (ZXCommunityNestVC *)tempVC;
        [nestVC setPagerViewSelectIndexWithId:_cid];
    }
}

#pragma mark - Private Methods

- (void)configurationTYTabBar {
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    self.tabBar.layout.normalTextColor = COLOR_666666;
    self.tabBar.layout.selectedTextColor = HOME_TITLE_COLOR;
    [self.tabBar.layout setCellEdging:20.0];
    self.tabBar.layout.progressHorEdging = 20.0;
    self.tabBar.layout.progressVerEdging = 8.0;
    [self.tabBar.layout setAdjustContentCellsCenter:YES];
    [self.tabBar.layout setProgressColor:HOME_TITLE_COLOR];
    self.tabBar.delegate = self;
    self.dataSource = self;
    self.delegate = self;
    [self.layout.scrollView setBounces:NO];
}

- (void)fetchCommunityCats {
    [[ZXCommunityListHelper sharedInstance] fetchCommunityListWithPage:@"1" andFid:@"0" andCid:@"0" andKeyword:@"" completion:^(ZXResponse * _Nonnull response) {
//        NSLog(@"response====>%@",response.data);
        [ZXProgressHUD hideAllHUD];
        self.catList = [[NSMutableArray alloc] init];
        NSArray *cats = [response.data valueForKey:@"cats"];
        for (int i = 0; i < cats.count; i++) {
            ZXCommunityCat *communityCat = [ZXCommunityCat yy_modelWithJSON:[cats objectAtIndex:i]];
            [self.catList addObject:communityCat];
        }
        [self reloadData];
        self.loaded = YES;
        if (self.fid) {
            for (int i = 0; i < [self.catList count]; i++) {
                ZXCommunityCat *subCat = (ZXCommunityCat *)[self.catList objectAtIndex:i];
                if ([subCat.cid integerValue] == [self.fid integerValue]) {
                    self.selectIndex = i;
                    break;
                }
            }
            [self scrollToControllerAtIndex:self.selectIndex animate:NO];
        }
    } error:^(ZXResponse * _Nonnull response) {
        [ZXProgressHUD loadFailedWithMsg:response.info];
    }];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return [_catList count];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ZXCommunityCat *communityCat = (ZXCommunityCat *)[_catList objectAtIndex:index];
    if ([communityCat.type isEqualToString:@"2"]) {
        return nil;
    } else {
        if (communityCat.child.count <= 0) {
            ZXCommunityVC *community = [[ZXCommunityVC alloc] init];
            [community setCommunityCat:communityCat];
            return community;
        } else {
            ZXCommunityNestVC *communityNest = [[ZXCommunityNestVC alloc] init];
            if (_cid && [_fid integerValue] == [communityCat.cid integerValue]) {
                [communityNest setCid:_cid];
                _cid = nil;
                _fid =  nil;
            }
            [communityNest setCommunityCat:communityCat];
            return communityNest;
        }
    }
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    ZXCommunityCat *communityCat = (ZXCommunityCat *)[_catList objectAtIndex:index];
    return communityCat.name;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    ZXCommunityCat *communityCat = (ZXCommunityCat *)[_catList objectAtIndex:toIndex];
    if ([communityCat.type isEqualToString:@"2"]) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, communityCat.url_schema] andUserInfo:nil viewController:self];
        [self scrollToControllerAtIndex:fromIndex animate:NO];
    } else {
        [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    }
}

@end
