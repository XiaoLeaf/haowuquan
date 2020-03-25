//
//  ZXCommunityNestVC.m
//  pzhixin
//
//  Created by zhixin on 2019/10/31.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommunityNestVC.h"
#import "ZXCommunityVC.h"
#import "ZXPagerMenuCell.h"

#define TABBAR_HEIGHT 40.0

@interface ZXCommunityNestVC () <TYTabPagerBarDelegate, TYTabPagerControllerDelegate,TYTabPagerControllerDataSource>

@property (assign, nonatomic) NSInteger selectIndex;

@property (assign, nonatomic) BOOL loaded;

@end

@implementation ZXCommunityNestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configurationTYTabBar];
    [self reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0.0, 0.0, SCREENWIDTH, TABBAR_HEIGHT);
    self.pagerController.view.frame = CGRectMake(0, TABBAR_HEIGHT, SCREENWIDTH, CGRectGetHeight(self.view.frame)- CGRectGetMaxY(self.tabBar.frame));
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

- (void)setCommunityCat:(ZXCommunityCat *)communityCat {
    _communityCat = communityCat;
}

- (void)setCid:(NSString *)cid {
    _cid = cid;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.cid) {
            for (int i = 0; i < self.communityCat.child.count; i++) {
                ZXCommunityCat *communityCat = (ZXCommunityCat *)[self.communityCat.child objectAtIndex:i];
                if ([communityCat.cid integerValue] == [self.cid integerValue]) {
                    self.selectIndex = i;
                    break;
                }
            }
            [self scrollToControllerAtIndex:self.selectIndex animate:NO];
            self.cid = nil;
        }
    });
}

- (void)setPagerViewSelectIndexWithId:(NSString *)subCid {
    if (subCid) {
        NSInteger index = 0;
        for (int i = 0; i < self.communityCat.child.count; i++) {
            ZXCommunityCat *communityCat = (ZXCommunityCat *)[self.communityCat.child objectAtIndex:i];
            if ([communityCat.cid integerValue] == [subCid integerValue]) {
                index = i;
                break;
            }
        }
        [self scrollToControllerAtIndex:index animate:NO];
        self.cid = nil;
    }
}

#pragma mark - Private Methods

- (void)configurationTYTabBar {
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.layout.barStyle = TYPagerBarStyleCoverView;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:13.0];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:14.0];
    self.tabBar.layout.normalTextColor = COLOR_666666;
    self.tabBar.layout.selectedTextColor = [UIColor whiteColor];
    self.tabBar.layout.progressColor = THEME_COLOR;
    [self.tabBar.layout setCellEdging:15.0];
    self.tabBar.layout.progressHorEdging = 5.0;
    self.tabBar.layout.progressVerEdging = 7.5;
    self.tabBar.layout.sectionInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
    [self.tabBar registerClass:[ZXPagerMenuCell class] forCellWithReuseIdentifier:@"ZXPagerMenuCell"];
    self.tabBar.delegate = self;
    self.dataSource = self;
    self.delegate = self;
    [self.layout.scrollView setBounces:NO];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return [_communityCat.child count];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ZXCommunityCat *subCat = (ZXCommunityCat *)[_communityCat.child objectAtIndex:index];
    ZXCommunityVC *community = [[ZXCommunityVC alloc] init];
    [community setCommunityCat:subCat];
    return community;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    ZXCommunityCat *subCat = (ZXCommunityCat *)[_communityCat.child objectAtIndex:index];
    return subCat.name;
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

@end
