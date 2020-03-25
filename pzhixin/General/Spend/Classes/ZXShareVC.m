//
//  ZXShareVC.m
//  pzhixin
//
//  Created by zhixin on 2019/9/17.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXShareVC.h"
#import "ZXShareCell.h"
#import "ZXShareImgCell.h"
#import "ZXGoodsDetailVC.h"

#define DISTANCE 20.0

#define WIDTH 640
#define HEIGHT 1080
#define IMG_WIDTH 560

@interface ZXShareVC () <UITableViewDelegate, UITableViewDataSource, ZXShareCellDelegate, ZXWeChatUtilsDelegate> {
    
}

@property (strong, nonatomic) ZXRefreshHeader *refreshHeader;

@property (strong, nonatomic) ZXShareCell *shareCell;

@property (strong, nonatomic) ZXGoodsShare *goodsShare;

@property (strong, nonatomic) NSMutableArray *pickStateList;

@property (strong, nonatomic) NSMutableArray *pickedImgList;

@property (strong, nonatomic) UIImage *logoImg;

@property (strong, nonatomic) UIImage *posterImg;

@property (assign, nonatomic) NSInteger currentSaveIndex;

@property (strong, nonatomic) NSMutableDictionary *shareImgList;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation ZXShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _refreshHeader = [ZXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchGoodsShareInfo)];
    [_refreshHeader.stateLab setTextColor:COLOR_999999];
    _shareTable.mj_header = _refreshHeader;
    [ZXProgressHUD loadingNoMask];
    _isLoading = YES;
    [self fetchGoodsShareInfo];
    
    [self.shareTable setEstimatedRowHeight:500.0];
    [self.shareTable setRowHeight:UITableViewAutomaticDimension];
    [self.shareTable registerClass:[ZXShareCell class] forCellReuseIdentifier:@"ZXShareCell"];
    
    [self setTitle:@"创建分享" font:TITLE_FONT color:HOME_TITLE_COLOR];
    
    [self.wechatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.wechatBtn.imageView.frame.size.width, -self.wechatBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.wechatBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.wechatBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.wechatBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.circleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.circleBtn.imageView.frame.size.width, -self.circleBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.circleBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.circleBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.circleBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.albumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.albumBtn.imageView.frame.size.width, -self.albumBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.albumBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.albumBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.albumBtn.titleLabel.intrinsicContentSize.width)];
    
    [self.cpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -self.cpBtn.imageView.frame.size.width, -self.cpBtn.imageView.frame.size.height - DISTANCE/2.0, 0.0)];
    [self.cpBtn setImageEdgeInsets:UIEdgeInsetsMake(-self.cpBtn.titleLabel.intrinsicContentSize.height - DISTANCE/2.0, -.0, 0.0, -self.cpBtn.titleLabel.intrinsicContentSize.width)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
//    [[ZXNewService sharedManager] cancelCurrentRequest];
    if (![self.navigationController.topViewController isKindOfClass:[ZXGoodsDetailVC class]]) {
        [ZXProgressHUD hideAllHUD];
        [[ZXNewService sharedManager] cancelCurrentRequest];
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

- (void)fetchGoodsShareInfo {
    __weak typeof(self) weakSelf = self;
    if ([UtilsMacro isCanReachableNetWork]) {
        [[ZXShareHelper sharedInstance] fetchSharelWithGoodsId:self.idStr andItem_id:self.item_id completion:^(ZXResponse * _Nonnull response) {
            if (weakSelf.refreshHeader.isRefreshing) {
                [weakSelf.refreshHeader endRefreshing];
            }
//            NSLog(@"response:%@",response.data);
            weakSelf.goodsShare = [ZXGoodsShare yy_modelWithJSON:response.data];
            weakSelf.shareImgList = [[NSMutableDictionary alloc] init];
            //初始化选择状态
            weakSelf.pickStateList = [[NSMutableArray alloc] init];
            weakSelf.pickedImgList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [weakSelf.goodsShare.slides_thumb count]; i++) {
                [weakSelf.pickStateList addObject:[NSNumber numberWithBool:NO]];
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[weakSelf.goodsShare.slides objectAtIndex:i]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (!image) {
                        return;
                    }
                    [weakSelf.shareImgList addEntriesFromDictionary:@{[weakSelf.goodsShare.slides objectAtIndex:i]: image}];
                }];
            }
            if (!weakSelf.shareTable.delegate) {
                [weakSelf.shareTable setDelegate:self];
            }
            if (!weakSelf.shareTable.dataSource) {
                [weakSelf.shareTable setDataSource:self];
            }
            [weakSelf.shareTable reloadData];
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:weakSelf.goodsShare.share_logo] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//                NSLog(@"image:%@",image);
                self.logoImg = image;
                [self createPosterImage];
                [self.shareTable reloadData];
            }];
        } error:^(ZXResponse * _Nonnull response) {
            if (weakSelf.refreshHeader.isRefreshing) {
                [weakSelf.refreshHeader endRefreshing];
            }
            if (response.status == 2) {
                [UtilsMacro openTBAuthViewWithVC:self completion:^{
                    [self.shareTable.mj_header beginRefreshing];
                }];
                return;
            }
            [ZXProgressHUD loadFailedWithMsg:response.info];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return;
        }];
    } else {
        if (_refreshHeader.isRefreshing) {
            [_refreshHeader endRefreshing];
        }
        [ZXProgressHUD loadFailedWithMsg:NETWORK_DISCONNECT];
        return;
    }
}

- (void)createPosterImage {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_goodsShare.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        CGFloat codeWith = 100.0;
        
        UIImage *qrCode = [UtilsMacro qrCodeImgWithContent:self.goodsShare.qrcode_url size:CGSizeMake(codeWith, codeWith)];
        
        UIImage *flagImg;
        if ([self.goodsShare.shop_type integerValue] == 1) {
            flagImg = [UIImage imageNamed:@"tmall_flag"];
        } else if ([self.goodsShare.shop_type integerValue] == 2) {
            flagImg = [UIImage imageNamed:@"taobao_flag"];
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH, HEIGHT), YES, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, WIDTH, HEIGHT));
//        [self.bgImg drawInRect:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
        
        CGRect flagRect = CGRectMake(40.0, 40.0, 50, 26.0);
        [flagImg drawInRect:flagRect];
        
        CGFloat titleHeight = [UtilsMacro heightForString:self.goodsShare.title font:[UIFont systemFontOfSize:28.0] andWidth:WIDTH - 200.0];
        if (titleHeight > 70.0) {
            titleHeight = 70.0;
        }
        CGRect titleRect = CGRectMake(flagRect.origin.x + flagRect.size.width + 12.0, flagRect.origin.y, WIDTH - 142.0, titleHeight);
        
        [self.goodsShare.title drawInRect:CGRectMake(flagRect.origin.x + flagRect.size.width + 12.0, flagRect.origin.y - 5.0, WIDTH - 142.0, titleHeight) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:28.0], NSForegroundColorAttributeName: HOME_TITLE_COLOR}];
        
        [[self curPriceLabForImgWithStr:self.goodsShare.price] drawAtPoint:CGPointMake(flagRect.origin.x, titleRect.origin.y + titleRect.size.height + 34.0)];
        [[self oriPriceStrWithStr:self.goodsShare.ori_price] drawAtPoint:CGPointMake(flagRect.origin.x, titleRect.origin.y + titleRect.size.height + 90.0)];
        
        [image drawInRect:CGRectMake(WIDTH/2.0 - IMG_WIDTH/2.0, titleRect.origin.y + titleRect.size.height + 130.0, IMG_WIDTH, IMG_WIDTH)];
        
        if (self.goodsShare.ori_price.floatValue - self.goodsShare.price.floatValue > 0) {
            NSString *str = [NSString stringWithFormat:@"券 %.2f",self.goodsShare.ori_price.floatValue - self.goodsShare.price.floatValue];
            CGFloat couponWidth = [UtilsMacro widthForString:str font:[UIFont boldSystemFontOfSize:30.0] andHeight:36.0] + 28.0;
            [[self imageWithUIView:[self couponViewWithWidth:couponWidth andStr:str]] drawInRect:CGRectMake(WIDTH - couponWidth - 40.0, titleRect.origin.y + titleRect.size.height + 50.0, couponWidth, 50.0)];
        }
        
        CGRect qrCodeRect = CGRectMake(WIDTH - codeWith - 40.0, titleRect.origin.y + titleRect.size.height + 735.0, codeWith, codeWith);
        [qrCode drawInRect:qrCodeRect];
        
        [self.logoImg drawAtPoint:CGPointMake(40.0, titleRect.origin.y + titleRect.size.height + 735.0)];
        
        for (int i = 0; i < self.goodsShare.share_txt.count; i++) {
            NSString *subStr = [NSString stringWithFormat:@"%@",[self.goodsShare.share_txt objectAtIndex:i]];
            CGFloat width = [UtilsMacro widthForString2:subStr font:[UIFont systemFontOfSize:18.0] andHeight:20.0].size.width;
            [subStr drawInRect:CGRectMake(WIDTH - 40.0 - width, qrCodeRect.origin.y + qrCodeRect.size.height + 10.0 + i * 25.0, width, 20.0) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName:COLOR_666666}];
        }
        
        self.posterImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.shareTable reloadData];
        [ZXProgressHUD hideAllHUD];
        self.isLoading = NO;
    }];
}

- (UIImage*)imageWithUIView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

- (NSMutableAttributedString *)curPriceLabForImgWithStr:(NSString *)str {
    NSString *tempStr = [NSString stringWithFormat:@"券后价￥%@",str];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [attriStr addAttributes:@{NSForegroundColorAttributeName: [UtilsMacro colorWithHexString:@"C4002C"]} range:NSMakeRange(0, tempStr.length)];
    [attriStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:24.0]} range:NSMakeRange(0, 3)];
    [attriStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:34.0]} range:NSMakeRange(3, 1)];
    [attriStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:39.0]} range:NSMakeRange(4, str.length)];
    return attriStr;
}

- (NSMutableAttributedString *)oriPriceStrWithStr:(NSString *)str {
    NSString *tempStr = [NSString stringWithFormat:@"原价￥%@",str];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [attriStr addAttributes:@{NSForegroundColorAttributeName: COLOR_999999, NSFontAttributeName: [UIFont systemFontOfSize:22.0], NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleThick]} range:NSMakeRange(0, tempStr.length)];
    return attriStr;
}

- (UILabel *)couponViewWithWidth:(CGFloat)width andStr:(NSString *)str {
    UILabel *lab = [[UILabel alloc] init];
    [lab setText:str];
    [lab setClipsToBounds:YES];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setBackgroundColor:[UtilsMacro colorWithHexString:@"C4002C"]];
    [lab setFont:[UIFont boldSystemFontOfSize:30.0]];
    [lab setBounds:CGRectMake(0.0, 0.0, width, 50.0)];
    [UtilsMacro addCornerRadiusForView:lab andRadius:10.0 andCornes:UIRectCornerTopLeft | UIRectCornerBottomRight];
    return lab;
}

- (void)systemShare {
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    if ([_shareCell.mainPick isSelected]) {
        [itemList addObject:_posterImg];
    }
    for (int i = 0;  i < [_pickedImgList count]; i++) {
        [itemList addObject:[_shareImgList objectForKey:[_pickedImgList objectAtIndex:i]]];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemList applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [ZXProgressHUD loadSucceedWithMsg:@"分享成功"];
            return;
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - 保存图片到系统相册

- (void)saveImgToAlbum:(UIImage *)img {
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [ZXProgressHUD loadFailedWithMsg:@"保存失败"];
        return;
    }
    if (_shareCell.mainPick.isSelected) {
        if (_currentSaveIndex == [_pickedImgList count]) {
            [ZXProgressHUD loadSucceedWithMsg:@"已保存至相册"];
        }
    } else {
        if (_currentSaveIndex == [_pickedImgList count] - 1) {
            [ZXProgressHUD loadSucceedWithMsg:@"已保存至相册"];
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXShareCell";
    _shareCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [_shareCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_shareCell setDelegate:self];
    [_shareCell setPickStateList:_pickStateList];
    if (_goodsShare) {
        [_shareCell setGoodsShare:_goodsShare];
    }
    if (_posterImg) {
        [_shareCell.mainImg setImage:_posterImg];
    }
    [_shareCell setPosterImg:_posterImg];
    return _shareCell;
}

#pragma mark - ZXShareCellDelegate

- (void)shareCellHanleTapBtnsActionWithBtn:(UIButton *)btn andTag:(NSInteger)btnTag {
    switch (btnTag) {
        case 0:
        {
            [UtilsMacro generalPasteboardCopy:_shareCell.titleTV.text];
            [ZXProgressHUD loadSucceedWithMsg:@"复制成功"];
        }
            break;
        case 1:
        {
            [self.shareTable reloadData];
        }
            break;
        case 2:
        {
            [self.shareTable reloadData];
        }
            break;
        case 3:
        {
            [self.shareTable reloadData];
        }
            break;
        case 4:
        {
            [UtilsMacro generalPasteboardCopy:_goodsShare.tpwd];
            [ZXProgressHUD loadSucceedWithMsg:@"复制淘口令成功"];
        }
            break;
        case 5:
        {
            [UtilsMacro generalPasteboardCopy:_goodsShare.share_url];
            [ZXProgressHUD loadSucceedWithMsg:@"复制链接成功"];
        }
            break;
        case 6:
        {
            if (btn.isSelected) {
                for (int i = 0; i < [_pickStateList count]; i++) {
                    [_pickStateList replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                }
                for (int i = 0; i < [_goodsShare.slides count]; i++) {
                    [_pickedImgList addObject:[_goodsShare.slides objectAtIndex:i]];
                }
            } else {
                for (int i = 0; i < [_pickStateList count]; i++) {
                    [_pickStateList replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                }
                [_pickedImgList removeAllObjects];
            }
            [self.shareTable reloadData];
        }
            break;
        case 7:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)shareCellTextViewDidChange:(UITextView *)textView {
    [self.shareTable beginUpdates];
    [self.shareTable endUpdates];
}

- (void)shareCellImgCellHanleTapPickBtnActionWithCell:(ZXShareImgCell *)cell andTag:(NSInteger)btnTag {
    if (cell.pickBtn.isSelected) {
        if (![_pickedImgList containsObject:[_goodsShare.slides objectAtIndex:btnTag]]) {
            [_pickedImgList addObject:[_goodsShare.slides objectAtIndex:btnTag]];
        }
        [_pickStateList replaceObjectAtIndex:btnTag withObject:[NSNumber numberWithBool:YES]];
    } else {
        if ([_pickedImgList containsObject:[_goodsShare.slides objectAtIndex:btnTag]]) {
            [_pickedImgList removeObject:[_goodsShare.slides objectAtIndex:btnTag]];
        }
        [_pickStateList replaceObjectAtIndex:btnTag withObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark - Button Method

- (IBAction)handleTapShareBtnsAction:(id)sender {
    if (_isLoading) {
        return;
    }
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if ([_pickedImgList count] <= 0) {
                if ([_shareCell.mainPick isSelected]) {
                    if (![WXApi isWXAppInstalled]) {
                        [self systemShare];
                    } else {
                        [[ZXWeChatUtils sharedInstance] shareWithImage:_posterImg text:nil scene:WXSceneSession delegate:self];
                    }
                    return;
                } else {
                    [ZXProgressHUD loadFailedWithMsg:@"请选择图片"];
                    return;
                }
            } else {
                if ([_shareCell.mainPick isSelected] || [_pickedImgList count] > 1) {
                    [self systemShare];
                    return;
                } else {
                    [[ZXWeChatUtils sharedInstance] shareWithImage:[_shareImgList valueForKey:[_pickedImgList objectAtIndex:0]] text:nil scene:WXSceneSession delegate:self];
                    return;
                }
            }
        }
            break;
        case 1:
        {
            if ([_pickedImgList count] <= 0) {
                if ([_shareCell.mainPick isSelected]) {
                    if (![WXApi isWXAppInstalled]) {
                        [self systemShare];
                    } else {
                        [[ZXWeChatUtils sharedInstance] shareWithImage:_posterImg text:nil scene:WXSceneTimeline delegate:self];
                    }
                    return;
                } else {
                    [ZXProgressHUD loadFailedWithMsg:@"请选择图片"];
                    return;
                }
            } else {
                if ([_shareCell.mainPick isSelected] || [_pickedImgList count] > 1) {
                    [self systemShare];
                    return;
                } else {
                    [[ZXWeChatUtils sharedInstance] shareWithImage:[_shareImgList valueForKey:[_pickedImgList objectAtIndex:0]] text:nil scene:WXSceneTimeline delegate:self];
                    return;
                }
            }
        }
            break;
        case 2:
        {
            NSMutableArray *saveList = [[NSMutableArray alloc] init];
            if ([_shareCell.mainPick isSelected]) {
                [saveList addObject:_posterImg];
            }
            for (int i = 0;  i < [_pickedImgList count]; i++) {
                [saveList addObject:[_shareImgList objectForKey:[_pickedImgList objectAtIndex:i]]];
            }
            if ([saveList count] <= 0) {
                [ZXProgressHUD loadFailedWithMsg:@"请选择图片"];
                return;
            }
            [ZXProgressHUD loadingNoMask];
            for (int i = 0; i < [saveList count]; i++) {
                _currentSaveIndex = i;
                [self saveImgToAlbum:[saveList objectAtIndex:i]];
            }
        }
            break;
        case 3:
        {
            NSMutableString *contentStr;
            if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.writeTV.text]) {
                contentStr = [[NSMutableString alloc] initWithString:_shareCell.writeTV.text];
            } else {
                contentStr = [[NSMutableString alloc] initWithString:@""];
            }
            [contentStr appendString:@"\n\n"];
            if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.originalPrice.text]) {
                [contentStr appendString:_shareCell.originalPrice.text];
            } else {
                [contentStr appendString:@""];
            }
            [contentStr appendString:@"\n"];
            if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.currentPrice.text]) {
                [contentStr appendString:_shareCell.currentPrice.text];
            } else {
                [contentStr appendString:@""];
            }
            if (_shareCell.showEarn.isSelected) {
                [contentStr appendString:@"\n"];
                if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.saveLab.text]) {
                    [contentStr appendString:_shareCell.saveLab.text];
                } else {
                    [contentStr appendString:@""];
                }
            }
            if (_shareCell.showCode.isSelected) {
                [contentStr appendString:@"\n--------------------\n"];
                if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.inviteCode.text]) {
                    [contentStr appendString:_shareCell.inviteCode.text];
                } else {
                    [contentStr appendString:@""];
                }
            }
            if (_shareCell.showLink.isSelected) {
                [contentStr appendString:@"\n--------------------\n"];
                if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.linkLab.text]) {
                    [contentStr appendString:_shareCell.linkLab.text];
                } else {
                    [contentStr appendString:@""];
                }
            }
            if (![UtilsMacro whetherIsEmptyWithObject:_goodsShare.tpwd]) {
                [contentStr appendString:@"\n--------------------\n"];
                if (![UtilsMacro whetherIsEmptyWithObject:_shareCell.cpLab.text]) {
                    [contentStr appendString:_shareCell.cpLab.text];
                } else {
                    [contentStr appendString:@""];
                }
            }
//            NSLog(@"contentStr:%@",contentStr);
            [UtilsMacro generalPasteboardCopy:contentStr];
            [ZXProgressHUD loadSucceedWithMsg:@"复制文案成功"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ZXWeChatUtilsDelegate

- (void)zxWeChatShareSucceed {
    [ZXProgressHUD loadSucceedWithMsg:@"分享成功"];
    [[ZXSucceedShareHelper sharedInstance] fetchSucceedShareWithType:[NSString stringWithFormat:@"%d", GOODS_SHARE_TYPE] andRel_id:_item_id andUrl:nil completion:^(ZXResponse * _Nonnull response) {
        
    } error:^(ZXResponse * _Nonnull response) {
        
    }];
}

@end
