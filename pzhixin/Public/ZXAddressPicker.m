//
//  ZXAddressPicker.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressPicker.h"
#import <Masonry/Masonry.h>
#import "ZXAddressChildVC.h"

@interface ZXAddressPicker () <TYTabPagerBarDelegate, TYTabPagerControllerDelegate,TYTabPagerControllerDataSource>

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) NSMutableArray *proList;

@property (strong, nonatomic) NSMutableArray *cityList;

@property (strong, nonatomic) NSMutableArray *areaList;

@property (strong, nonatomic) NSMutableArray *streetList;

@end

@implementation ZXAddressPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    //从本地json读取数据
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"tpcs" ofType:@"json"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:imagePath encoding:NSUTF8StringEncoding error:nil];
    NSData * resData = [[NSData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    _proList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArr count]; i++) {
        ZXPcasJson *pcasJson = [ZXPcasJson yy_modelWithJSON:[resultArr objectAtIndex:i]];
        [_proList addObject:pcasJson];
    }
    _titleList = [[NSMutableArray alloc] initWithObjects:_proPcasJosn ? _proPcasJosn.n : @"请选择省/地区", _cityPcasJosn ? _cityPcasJosn.n : @"请选择城市", _areaPcasJosn ? _areaPcasJosn.n : @"请选择区/县", _streetPcasJosn ? _streetPcasJosn.n : @"请选择街道", nil];
    NSInteger selectIndex = 0;
    if (![UtilsMacro whetherIsEmptyWithObject:_proPcasJosn]) {
        selectIndex = 1;
        _cityList = [[NSMutableArray alloc] initWithArray:_proPcasJosn.c];
    }
    
    if ([UtilsMacro whetherIsEmptyWithObject:_cityPcasJosn]) {
        [_titleList removeObject:@"请选择城市"];
        [_titleList removeObject:@"请选择区/县"];
        [_titleList removeObject:@"请选择街道"];
    } else {
        selectIndex = 2;
        _areaList = [[NSMutableArray alloc] initWithArray:_cityPcasJosn.c];
        if (_cityPcasJosn.t == 4) {
            if ([UtilsMacro whetherIsEmptyWithObject:_streetPcasJosn]) {
                [_titleList removeObject:@"请选择街道"];
            } else {
                [_titleList removeObject:@"请选择区/县"];
                _streetList = [[NSMutableArray alloc] initWithArray:_cityPcasJosn.c];
            }
        } else {
            if ([UtilsMacro whetherIsEmptyWithObject:_areaPcasJosn]) {
                [_titleList removeObject:@"请选择街道"];
            } else {
                if ([_areaPcasJosn.c count] > 0) {
                    selectIndex = 3;
                    _streetList = [[NSMutableArray alloc] initWithArray:_areaPcasJosn.c];
                }
            }
            
            if ([UtilsMacro whetherIsEmptyWithObject:_streetPcasJosn]) {
                [_titleList removeObject:@"请选择街道"];
            }
        }
    }
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self createHeaderViewAndSubviews];
    [self configurationTYTabBar];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToControllerAtIndex:selectIndex animate:YES];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tabBar setFrame:CGRectMake(0.0, 200.0, SCREENWIDTH, 40.0)];
    self.pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(self.tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(self.tabBar.frame));
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

- (void)createHeaderViewAndSubviews {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewAction)];
        [_bgView addGestureRecognizer:tapView];
        [_bgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
        [self.view addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.0);
            make.height.mas_equalTo(160.0);
        }];
    }
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40.0);
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(160.0);
        }];
    }
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]];
        [_titleLab setText:@"请选择区域"];
        [_titleLab setTextColor:HOME_TITLE_COLOR];
        [_headerView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(0.0).priorityLow();
            make.left.mas_equalTo(20.0);
        }];
    }
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_cancelBtn setImage:[UIImage imageNamed:@"ic_my_close"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(handleTapCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20.0);
            make.top.bottom.mas_equalTo(0.0);
            make.width.mas_equalTo(50.0);
        }];
    }
}

- (void)configurationTYTabBar {
    [self.pagerController.view setBackgroundColor:[UIColor whiteColor]];
    self.tabBarHeight = 40.0;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.layout.progressColor = THEME_COLOR;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15.0];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15.0];
    self.tabBar.layout.normalTextColor = HOME_TITLE_COLOR;
    self.tabBar.layout.cellWidth = 0.0;
    self.tabBar.layout.cellSpacing = 10.0;
    self.tabBar.layout.selectedTextColor = THEME_COLOR;
    self.tabBar.delegate = self;
    self.tabBar.clipsToBounds = YES;
    self.tabBar.collectionView.clipsToBounds = NO;
    self.tabBar.layout.sectionInset = UIEdgeInsetsMake(0.0, 18.0, 0.0, 0.0);
    self.dataSource = self;
    self.delegate = self;
    self.layout.prefetchItemCount = 1;
    self.layout.prefetchItemWillAddToSuperView = YES;
    [self.layout.scrollView setBounces:NO];
    [self reloadData];
}

- (void)handleTapViewAction {
    [self.bgView setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TYTabPagerBarDelegate

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self scrollToControllerAtIndex:index animate:YES];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return [_titleList count];
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return [_titleList count];
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ZXAddressChildVC *childVC = [[ZXAddressChildVC alloc] init];
    switch (index) {
        case 0:
        {
            [childVC setItemList:_proList];
            if (![UtilsMacro whetherIsEmptyWithObject:_proPcasJosn]) {
                [childVC setPcasJson:_proPcasJosn];
            }
            childVC.zxAddressChildVCDidSelect = ^(ZXPcasJson * _Nonnull pcasJson) {
                self.proPcasJosn = pcasJson;
                self.cityList = [[NSMutableArray alloc] initWithArray:pcasJson.c];
                self.titleList = [[NSMutableArray alloc] initWithObjects:self.proPcasJosn.n, @"请选择城市", nil];
                [self reloadData];
                [self scrollToControllerAtIndex:1 animate:YES];
                
            };
        }
            break;
        case 1:
        {
            [childVC setItemList:_cityList];
            if (![UtilsMacro whetherIsEmptyWithObject:_cityPcasJosn]) {
                [childVC setPcasJson:_cityPcasJosn];
            }
            childVC.zxAddressChildVCDidSelect = ^(ZXPcasJson * _Nonnull pcasJson) {
                self.cityPcasJosn = pcasJson;
                if (self.cityPcasJosn.t == 4) {
                    self.streetList = [[NSMutableArray alloc] initWithArray:pcasJson.c];
                    self.titleList = [[NSMutableArray alloc] initWithObjects:self.proPcasJosn.n, self.cityPcasJosn.n, @"请选择街道", nil];
                } else {
                    self.areaList = [[NSMutableArray alloc] initWithArray:pcasJson.c];
                    self.titleList = [[NSMutableArray alloc] initWithObjects:self.proPcasJosn.n, self.cityPcasJosn.n, @"请选择区/县", nil];
                }
                [self reloadData];
                [self scrollToControllerAtIndex:2 animate:YES];
            };
        }
            break;
        case 2:
        {
            if (_cityPcasJosn.t == 4) {
                [childVC setItemList:_streetList];
                if (![UtilsMacro whetherIsEmptyWithObject:_streetPcasJosn]) {
                    [childVC setPcasJson:_streetPcasJosn];
                }
            } else {
                [childVC setItemList:_areaList];
                if (![UtilsMacro whetherIsEmptyWithObject:_areaPcasJosn]) {
                    [childVC setPcasJson:_areaPcasJosn];
                }
            }
            childVC.zxAddressChildVCDidSelect = ^(ZXPcasJson * _Nonnull pcasJson) {
                self.areaPcasJosn = pcasJson;
                self.streetList = [[NSMutableArray alloc] initWithArray:pcasJson.c];
                if ([self.streetList count] <= 0) {
                    self.titleList = [[NSMutableArray alloc] initWithObjects:self.proPcasJosn.n, self.cityPcasJosn.n, self.areaPcasJosn.n, nil];
                    [self reloadData];
                    [self scrollToControllerAtIndex:2 animate:YES];
                    if (self.zxAddressPickerResult) {
                        self.zxAddressPickerResult(self.proPcasJosn, self.cityPcasJosn, self.areaPcasJosn, nil);
                        [self.bgView setBackgroundColor:[UIColor clearColor]];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                } else {
                    self.titleList = [[NSMutableArray alloc] initWithObjects:self.proPcasJosn.n, self.cityPcasJosn.n, self.areaPcasJosn.n, @"请选择街道", nil];
                    [self reloadData];
                    [self scrollToControllerAtIndex:3 animate:YES];
                }
            };
        }
            break;
        case 3:
        {
            [childVC setItemList:_streetList];
            if (![UtilsMacro whetherIsEmptyWithObject:_streetPcasJosn]) {
                [childVC setPcasJson:_streetPcasJosn];
            }
            childVC.zxAddressChildVCDidSelect = ^(ZXPcasJson * _Nonnull pcasJson) {
                self.streetPcasJosn = pcasJson;
                self.titleList = [[NSMutableArray alloc] initWithObjects:self.proPcasJosn.n, self.cityPcasJosn.n, self.areaPcasJosn.n, self.streetPcasJosn.n, nil];
                [self reloadData];
                [self scrollToControllerAtIndex:3 animate:YES];
                if (self.zxAddressPickerResult) {
                    self.zxAddressPickerResult(self.proPcasJosn, self.cityPcasJosn, self.areaPcasJosn, self.streetPcasJosn);
                    [self.bgView setBackgroundColor:[UIColor clearColor]];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            };
        }
            break;
            
        default:
            break;
    }
    return childVC;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    return [_titleList objectAtIndex:index];
}

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

#pragma mark - Button Method

- (IBAction)handleTapCancelBtnAction:(id)sender {
    [self.bgView setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
