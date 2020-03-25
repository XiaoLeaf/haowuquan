//
//  ZXInviteVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/20.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXInviteVC.h"
#import <Masonry/Masonry.h>
#import "ZXPosterView.h"
#import "ZXNewFansVC.h"
#import "ZXNotice.h"

#define DISTANCE 20.0
#define SCALE 250.0 / 375.0
#define RATE 1.55

#define WIDTH 1080
#define HEIGHT 1674

@interface ZXInviteConfigBgRes : NSObject

@property (strong, nonatomic) NSString *resId;

@property (strong, nonatomic) NSString *img;

@end

@implementation ZXInviteConfigBgRes

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将resId映射到key为id的数据字段
    return @{@"resId":@"id"};
}

@end

@interface ZXInviteConfig : NSObject

@property (strong, nonatomic) NSArray *bg;

@property (strong, nonatomic) NSArray *bgRes;

@property (strong, nonatomic) NSMutableArray *bgImg;

@property (strong, nonatomic) NSString *icode;

@property (strong, nonatomic) NSString *icode_text;

@property (strong, nonatomic) NSString *qrcode_text;

@property (strong, nonatomic) NSString *invite_text;

@property (strong, nonatomic) NSString *f_num;

@property (strong, nonatomic) NSString *s_num;

@property (strong, nonatomic) NSString *total_num;

@property (strong, nonatomic) NSString *txt;

@end

@implementation ZXInviteConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return [NSDictionary dictionaryWithObjectsAndKeys:[ZXInviteConfigBgRes class], @"bgRes",  nil];
}

@end

@interface ZXInviteVC () <iCarouselDelegate, iCarouselDataSource, ZXWeChatUtilsDelegate> {
    iCarousel *inviteCarousel;
    NSMutableArray *imageList;
}

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBottom;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;

@property (strong, nonatomic) ZXInviteConfig *inviteConfig;

@property (strong, nonatomic) NSMutableArray *resultImgList;

@property (strong,  nonatomic) NSMutableDictionary *resultimgDict;

@property (strong, nonatomic) UIImage *qrCode;

@property (strong, nonatomic) ZXCommonNotice *notice;

@end

@implementation ZXInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:BG_COLOR];
    [self setTitle:@"邀请" font:TITLE_FONT color:HOME_TITLE_COLOR];
    [self createInviteCarousel];
    
    [self.wechatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.wechatBtn.imageView.frame.size.width, -self.wechatBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.wechatBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.wechatBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.wechatBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.circleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.circleBtn.imageView.frame.size.width, -self.circleBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.circleBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.circleBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.circleBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.albumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.albumBtn.imageView.frame.size.width, -self.albumBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.albumBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.albumBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.albumBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.pwdBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.pwdBtn.imageView.frame.size.width, -self.pwdBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.pwdBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.pwdBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.pwdBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.codeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.codeBtn.imageView.frame.size.width, -self.codeBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.codeBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.codeBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.codeBtn.titleLabel.intrinsicContentSize.width)];
    [self fetchInviteConfiguration];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_COLOR];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [ZXProgressHUD hideAllHUD];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [inviteCarousel setNeedsLayout];
    [inviteCarousel layoutIfNeeded];
    [inviteCarousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom - 210.0);
        } else {
            make.bottom.mas_equalTo(-210.0);
        }
    }];
    if (@available(iOS 11.0, *)) {
        self.shareHeight.constant = 100.0 + self.view.safeAreaInsets.bottom;
        self.shareBottom.constant = self.view.safeAreaInsets.bottom;
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

#pragma mark - Private Methods

- (void)fetchInviteConfiguration {
    if ([UtilsMacro isCanReachableNetWork]) {
        [ZXProgressHUD loadingNoMask];
        [[ZXInviteConfigHelper sharedInstance] fetchInviteConfigCompletion:^(ZXResponse * _Nonnull response) {
            self.notice = [ZXCommonNotice yy_modelWithJSON:[response.data valueForKey:@"notice"]];
            if (![UtilsMacro whetherIsEmptyWithObject:self.notice.txt]) {
                [self setRightBtnTitle:self.notice.txt target:self action:@selector(handleTapRightBtnAction)];
            } else {
                [self setRightBtnTitle:nil target:nil action:nil];
            }
            NSLog(@"response====>%@",response.data);
            self.inviteConfig = [ZXInviteConfig yy_modelWithJSON:response.data];
            self.inviteConfig.bgImg = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.inviteConfig.bgRes.count; i++) {
                ZXInviteConfigBgRes *bgRes = (ZXInviteConfigBgRes *)[self.inviteConfig.bgRes objectAtIndex:i];
                [self.inviteConfig.bgImg addObject:bgRes.img];
            }
            self.resultImgList = [[NSMutableArray alloc] init];
            self.resultimgDict = [[NSMutableDictionary alloc] init];
            [self->inviteCarousel reloadData];
            
            if (![UtilsMacro whetherIsEmptyWithObject:self.inviteConfig.txt]) {
                [self.tipLab setText:self.inviteConfig.txt];
            }
            [self.fansBtn setTitle:[NSString stringWithFormat:@"已成功邀请%@人", self.inviteConfig.f_num] forState:UIControlStateNormal];
        } error:^(ZXResponse * _Nonnull response) {
            [ZXProgressHUD loadFailedWithMsg:response.info];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }];
    } else {
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)createInviteCarousel {
    if (!inviteCarousel) {
        inviteCarousel = [[iCarousel alloc] init];
        [inviteCarousel setType:iCarouselTypeCustom];
        [inviteCarousel setDelegate:self];
        [inviteCarousel setDataSource:self];
        [inviteCarousel setPagingEnabled:YES];
        [inviteCarousel setCurrentItemIndex:1];
        [inviteCarousel setClipsToBounds:YES];
        [self.view addSubview:inviteCarousel];
    }
}

- (UIImage *)createPosterImageWithIndex:(NSInteger)index {
    CGFloat codeWith = 320.0;
    UIImage *bgImg = [_inviteConfig.bgImg objectAtIndex:index];
    if (!_qrCode) {
        _qrCode = [UtilsMacro qrCodeImgWithContent:_inviteConfig.qrcode_text size:CGSizeMake(codeWith, codeWith)];
    }
    NSDictionary *attributed = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:34.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    CGFloat inviteHeight = 60.0;
    CGRect inviteRect = [UtilsMacro widthForString2:_inviteConfig.icode_text font:[UIFont systemFontOfSize:34.0] andHeight:60.0];
    CGFloat inviteWidth = inviteRect.size.width;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, HEIGHT), YES, [UIScreen mainScreen].scale);
    [bgImg drawInRect:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
    CGRect qrCodeRect = CGRectMake(WIDTH/2.0 - codeWith/2.0, HEIGHT - codeWith - 184.0, codeWith, codeWith);
    [_qrCode drawInRect:qrCodeRect];
    
    CGFloat centerX = CGRectGetMidX(qrCodeRect);
    [_inviteConfig.icode_text drawAtPoint:CGPointMake(centerX - inviteWidth/2.0, HEIGHT - codeWith - 224.0 - inviteHeight + (inviteHeight - inviteRect.size.height)/2.0) withAttributes:attributed];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
//    NSLog(@"resultImg:%@",resultImg);
    [_resultImgList addObject:resultImg];
    ZXInviteConfigBgRes *bgRes = (ZXInviteConfigBgRes *)[_inviteConfig.bgRes objectAtIndex:index];
    [_resultimgDict addEntriesFromDictionary:@{bgRes.img: resultImg}];
    if ([_resultImgList count] == [_inviteConfig.bgImg count]) {
        [ZXProgressHUD hideAllHUD];
    }
    UIGraphicsEndImageContext();
    return resultImg;
}

- (void)copyInviteText {
    [UtilsMacro generalPasteboardCopy:_inviteConfig.invite_text];
    [ZXProgressHUD loadSucceedWithMsg:@"复制注册口令成功"];
}

- (void)saveImageToAlbum {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum([self.resultimgDict valueForKey:[self.inviteConfig.bg objectAtIndex:self->inviteCarousel.currentItemIndex]], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    });
}

- (void)saveImage {
    if (@available(iOS 11.0, *)) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                UIAlertController *authStatus = [UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"您未开启保存图片的权限。请前往'设置'开启相册权限！" style:UIAlertControllerStyleAlert andAction:@[@"确认"] alertActionClicked:^(NSInteger actionTag) {
                    switch (actionTag) {
                        case 0:
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                            break;
                        case 1:
                        {

                        }
                            break;

                        default:
                            break;
                    }
                }];
                [self presentViewController:authStatus animated:YES completion:nil];
            } else {
                [self copyInviteText];
                [self saveImageToAlbum];
            }
        }];
    } else {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
            UIAlertController *authStatus = [UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"您未开启保存图片的权限。请前往'设置'开启相册权限！" style:UIAlertControllerStyleAlert andAction:@[@"确认"] alertActionClicked:^(NSInteger actionTag) {
                switch (actionTag) {
                    case 0:
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                        break;
                    case 1:
                    {

                    }
                        break;

                    default:
                        break;
                }
            }];
            [self presentViewController:authStatus animated:YES completion:nil];
        } else {
            [self copyInviteText];
            [self saveImageToAlbum];
        }
    }
}

- (void)systemShare {
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    [itemList addObject:[self.resultimgDict valueForKey:[self.inviteConfig.bg objectAtIndex:self->inviteCarousel.currentItemIndex]]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemList applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [ZXProgressHUD loadSucceedWithMsg:@"分享成功"];
            return;
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - iCarouselDelegate && iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
//    NSLog(@"_inviteConfig:%@",_inviteConfig);
    return [_inviteConfig.bgRes count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    ZXPosterView *posterView = [[ZXPosterView alloc] initWithFrame:CGRectMake(0.0, 40.0, (carousel.frame.size.height - 40.0)/RATE, carousel.frame.size.height - 40.0)];
    if ([[_inviteConfig.bgImg objectAtIndex:index] isKindOfClass:[NSString class]]) {
        ZXInviteConfigBgRes *bgRes = (ZXInviteConfigBgRes *)[self.inviteConfig.bgRes objectAtIndex:index];
        [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:bgRes.img] imageView:posterView.posterImg placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.inviteConfig.bgImg replaceObjectAtIndex:index withObject:image];
                    [self->inviteCarousel reloadItemAtIndex:index animated:NO];
                });
            }
        }];
    } else {
        [posterView.posterImg setImage:[self createPosterImageWithIndex:index]];
    }
    return posterView;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.865f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    } else {
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * inviteCarousel.itemWidth * 1.14, 0.0, 0.0);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
            break;
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
//            return value * (1.0 + 3.0 / 27.0);
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
            
        default:
            return value;
            break;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
}

#pragma mark - Button Method

- (IBAction)handleTapBottomBtnActions:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if ([_resultImgList count] < inviteCarousel.currentItemIndex) {
                return;
            }
            [self copyInviteText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (![WXApi isWXAppInstalled]) {
                    [self systemShare];
                } else {
                    [[ZXWeChatUtils sharedInstance] shareWithImage:[self.resultimgDict valueForKey:[self.inviteConfig.bg objectAtIndex:self->inviteCarousel.currentItemIndex]] text:nil scene:WXSceneSession delegate:self];
                }
            });
        }
            break;
        case 1:
        {
            if ([_resultImgList count] < inviteCarousel.currentItemIndex) {
                return;
            }
            [self copyInviteText];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (![WXApi isWXAppInstalled]) {
                    [self systemShare];
                } else {
                    [[ZXWeChatUtils sharedInstance] shareWithImage:[self.resultimgDict valueForKey:[self.inviteConfig.bg objectAtIndex:self->inviteCarousel.currentItemIndex]] text:nil scene:WXSceneTimeline delegate:self];
                }
            });
        }
            break;
        case 2:
        {
            if ([_resultImgList count] < inviteCarousel.currentItemIndex) {
                return;
            }
            if (@available(iOS 11.0, *)) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *authAlert = [UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"您未开启相册权限。请前往'设置'开启相册权限！" style:UIAlertControllerStyleAlert andAction:@[@"确认"] alertActionClicked:^(NSInteger actionTag) {
                                switch (actionTag) {
                                    case 0:
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        break;
                                        
                                    default:
                                        break;
                                }
                            }];
                            [self presentViewController:authAlert animated:YES completion:nil];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self copyInviteText];
                            [self saveImageToAlbum];
                        });
                    }
                }];
            } else {
                PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
                if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
                    UIAlertController *authAlert = [UtilsMacro zxAlertControllerWithTitle:@"温馨提示" andMessage:@"您未开启相册权限。请前往'设置'开启相册权限！" style:UIAlertControllerStyleAlert andAction:@[@"确认"] alertActionClicked:^(NSInteger actionTag) {
                        switch (actionTag) {
                            case 0:
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                break;
                                
                            default:
                                break;
                        }
                    }];
                    [self presentViewController:authAlert animated:YES completion:nil];
                } else {
                    [self copyInviteText];
                    [self saveImageToAlbum];
                }
            }
        }
            break;
        case 3:
        {
            [self copyInviteText];
        }
            break;
        case 4:
        {
            [UtilsMacro generalPasteboardCopy:_inviteConfig.icode];
            [ZXProgressHUD loadSucceedWithMsg:@"复制邀请码成功"];
        }
            break;
        case 5:
        {
            [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, FANS_VC] andUserInfo:nil viewController:self];
        }
            break;
            
        default:
            break;
    }
}

- (void)handleTapRightBtnAction {
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, _notice.url_schema] andUserInfo:nil viewController:self];
}

#pragma mark - Save Album Call Back

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
//        NSLog(@"error:%@",error);
        [ZXProgressHUD loadFailedWithMsg:@"保存失败"];
        return;
    }
    [ZXProgressHUD loadSucceedWithMsg:@"已保存至相册"];
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatShareSucceed {
    [ZXProgressHUD loadSucceedWithMsg:@"分享成功"];
    ZXInviteConfigBgRes *bgRes = (ZXInviteConfigBgRes *)[_inviteConfig.bgRes objectAtIndex:self->inviteCarousel.currentItemIndex];
    [[ZXSucceedShareHelper sharedInstance] fetchSucceedShareWithType:[NSString stringWithFormat:@"%d", INVITE_SHARE_TYPE] andRel_id:bgRes.resId andUrl:nil completion:^(ZXResponse * _Nonnull response) {
        
    } error:^(ZXResponse * _Nonnull response) {
        
    }];
}

@end
