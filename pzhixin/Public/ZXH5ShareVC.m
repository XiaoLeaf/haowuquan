//
//  ZXH5ShareVC.m
//  pzhixin
//
//  Created by zhixin on 2020/3/17.
//  Copyright © 2020 zhixin. All rights reserved.
//

#import "ZXH5ShareVC.h"
#import "ZXCommonShareCell.h"
#import <Masonry/Masonry.h>

@interface ZXH5ShareVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZXWeChatUtilsDelegate>

@property (strong, nonatomic) UICollectionView *shareCollection;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) NSArray *itemList;

@end

@implementation ZXH5ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor clearColor]];
    _itemList = @[@{@"title":@"微信", @"img":[UIImage imageNamed:@"ic_share_wchat.png"]}, @{@"title":@"朋友圈", @"img":[UIImage imageNamed:@"ic_share_circle.png"]}, @{@"title":@"复制链接", @"img":[UIImage imageNamed:@"ic_share_copy.png"]}, @{@"title":@"浏览器打开", @"img":[UIImage imageNamed:@"ic_invite_pwd.png"]}];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self creatContainerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_containerView setNeedsLayout];
    [_containerView layoutIfNeeded];
    [UtilsMacro addCornerRadiusForView:_containerView andRadius:10.0 andCornes:UIRectCornerTopLeft | UIRectCornerTopRight];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITapGestureRecognizer

- (void)dissmissCommonShareVC {
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)creatContainerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0.0);
        }];
    }
    
    if (!_shareCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _shareCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_shareCollection setShowsVerticalScrollIndicator:NO];
        [_shareCollection setShowsHorizontalScrollIndicator:NO];
        [_shareCollection setDelegate:self];
        [_shareCollection setDataSource:self];
        [_shareCollection setBackgroundColor:[UIColor whiteColor]];
        [_shareCollection registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCommonShareCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZXCommonShareCell"];
        [_containerView addSubview:_shareCollection];
        [_shareCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.0);
            make.top.mas_equalTo(20.0);
            make.height.mas_equalTo(SCREENWIDTH/4.0);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
            } else {
                make.bottom.mas_equalTo(0.0);
            }
        }];
    }
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissCommonShareVC)];
        [_bgView addGestureRecognizer:tapView];
        [self.view addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0.0);
            make.bottom.mas_equalTo(self.containerView.mas_top);
        }];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_itemList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH/4.0, SCREENWIDTH/4.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXCommonShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXCommonShareCell" forIndexPath:indexPath];
    [cell setItemInfo:[_itemList objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [[ZXWeChatUtils sharedInstance] shareWithTitle:_h5Share.title desc:_h5Share.desc image:_h5Share.img url:_h5Share.link scene:WXSceneSession delegate:self];
        }
            break;
        case 1:
        {
            [[ZXWeChatUtils sharedInstance] shareWithTitle:_h5Share.title desc:_h5Share.desc image:_h5Share.img url:_h5Share.link scene:WXSceneTimeline delegate:self];
        }
            break;
        case 2:
        {
            [UtilsMacro generalPasteboardCopy:_h5Share.link];
            [ZXProgressHUD loadSucceedWithMsg:@"复制成功"];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_h5Share.link] options:@{} completionHandler:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Method

- (void)handleTapCancelBtnAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatShareSucceed {
    if (self.zxH5ShareVCShareSucceed) {
        self.zxH5ShareVCShareSucceed();
    }
    [[ZXSucceedShareHelper sharedInstance] fetchSucceedShareWithType:[NSString stringWithFormat:@"%d", WEBVIEW_SHARE_TYPE] andRel_id:nil andUrl:_h5Share.link completion:^(ZXResponse * _Nonnull response) {

    } error:^(ZXResponse * _Nonnull response) {

    }];
}

@end
