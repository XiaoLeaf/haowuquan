//
//  ZXAboutViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/6/19.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAboutViewController.h"
#import "ZXAboutCell.h"
#import "ZXAboutHeaderView.h"

@interface ZXAboutViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *aboutList;
}
@property (weak, nonatomic) IBOutlet UIButton *dealBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;

@end

@implementation ZXAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dealBtn setTitle:[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].txt forState:UIControlStateNormal];
    [self.rightLab setText:[[[ZXAppConfigHelper sharedInstance] appConfig] copyright]];
    [self.aboutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Do any additional setup after loading the view from its nib.
    aboutList = @[[[[[ZXAppConfigHelper sharedInstance] appConfig] h5] intro].txt, @"版本更新"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aboutList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZXAboutHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXAboutHeaderView class]) owner:nil options:nil] lastObject];
    [headerView setFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 200.0)];
    [headerView.versionLabel setText:[NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [UtilsMacro zxSD_setImageWithURL:[NSURL URLWithString:[[[[ZXAppConfigHelper sharedInstance] appConfig] img_res] about_logo]] imageView:headerView.logoImg placeholderImage:nil options:0 progress:nil completed:nil];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXAboutCell";
    ZXAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXAboutCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@",[aboutList objectAtIndex:indexPath.row]]];
    if (indexPath.row != [aboutList count] - 1) {
        [cell.bottomLine setHidden:YES];
    } else {
        [cell.bottomLine setHidden:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![UtilsMacro whetherIsEmptyWithObject:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] intro].url_schema]]) {
                    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] intro].url_schema] andUserInfo:nil viewController:self];
                }
            });
        }
            break;
        case 1:
        {
            [ZXProgressHUD loading];
            [UtilsMacro checkAppVersionUpdateWithViewController:self needToast:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Button Method

- (IBAction)handleTapDealBtnAction:(id)sender {
    [[ZXRouters sharedInstance] openPageWithUrl:[NSString stringWithFormat:@"%@%@", URL_PREFIX, [[[[ZXAppConfigHelper sharedInstance] appConfig] h5] agreement].url_schema] andUserInfo:nil viewController:self];
}

@end
