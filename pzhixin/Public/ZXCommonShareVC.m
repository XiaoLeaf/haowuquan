//
//  ZXCommonShareVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/21.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXCommonShareVC.h"
#import "ZXCommonShareCell.h"
#import <Masonry/Masonry.h>

@interface ZXCommonShareVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZXWeChatUtilsDelegate>

@property (strong, nonatomic) UICollectionView *shareCollection;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) NSArray *itemList;

@property (strong, nonatomic) NSArray *titleList;

@property (strong, nonatomic) NSArray *imgList;

@property (assign, nonatomic) NSInteger saveIndex;

@end

@implementation ZXCommonShare

@end

@implementation ZXCommonShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor clearColor]];
    _itemList = @[@{@"title":@"微信", @"img":[UIImage imageNamed:@"ic_share_wchat.png"]}, @{@"title":@"朋友圈", @"img":[UIImage imageNamed:@"ic_share_circle.png"]}, @{@"title":@"批量保存图片", @"img":[UIImage imageNamed:@"ic_share_ablum.png"]}, @{@"title":@"复制文案", @"img":[UIImage imageNamed:@"ic_share_copy.png"]}];
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

#pragma mark - Setter

- (void)setCommonShare:(ZXCommonShare *)commonShare {
    _commonShare = commonShare;
}

- (void)setCommunity:(ZXCommunity *)community {
    _community = community;
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
    
//    if (!_cancelBtn) {
//        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:HOME_TITLE_COLOR forState:UIControlStateNormal];
//        [_cancelBtn setBackgroundColor:[UtilsMacro colorWithHexString:@"F1F1F1"]];
//        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//        [_cancelBtn addTarget:self action:@selector(handleTapCancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_cancelBtn.layer setCornerRadius:20.0];
//        [_containerView addSubview:_cancelBtn];
//        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.shareCollection.mas_bottom);
//            make.left.mas_equalTo(20.0);
//            make.right.mas_equalTo(-20.0);
//            make.height.mas_equalTo(40.0).priorityHigh();
//        }];
//    }
    
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

- (void)systemShare {
    [ZXProgressHUD loading];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    _imgList = [[NSArray alloc] initWithArray:_community.imgs];
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < _imgList.count; i++) {
        //从SDImageCache中取得URL对应的UIImage对象
        if ([[SDImageCache sharedImageCache] imageFromCacheForKey:[_imgList objectAtIndex:i]]) {
            [resultList addObject:[[SDImageCache sharedImageCache] imageFromCacheForKey:[_imgList objectAtIndex:i]]];
        } else {
            dispatch_group_enter(group);
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[self.imgList objectAtIndex:i]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (!error) {
                    [resultList addObject:image];
                }
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:resultList applicationActivities:nil];
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                [ZXProgressHUD loadSucceedWithMsg:@"分享成功"];
                [self dissmissCommonShareVC];
                if (self.zxCommShareVCShareSucceed) {
                    self.zxCommShareVCShareSucceed();
                }
                [[ZXSucceedShareHelper sharedInstance] fetchSucceedShareWithType:[NSString stringWithFormat:@"%d", COMMUNITY_SHARE_TYPE] andRel_id:self.community.community_id andUrl:nil completion:^(ZXResponse * _Nonnull response) {
                    
                } error:^(ZXResponse * _Nonnull response) {
                    
                }];
                return;
            }
        };
        [ZXProgressHUD hideAllHUD];
        [self presentViewController:activityVC animated:YES completion:nil];
    });
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
            [self systemShare];
        }
            break;
        case 1:
        {
            [self systemShare];
        }
            break;
        case 2:
        {
            _imgList = [[NSArray alloc] initWithArray:_community.imgs];
            _saveIndex = 0;
            [ZXProgressHUD loading];
            [self saveImage:_saveIndex];
        }
            break;
        case 3:
        {
            [UtilsMacro generalPasteboardCopy:_community.content];
            [ZXProgressHUD loadSucceedWithMsg:@"文案复制成功"];
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
    [ZXProgressHUD loadSucceedWithMsg:@"分享成功"];
    if (self.zxCommShareVCShareSucceed) {
        self.zxCommShareVCShareSucceed();
    }
    [[ZXSucceedShareHelper sharedInstance] fetchSucceedShareWithType:[NSString stringWithFormat:@"%d", COMMUNITY_SHARE_TYPE] andRel_id:_community.community_id andUrl:nil completion:^(ZXResponse * _Nonnull response) {
        
    } error:^(ZXResponse * _Nonnull response) {
        
    }];
}

#pragma mark - 批量保存图片到系统相册

- (void)saveImage:(NSInteger)index {
    //从SDImageCache中取得URL对应的UIImage对象
    if ([[SDImageCache sharedImageCache] imageFromCacheForKey:[_imgList objectAtIndex:index]]) {
        [self saveImgToAlbum:[[SDImageCache sharedImageCache] imageFromCacheForKey:[_imgList objectAtIndex:index]]];
    } else {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:index]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (!error) {
                [self saveImgToAlbum:image];
            }
        }];
    }
}

- (void)saveImgToAlbum:(UIImage *)img {
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [ZXProgressHUD loadFailedWithMsg:@"保存失败"];
        return;
    } else {
        if (_saveIndex != _imgList.count - 1) {
            _saveIndex++;
            [self saveImage:_saveIndex];
        } else {
            [ZXProgressHUD loadSucceedWithMsg:@"保存成功"];
            [self dissmissCommonShareVC];
        }
    }
}

@end
