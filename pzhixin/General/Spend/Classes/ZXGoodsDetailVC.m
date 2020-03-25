//
//  ZXGoodsDetailVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/2.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXGoodsDetailVC.h"
#import <Masonry/Masonry.h>
#import "ZXDetailCell_1.h"
#import "ZXDetailCell_2.h"
#import "ZXDetailRecCell.h"
#import "ZXDetailCell_3.h"
#import <MJRefresh/MJRefresh.h>
#import "ZXLoginViewController.h"
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <WebKit/WebKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import "ZXDetailHeaderView.h"
#import "ZXShareVC.h"

#define DISTANCE 10.0

@interface ZXGoodsDetailVC () <UITableViewDelegate, UITableViewDataSource, ZXDetailCell_2Delegate, ZXBannerViewDelegate, UIScrollViewDelegate, ZXDetailHeaderViewDelegate> {
    CGFloat alpha;
    
    //底部操作视图
    UIView *bottomView;
    UIButton *buyBtn;
    UIButton *shareBtn;
    UIView *leftView;
    UIButton *homeBtn;
    UIButton *favoriteBtn;
    
    //详情图片数组cell高度
    NSMutableArray *cellHeightList;
    NSMutableDictionary *cellHeightDict;
    
    UIView *titleView;
    UIButton *goodsBtn;
    UIButton *detailBtn;
    UIButton *recoBtn;
    UILabel *lineLab;
}

@property (strong, nonatomic) UITableView *detailTableView;

@property (strong, nonatomic) ZXDetailCell_2 *detailCell_2;

@property (strong, nonatomic) ZXDetailRecCell *detailRecCell;

@property (strong, nonatomic) ZXGoodsDetail *goodsDetail;

@property (strong, nonatomic) ZXCustomNavView *customNav;

@property (strong, nonatomic) ZXDetailHeaderView *detailHeaderView;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) ZXTBAuthView *tbAuthView;
@property (assign, nonatomic) NSInteger second;
@property (assign, nonatomic) BOOL isLoading;

@property (strong, nonatomic) ZXJumpTBView *jumpTBView;

@end

@implementation ZXGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createSubviews];
    alpha = 0.0;
    // Do any additional setup after loading the view from its nib.
    cellHeightList = [[NSMutableArray alloc] init];
    cellHeightDict = [[NSMutableDictionary alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_detailHeaderView.bannerView.player stop];
    if (![self.navigationController.topViewController isKindOfClass:[ZXShareVC class]]) {
        [ZXProgressHUD hideAllHUD];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIBarButton Actions

- (void)handleTapColoseBarButtonItemAction {
}

#pragma mark - Private Methods

- (void)createSubviews {
    __weak typeof(self) weakSelf = self;
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_detailTableView setBackgroundColor:BG_COLOR];
        [_detailTableView setDelegate:self];
        [_detailTableView setDataSource:self];
        [_detailTableView setShowsVerticalScrollIndicator:NO];
        [_detailTableView setShowsHorizontalScrollIndicator:NO];
        [_detailTableView setEstimatedRowHeight:0.0];
        [_detailTableView setEstimatedSectionHeaderHeight:0.0];
        [_detailTableView setEstimatedSectionFooterHeight:0.0];
        [_detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_detailTableView registerClass:[ZXDetailRecCell class] forCellReuseIdentifier:@"ZXDetailRecCell"];
        if (@available(iOS 11.0, *)) {
            _detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_detailTableView registerClass:[ZXDetailCell_3 class] forCellReuseIdentifier:@"ZXDetailCell_3"];
        _detailTableView.tabAnimated = [TABTableAnimated animatedWithCellClassArray:@[[ZXDetailCell_1 class],[ZXDetailCell_2 class]] cellHeightArray:@[@(SCREENWIDTH + 386.0), @(464.5)] animatedCountArray:@[@(1),@(1)]];
        _detailTableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(0).height(SCREENWIDTH);
            if (manager.tabTargetClass == [ZXDetailCell_1 class]) {
                manager.animation(6).right(5.0);
            }
        };
        [self.view addSubview:_detailTableView];
        [_detailTableView tab_startAnimation];
        [self refreshGoodsDetailInfo];
    }
    [_detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.left.mas_equalTo(0.0);
        make.right.mas_equalTo(0.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50.0);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(self.view).mas_offset(-50.0);
        }
    }];
    if (!_customNav) {
        _customNav = [[ZXCustomNavView alloc] initWithLeftContent:[UIImage imageNamed:@"ic_detail_back"] title:[self titleViewWithDetail:YES] titleColor:HOME_TITLE_COLOR rightContent:[UIImage imageNamed:@"ic_detail_nav_share_1"] leftDot:NO];
        _customNav.leftButtonClick = ^(UIButton * _Nonnull btn) {
            switch (btn.tag) {
                case 0:
                {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                    break;
                case 1:
                {
                    [weakSelf.customNav setLeftContent:[UIImage imageNamed:@"ic_detail_back"]];
                    [weakSelf.detailHeaderView.bannerView.cycleScroll setAutoScroll:YES];
                    weakSelf.detailHeaderView.bannerView.currentTime = [weakSelf.detailHeaderView.bannerView.player currentTime];
                    [weakSelf.detailHeaderView.bannerView.player stop];
                    [weakSelf.detailHeaderView.bannerView.playView setHidden:NO];
                    [weakSelf.detailHeaderView.bannerView.positionView setHidden:NO];
                    [weakSelf.detailHeaderView.bannerView.containerView setAlpha:0.0];
                    [weakSelf.detailHeaderView.bannerView setIsPlaying:NO];
                }
                    break;
                    
                default:
                    break;
            }
        };
        _customNav.rightButtonClick = ^(UIButton * _Nonnull btn) {
            if (![[ZXLoginHelper sharedInstance] loginState]) {
                [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:weakSelf];
                return;
            }
            if (![[ZXTBAuthHelper sharedInstance] tbAuthState]) {
                [UtilsMacro openTBAuthViewWithVC:weakSelf completion:^{}];
                return;
            }
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CREATE_SHARE_VC] andUserInfo:weakSelf.goodsDetail viewController:weakSelf];
        };
        [self.view addSubview:_customNav];
    }
}

- (ZXDetailHeaderView *)setupDetailTableViewHeaderView {
    ZXDetailHeaderView *headerView = [[ZXDetailHeaderView alloc] init];
    [headerView.bannerView setDelegate:self];
    [headerView setDelegate:self];
    headerView.backgroundColor = BG_COLOR;
    [headerView setGoodsDetail:_goodsDetail];
    _detailHeaderView = headerView;
    
//    [detailTableView beginUpdates];
    [_detailTableView setTableHeaderView:headerView];
//    [detailTableView endUpdates];
    
    //下面这部分很关键,重新布局获取最新的frame,然后赋值给myTableHeaderView
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = size.height;
    headerView.frame = headerFrame;
    
    _detailTableView.tableHeaderView = headerView;
    return _detailHeaderView;
}

- (UIView *)titleViewWithDetail:(BOOL)detail {
    if (!titleView) {
        if (detail) {
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 25.0)];
        } else {
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 25.0)];
        }
    }
    [titleView setBackgroundColor:[UIColor clearColor]];
    if (!goodsBtn) {
        goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goodsBtn setFrame:CGRectMake(0.0, 2.5, 50.0, 20.0)];
        [goodsBtn setTitle:@"商品" forState:UIControlStateNormal];
        [goodsBtn setTitleColor:[HOME_TITLE_COLOR colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
        [goodsBtn addTarget:self action:@selector(handleTapGoodsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [goodsBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [titleView addSubview:goodsBtn];
    }
    if (!recoBtn) {
        recoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [recoBtn setFrame:CGRectMake(50.0, 2.5, 50.0, 20.0)];
        [recoBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [recoBtn setTitleColor:[HOME_TITLE_COLOR colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
        [recoBtn addTarget:self action:@selector(handleTapRecoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [recoBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [titleView addSubview:recoBtn];
    }
    if (detail) {
        if (!detailBtn) {
            detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [detailBtn setFrame:CGRectMake(100.0, 2.5, 50.0, 20.0)];
            [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
            [detailBtn setTitleColor:[HOME_TITLE_COLOR colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
            [detailBtn addTarget:self action:@selector(handleTapDetailBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [detailBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [titleView addSubview:detailBtn];
        }
    }
    if (!lineLab) {
        lineLab = [[UILabel alloc] init];
        [lineLab setCenter:CGPointMake(goodsBtn.center.x, goodsBtn.center.y + 10.5)];
        [lineLab setFrame:CGRectMake(lineLab.center.x - 10.0, lineLab.center.y - 0.5, 20.0, 1.0)];
        [lineLab setBackgroundColor:[THEME_COLOR colorWithAlphaComponent:alpha]];
        [titleView addSubview:lineLab];
    }
    return titleView;
}

- (void)refreshGoodsDetailInfo {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        if (self.goods) {
            [self fetchGoodsDetailInfoWithId:self.goods.item_id andItem_id:self.goods.taobao_id];
        } else if (self.favorite) {
            [self fetchGoodsDetailInfoWithId:self.favorite.gid andItem_id:self.favorite.item_id];
        } else {
            [ZXProgressHUD loadFailedWithMsg:@"获取失败"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)fetchGoodsDetailInfoWithId:(NSString *)goodsId andItem_id:(NSString *)item_id {
    [[ZXGoodsDetailHelper sharedInstance] fetchGoodsDetailWithGoodsId:goodsId andItem_id:item_id completion:^(ZXResponse * _Nonnull response) {
        [self.detailTableView tab_endAnimation];
        [ZXProgressHUD hideAllHUD];
//        NSLog(@"response.data:%@",response.data);
        self.goodsDetail = [ZXGoodsDetail yy_modelWithDictionary:response.data];
        [self setupDetailTableViewHeaderView];
        [self.detailTableView reloadData];
        if ([[[self.goodsDetail row] content] count] > 0 && [[[[self.goodsDetail row] content] objectAtIndex:0] length] > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                for (int i = 0; i < [[[self.goodsDetail row] content] count]; i++) {
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[self.goodsDetail.row.content objectAtIndex:i]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        if (!image) {
                            return;
                        }
                        CGFloat imgHeight;
                        if (image.size.width < SCREENWIDTH) {
                            imgHeight = image.size.height;
                        } else {
                            imgHeight = image.size.height * SCREENWIDTH / image.size.width;
                        }
                        if (![[self->cellHeightDict allKeys] containsObject:[NSString stringWithFormat:@"%d",(int)i]] || [[self->cellHeightDict objectForKey:[NSString stringWithFormat:@"%d",(int)i]] floatValue] == 0.0) {
                            [self->cellHeightDict setObject:@(imgHeight) forKey:[NSString stringWithFormat:@"%d",(int)i]];
                        }
                    }];
                }
            });
        }
        
        self->bottomView = [[UIView alloc] init];
        [self.view addSubview:self->bottomView];
        [self->bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.mas_equalTo(self.view);
            }
            make.height.mas_equalTo(50.0);
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
        }];
        
        self->leftView = [[UIView alloc] init];
        [self->bottomView addSubview:self->leftView];
        [self->leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->bottomView);
            make.top.mas_equalTo(self->bottomView);
            make.bottom.mas_equalTo(self->bottomView);
            make.width.mas_equalTo(120.0);
        }];
        
        self->homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self->homeBtn setBackgroundColor:[UIColor whiteColor]];
        [self->homeBtn addTarget:self action:@selector(handleTapHomeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self->homeBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [self->homeBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [self->homeBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
        [self->homeBtn setImage:[UIImage imageNamed:@"tab_home_nor"] forState:UIControlStateNormal];
        [self->homeBtn setTitle:@"首页" forState:UIControlStateNormal];
        [self->homeBtn setAdjustsImageWhenHighlighted:NO];
        [self->leftView addSubview:self->homeBtn];
        
        self->favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self->favoriteBtn setBackgroundColor:[UIColor whiteColor]];
        [self->favoriteBtn addTarget:self action:@selector(handleTapFavoriteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self->favoriteBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        [self->favoriteBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [self->favoriteBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
        [self->favoriteBtn setImage:[UIImage imageNamed:@"ic_detail_favorite_nor"] forState:UIControlStateNormal];
        [self->favoriteBtn setImage:[UIImage imageNamed:@"ic_detail_favorite_selected"] forState:UIControlStateSelected];
        [self->favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self->favoriteBtn setAdjustsImageWhenHighlighted:NO];
        [self->leftView addSubview:self->favoriteBtn];
        
        if ([[[self.goodsDetail row] is_fav] integerValue] == 1) {
            [self->favoriteBtn setSelected:YES];
        } else {
            [self->favoriteBtn setSelected:NO];
        }
        
        NSMutableArray *btnList = [[NSMutableArray alloc] initWithObjects:self->homeBtn, self->favoriteBtn, nil];
        [btnList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.0 leadSpacing:0.0 tailSpacing:0.0];
        [btnList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.0);
            make.height.mas_equalTo(50.0);
        }];
        
        [self->homeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self->homeBtn.imageView.frame.size.width, -self->homeBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
        [self->homeBtn setImageEdgeInsets:UIEdgeInsetsMake(-self->homeBtn.titleLabel.intrinsicContentSize.height, 0.0, 0.0, -self->homeBtn.titleLabel.intrinsicContentSize.width)];
        
        [self->favoriteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self->favoriteBtn.imageView.frame.size.width, -self->favoriteBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
        [self->favoriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-self->favoriteBtn.titleLabel.intrinsicContentSize.height, 0.0, 0.0, -self->favoriteBtn.titleLabel.intrinsicContentSize.width)];
        
        UIView *rightView = [[UIView alloc] init];
        [self->bottomView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->leftView.mas_right);
            make.top.mas_equalTo(self->bottomView);
            make.bottom.mas_equalTo(self->bottomView);
            make.right.mas_equalTo(self->bottomView);
        }];
        
        CGFloat distance = (SCREENWIDTH - 120.0) * 0.1 / 3.0;
        
        self->buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self->buyBtn setBackgroundColor:THEME_COLOR];
        [self->buyBtn addTarget:self action:@selector(handleTapBuyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self->buyBtn setTitleColor:[UtilsMacro colorWithHexString:@"FDF1DA"] forState:UIControlStateNormal];
        [self->buyBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self->buyBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 5.0)];
        [self->buyBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        [self->buyBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        if (SCREENWIDTH > 320.0) {
            [self->buyBtn setImage:[UIImage imageNamed:@"ic_detail_vouchers"] forState:UIControlStateNormal];
        }
        [self->buyBtn.layer setCornerRadius:17.0];
        [self->buyBtn setAdjustsImageWhenHighlighted:NO];
        [rightView addSubview:self->buyBtn];
        [self->buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8.0);
            make.right.mas_equalTo(-distance);
            make.bottom.mas_equalTo(-8.0);
            make.width.mas_equalTo(rightView.mas_width).multipliedBy(0.50);
        }];
        
        self->shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self->shareBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"FF8400"]];
        [self->shareBtn addTarget:self action:@selector(handleTapShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self->shareBtn setTitleColor:[UtilsMacro colorWithHexString:@"FDF1DA"] forState:UIControlStateNormal];
        [self->shareBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self->shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 5.0)];
        [self->shareBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        [self->shareBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        if (SCREENWIDTH > 320.0) {
            [self->shareBtn setImage:[UIImage imageNamed:@"ic_detail_share"] forState:UIControlStateNormal];
        }
        [self->shareBtn.layer setCornerRadius:17.0];
        [self->shareBtn setAdjustsImageWhenHighlighted:NO];
        [rightView addSubview:self->shareBtn];
        [self->shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8.0);
            make.right.mas_equalTo(self->buyBtn.mas_left).mas_offset(-distance);
            make.bottom.mas_equalTo(-8.0);
            make.width.mas_equalTo(rightView.mas_width).multipliedBy(0.40);
        }];
        
        [self->buyBtn setTitle:[NSString stringWithFormat:@"省￥%@",[NSString stringWithFormat:@"%@", @([[[self.goodsDetail row] coupon_amount] floatValue] + [[[self.goodsDetail row] commission] floatValue])]] forState:UIControlStateNormal];
        [self->shareBtn setTitle:[NSString stringWithFormat:@"奖￥%@",[[self.goodsDetail row] commission]] forState:UIControlStateNormal];
    } error:^(ZXResponse * _Nonnull response) {
        [self.detailTableView tab_endAnimation];
        [ZXProgressHUD loadFailedWithMsg:response.info];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }];
}

- (void)fetchGoodsCoupon {
    if (![[ZXLoginHelper sharedInstance] loginState]) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _jumpTBView = [[ZXJumpTBView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSDictionary *awardInfo = @{@"coupon_amount":_goodsDetail.row.coupon_amount, @"commission":_goodsDetail.row.commission};
    [_jumpTBView setAwardInfo:awardInfo];
    _jumpTBView.zxJumpTBViewBtnClick = ^(NSInteger btnTag) {
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:weakSelf.jumpTBView.containerView endRemove:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.jumpTBView removeFromSuperview];
            weakSelf.jumpTBView = nil;
        });
        [[ZXNewService sharedManager] cancelCurrentRequest];
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:_jumpTBView];
    [UtilsMacro addBasicAnimationForViewWithFromValue:@0.0 andToValue:@1.0 andView:_jumpTBView.containerView endRemove:NO];
    
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXGoodsCouponHelper sharedInstance] fetchGoodsCouponWithId:_goodsDetail.row.itemId andItem_id:_goodsDetail.row.taobaoId completion:^(ZXResponse * _Nonnull response) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:self.jumpTBView.containerView endRemove:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.jumpTBView removeFromSuperview];
                    self.jumpTBView = nil;
                });
                if ([UtilsMacro whetherIsEmptyWithObject:[response.data valueForKey:@"coupon_click_url"]]) {
                    [ZXProgressHUD loadFailedWithMsg:@"暂无优惠券"];
                    return;
                }
                //    AlibcWebViewController *view = [[AlibcWebViewController alloc] init];
                AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
                showParam.openType = AlibcOpenTypeAuto;
                //8位数appkey
                //    showParam.backUrl = [NSString stringWithFormat:@"tbopen%@://", ALBC_APPKEY];
                showParam.isNeedPush = YES;
                showParam.nativeFailMode = AlibcNativeFailModeJumpDownloadPage;
                showParam.isNeedCustomNativeFailMode = YES;
                showParam.degradeUrl = @"https://mos.m.taobao.com/activity_newer";
                [[[AlibcTradeSDK sharedInstance] tradeService] openByUrl:[response.data valueForKey:@"coupon_click_url"] identity:@"trade" webView:nil parentController:self showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                    
                } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                }];
            });
        } error:^(ZXResponse * _Nonnull response) {
            if (response.status == 2) {
                [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.0 andView:self.jumpTBView.containerView endRemove:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.jumpTBView removeFromSuperview];
                    self.jumpTBView = nil;
                });
                [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
                return;
            }
            if (response.status == -999) {
                return;
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)fetchFavoriteGoodsWithItem_id:(NSString *)item_id {
    [[ZXFavoriteHelper sharedInstance] fetchGoodsFavoriteWithItem_id:item_id completion:^(ZXResponse * _Nonnull response) {
        [self->favoriteBtn setUserInteractionEnabled:YES];
        [self.detailHeaderView.favoriteBtn setUserInteractionEnabled:YES];
        [self.detailHeaderView.favoriteBtn.imageView.layer removeAnimationForKey:@"transform.scale"];
        [self->favoriteBtn.imageView.layer removeAnimationForKey:@"transform.scale"];
        [ZXProgressHUD hideAllHUD];
        if ([[response.data valueForKey:@"ret"] integerValue] == 1) {
            [self->favoriteBtn setSelected:YES];
            [self.detailHeaderView.favoriteBtn setSelected:YES];
        } else {
            [self->favoriteBtn setSelected:NO];
            [self.detailHeaderView.favoriteBtn setSelected:NO];
        }
    } error:^(ZXResponse * _Nonnull response) {
        [self->favoriteBtn setUserInteractionEnabled:YES];
        [self.detailHeaderView.favoriteBtn setUserInteractionEnabled:YES];
        [self.detailHeaderView.favoriteBtn.imageView.layer removeAnimationForKey:@"transform.scale"];
        [self->favoriteBtn.imageView.layer removeAnimationForKey:@"transform.scale"];
        [ZXProgressHUD loadFailedWithMsg:response.info];
        return;
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return [[_goodsDetail.row content] count];
    }
    if (section == 0) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return ((SCREENWIDTH - 40.0)/3.0 + 70.0) * 2.0 + 44.0 + 20.0;
    } else if (indexPath.section == 2) {
        if ([[cellHeightDict allKeys] containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
            if ([UtilsMacro whetherIsEmptyWithObject:[cellHeightDict objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]]]) {
                return 0.0;
            }
            return [[cellHeightDict objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]] floatValue];
        }
        return 0.0;
    } else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 44.0;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 44.0)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 43.5)];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setTextColor:COLOR_666666];
        [titleLab setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [titleLab setText:@"商品详情"];
        [headerView addSubview:titleLab];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 43.5, SCREENWIDTH, 0.5)];
        [lineView setBackgroundColor:[UtilsMacro colorWithHexString:@"ECECEA"]];
        [headerView addSubview:lineView];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 10.0)];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return nil;
        }
            break;
        case 1:
        {
//            static NSString *identifier = @"ZXDetailCell_2";
//            if (_detailCell_2 == nil) {
//                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXDetailCell_2 class]) bundle:[NSBundle mainBundle]];
//                [tableView registerNib:nib forCellReuseIdentifier:identifier];
//                _detailCell_2 = [tableView dequeueReusableCellWithIdentifier:identifier];
//                [_detailCell_2 setSelectionStyle:UITableViewCellSelectionStyleNone];
//                [_detailCell_2 setDelegate:self];
//                [_detailCell_2 setRecommendList:_goodsDetail.rel_goods];
//            }
//            return _detailCell_2;
            static NSString *identifier = @"ZXDetailRecCell";
            if (!_detailRecCell) {
                _detailRecCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                [_detailRecCell setRecommendList:_goodsDetail.rel_goods];
                [_detailRecCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            __weak typeof(self) weakSelf = self;
            _detailRecCell.zxDetailRecCellDidSelectCollectionViewCell = ^(NSIndexPath * _Nonnull indexPath, ZXGoods * _Nonnull goods) {
                ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
                [goodsDetail setGoods:goods];
                if (![UtilsMacro whetherIsEmptyWithObject:goods.pre_slide]) {
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:goods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        
                    }];
                }
                [weakSelf.navigationController pushViewController:goodsDetail animated:YES];
            };
            return _detailRecCell;
        }
            break;
        case 2:
        {
            static NSString *identifier = @"ZXDetailCell_3";
            ZXDetailCell_3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXDetailCell_3 class]) bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:identifier];
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[self.goodsDetail.row.content objectAtIndex:indexPath.row]] imageView:cell.imgView placeholderImage:[UtilsMacro small_placeHolder] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!image) {
                    return;
                }
                CGFloat imgHeight;
                if (image.size.width < SCREENWIDTH) {
                    imgHeight = image.size.height;
                    [cell.imgView setContentMode:UIViewContentModeCenter];
                } else {
                    [cell.imgView setContentMode:UIViewContentModeScaleAspectFit];
                    imgHeight = image.size.height * SCREENWIDTH / image.size.width;
                }
                if (![[self->cellHeightDict allKeys] containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]] || [[self->cellHeightDict objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]] floatValue] == 0.0) {
                    [self->cellHeightDict setObject:@(imgHeight) forKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
                    [self.detailTableView reloadData];
                }
            }];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:
        {
            [[ZXPhotoBrowser sharedInstance] showPhotoBrowserWithImgList:[[_goodsDetail row] content] currentIndex:indexPath.row andThumdList:@[]];
        }
            break;
            
        default:
            break;
    }
}

- (void)setImgaeUrlWithCell:(ZXDetailCell_3 *)cell andIndexPath:(NSIndexPath *)indexPath {
    [cell setImgUrl:[[[_goodsDetail row] content] objectAtIndex:indexPath.row]];
}

- (void)configurationCell:(ZXDetailCell_3 *)cell andIndexPath:(NSIndexPath *)indexPath {
    NSString *imgUrl = [[[_goodsDetail row] content] objectAtIndex:indexPath.row];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgUrl];
    if (!cacheImage) {
        [self downloadImage:imgUrl andIndexPath:indexPath];
    } else {
        [cell.imgView setImage:cacheImage];
    }
}

- (void)downloadImage:(NSString *)imgUrl andIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:imgUrl toDisk:YES completion:^{
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.detailTableView reloadData];
//                [self->detailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }];
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewContentOffset:%@",[NSValue valueWithCGPoint:scrollView.contentOffset]);
    //导航栏的颜色变化
    CGFloat offsetY = scrollView.contentOffset.y;
    alpha = offsetY / (NAVIGATION_HEIGHT + STATUS_HEIGHT);
    [goodsBtn setTitleColor:[HOME_TITLE_COLOR colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
    [recoBtn setTitleColor:[HOME_TITLE_COLOR colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
    [detailBtn setTitleColor:[HOME_TITLE_COLOR colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
    [lineLab setBackgroundColor:[THEME_COLOR colorWithAlphaComponent:alpha]];
    
    NSInteger position = 0;
    if (_detailTableView.contentOffset.y > ((386.0 + SCREENWIDTH)/2.0)) {
        if ([_detailTableView numberOfSections] > 2) {
            if (_detailTableView.contentOffset.y - STATUS_HEIGHT * 2 - NAVIGATION_HEIGHT * 2 > (((386.0 + SCREENWIDTH) + 464.5 + 20)/2.0)) {
                position = 2;
            } else {
                position = 1;
            }
        } else {
            position = 1;
        }
    } else {
        position = 0;
    }
    
    switch (position) {
        case 0:
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self->lineLab setCenter:CGPointMake(self->goodsBtn.center.x, self->goodsBtn.center.y + 10.5)];
                [self->lineLab setFrame:CGRectMake(self->lineLab.center.x - 10.0, self->lineLab.center.y - 0.5, 20.0, 1.0)];
            }];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self->lineLab setCenter:CGPointMake(self->recoBtn.center.x, self->recoBtn.center.y + 10.5)];
                [self->lineLab setFrame:CGRectMake(self->lineLab.center.x - 10.0, self->lineLab.center.y - 0.5, 20.0, 1.0)];
            }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self->lineLab setCenter:CGPointMake(self->detailBtn.center.x, self->detailBtn.center.y + 10.5)];
                [self->lineLab setFrame:CGRectMake(self->lineLab.center.x - 10.0, self->lineLab.center.y - 0.5, 20.0, 1.0)];
            }];
        }
            break;
            
        default:
            break;
    }
    
    if (alpha <= 0) {
        if (_detailHeaderView.bannerView.isPlaying) {
            [_customNav setLeftContent:@[[UIImage imageNamed:@"ic_detail_back"], [UIImage imageNamed:@"ic_detail_close"]]];
        } else {
            [_customNav setLeftContent:[UIImage imageNamed:@"ic_detail_back"]];
        }
        [_customNav setRightContent:[UIImage imageNamed:@"ic_detail_nav_share_1"]];
        _customNav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    } else if (alpha < 1) {
        if (_detailHeaderView.bannerView.isPlaying) {
            [_customNav setLeftContent:@[[UIImage imageNamed:@"ic_whole_back"], [UIImage imageNamed:@"ic_detail_shut"]]];
        } else {
            [_customNav setLeftContent:[UIImage imageNamed:@"ic_whole_back"]];
        }
        [_customNav setRightContent:[UIImage imageNamed:@"ic_detail_nav_share"]];
        _customNav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    } else {
        if (_detailHeaderView.bannerView.isPlaying) {
            [_customNav setLeftContent:@[[UIImage imageNamed:@"ic_whole_back"], [UIImage imageNamed:@"ic_detail_shut"]]];
        } else {
            [_customNav setLeftContent:[UIImage imageNamed:@"ic_whole_back"]];
        }
        [_customNav setRightContent:[UIImage imageNamed:@"ic_detail_nav_share"]];
        _customNav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    }
}

#pragma mark - ZXBannerViewDelegate

- (void)zxBannerView:(ZXBannerView *)bannerView withImgTag:(NSInteger)imgTag {
    [_detailHeaderView.bannerView.cycleScroll setAutoScroll:NO];
    ZXPhotoBrowser *zxPhotoBrowser =[ZXPhotoBrowser sharedInstance];
    zxPhotoBrowser.browserDismissBlock = ^{
        [self.detailHeaderView.bannerView.cycleScroll setAutoScroll:YES];
    };
    [zxPhotoBrowser showPhotoBrowserWithImgList:_goodsDetail.row.slides currentIndex:imgTag andThumdList:_goodsDetail.row.slides_thumb];
}

- (void)zxBannerViewPlayVideo {
    if (alpha <= 0) {
        [_customNav setLeftContent:@[[UIImage imageNamed:@"ic_detail_back"], [UIImage imageNamed:@"ic_detail_close"]]];
    } else if (alpha < 1) {
        [_customNav setLeftContent:@[[UIImage imageNamed:@"ic_whole_back"], [UIImage imageNamed:@"ic_detail_shut"]]];
    } else {
        [_customNav setLeftContent:@[[UIImage imageNamed:@"ic_whole_back"], [UIImage imageNamed:@"ic_detail_shut"]]];
    }
}

- (void)zxBannerViewScrollViewDidScroll:(UIScrollView *)scrollView {
    [self.customNav setLeftContent:[UIImage imageNamed:@"ic_detail_back"]];
}

- (void)zxBannerViewLeftSwipe {
    [self.customNav setLeftContent:[UIImage imageNamed:@"ic_detail_back"]];
}

- (void)zxBannerViewRightSwipe {
    [self.customNav setLeftContent:[UIImage imageNamed:@"ic_detail_back"]];
}

#pragma mark - ZXDetailCell_2Delegate

- (void)detailCell2CollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath andGoods:(ZXGoods *)goods {
    ZXGoodsDetailVC *goodsDetail = [[ZXGoodsDetailVC alloc] init];
    [goodsDetail setGoods:goods];
    if (![UtilsMacro whetherIsEmptyWithObject:goods.pre_slide]) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:goods.pre_slide] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
        }];
    }
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - ZXDetailHeaderViewDelegate

- (void)detailHeaderViewPlayerDidPlayToEnd {
    [self.customNav setLeftContent:[UIImage imageNamed:@"ic_detail_back"]];
    [_detailHeaderView.bannerView.player stop];
    [_detailHeaderView.bannerView.playView setHidden:NO];
    [_detailHeaderView.bannerView.positionView setHidden:NO];
}

- (void)detailHeaderViewHandleTapFavoriteBtnAction {
    if (![[ZXLoginHelper sharedInstance] loginState]) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [favoriteBtn setUserInteractionEnabled:NO];
        [_detailHeaderView.favoriteBtn setUserInteractionEnabled:NO];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.2 andView:_detailHeaderView.favoriteBtn.imageView endRemove:NO];
        if (favoriteBtn.isSelected) {
            [self fetchFavoriteGoodsWithItem_id:_goodsDetail.row.taobaoId];
        } else {
            [self fetchFavoriteGoodsWithItem_id:_goodsDetail.row.taobaoId];
        }
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)detailHeaderViewHandleTapFetchBtnAction {
    [self fetchGoodsCoupon];
}

- (void)detailHeaderViewHandleTapCheckPromoteBtnAction {
    if (![UtilsMacro whetherIsEmptyWithObject:_goodsDetail.row.up_arr.url_schema]) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, _goodsDetail.row.up_arr.url_schema] andUserInfo:nil viewController:self];
    }
}

#pragma mark - Button Actions

- (void)handleTapHomeBtnAction {
    if (self.goods) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    } else if (self.favorite) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

- (void)handleTapFavoriteBtnAction {
    if (![[ZXLoginHelper sharedInstance] loginState]) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
        return;
    }
    if ([UtilsMacro isCanReachableNetWork]) {
        [favoriteBtn setUserInteractionEnabled:NO];
        [_detailHeaderView.favoriteBtn setUserInteractionEnabled:NO];
        [UtilsMacro addBasicAnimationForViewWithFromValue:@1.0 andToValue:@0.2 andView:favoriteBtn.imageView endRemove:NO];
        if (favoriteBtn.isSelected) {
            [self fetchFavoriteGoodsWithItem_id:_goodsDetail.row.taobaoId];
        } else {
            [self fetchFavoriteGoodsWithItem_id:_goodsDetail.row.taobaoId];
        }
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)handleTapBuyBtnAction {
    [self fetchGoodsCoupon];
}

- (void)handleTapShareBtnAction {
    if (![[ZXLoginHelper sharedInstance] loginState]) {
        [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, LOGIN_VC] andUserInfo:nil viewController:self];
        return;
    }
    if (![[ZXTBAuthHelper sharedInstance] tbAuthState]) {
        [UtilsMacro openTBAuthViewWithVC:self completion:^{}];
        return;
    }
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, CREATE_SHARE_VC] andUserInfo:_goodsDetail viewController:self];
}

- (void)handleTapGoodsBtnAction {
    if (alpha < 1.0) {
        return;
    }
//    CGRect rect = [detailTableView rectForSection:0];
    [_detailTableView setContentOffset:CGPointMake(0.0, 0.0)];
    [UIView animateWithDuration:0.2 animations:^{
        [self->lineLab setCenter:CGPointMake(self->goodsBtn.center.x, self->goodsBtn.center.y + 10.5)];
        [self->lineLab setFrame:CGRectMake(self->lineLab.center.x - 10.0, self->lineLab.center.y - 0.5, 20.0, 1.0)];
    }];
}

- (void)handleTapRecoBtnAction {
    if (alpha < 1.0) {
        return;
    }
    CGRect rect = [_detailTableView rectForSection:1];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
    if ([[[_goodsDetail row] content] count] > 0 && [[[[_goodsDetail row] content] objectAtIndex:0] length] > 0) {
        [_detailTableView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y - NAVIGATION_HEIGHT - 52.0)];
    } else {
        [_detailTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self->lineLab setCenter:CGPointMake(self->recoBtn.center.x, self->recoBtn.center.y + 10.5)];
        [self->lineLab setFrame:CGRectMake(self->lineLab.center.x - 10.0, self->lineLab.center.y - 0.5, 20.0, 1.0)];
    }];
}

- (void)handleTapDetailBtnAction {
    if (alpha < 1.0) {
        return;
    }
    CGRect rect = [_detailTableView rectForSection:2];
    [_detailTableView setContentOffset:CGPointMake(0.0, rect.origin.y - NAVIGATION_HEIGHT - 52.0)];
    [UIView animateWithDuration:0.2 animations:^{
        [self->lineLab setCenter:CGPointMake(self->detailBtn.center.x, self->detailBtn.center.y + 10.5)];
        [self->lineLab setFrame:CGRectMake(self->lineLab.center.x - 10.0, self->lineLab.center.y - 0.5, 20.0, 1.0)];
    }];
}

@end
