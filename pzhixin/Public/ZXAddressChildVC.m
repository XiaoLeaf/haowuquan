//
//  ZXAddressChildVC.m
//  pzhixin
//
//  Created by zhixin on 2019/11/13.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXAddressChildVC.h"
#import "ZXAddressPickCell.h"

@interface ZXAddressChildVC () <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) NSInteger defaultSelect;

@end

@implementation ZXAddressChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_childTable setTableFooterView:[UIView new]];
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

- (void)setItemList:(NSArray *)itemList {
    _itemList = itemList;
    [_childTable reloadData];
}

- (void)setPcasJson:(ZXPcasJson *)pcasJson {
    if (![UtilsMacro whetherIsEmptyWithObject:pcasJson]) {
        _pcasJson = pcasJson;
        for (int i = 0; i < [_itemList count]; i++) {
            ZXPcasJson *subJson = (ZXPcasJson *)[_itemList objectAtIndex:i];
            if ([subJson.pcid longLongValue] == [_pcasJson.pcid longLongValue]) {
                _defaultSelect = i;
                [self.childTable beginUpdates];
                [self.childTable endUpdates];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.defaultSelect inSection:0];
                    [self.childTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                });
                break;
            }
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZXAddressPickCell";
    ZXAddressPickCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([ZXAddressPickCell class]) bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZXPcasJson *pcasJson = (ZXPcasJson *)[_itemList objectAtIndex:indexPath.row];
    [cell setPcasJson:pcasJson];
    if (indexPath.row == _defaultSelect) {
        [cell.nameLab setTextColor:THEME_COLOR];
    } else {
        [cell.nameLab setTextColor:HOME_TITLE_COLOR];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXPcasJson *pcasJson = (ZXPcasJson *)[_itemList objectAtIndex:indexPath.row];
    if (self.zxAddressChildVCDidSelect) {
        self.zxAddressChildVCDidSelect(pcasJson);
    }
}

@end
