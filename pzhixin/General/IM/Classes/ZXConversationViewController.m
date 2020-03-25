//
//  ZXConversationViewController.m
//  pzhixin
//
//  Created by zhixin on 2019/8/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import "ZXConversationViewController.h"
#import "ZXChatViewController.h"

@interface ZXConversationViewController () <TUIConversationListControllerDelegagte, TPopViewDelegate> {
    
}

@end

@implementation ZXConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TUIConversationListController *conv = [[TUIConversationListController alloc] init];
    [conv setDelegate:self];
    [self addChildViewController:conv];
    [self.view addSubview:conv.view];
    
    [conv.tableView setDelaysContentTouches:NO];
    
    [self setupNavigation];
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

/**
 *初始化导航栏
 */
- (void)setupNavigation
{
    _titleView = [[TNaviBarIndicatorView alloc] init];
    [_titleView setTitle:@"云通信IM"];
    self.navigationItem.titleView = _titleView;
    self.navigationItem.title = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkChanged:) name:TUIKitNotification_TIMConnListener object:nil];
}

/**
 *初始化导航栏Title，不同连接状态下Title显示内容不同
 */
- (void)onNetworkChanged:(NSNotification *)notification {
    TUINetStatus status = (TUINetStatus)[notification.object intValue];
    switch (status) {
        case TNet_Status_Succ:
//            [_titleView setTitle:@"云通信IM"];
//            [_titleView stopAnimating];
            [self setTitle:@"云通信IM" font:TITLE_FONT color:HOME_TITLE_COLOR];
            break;
        case TNet_Status_Connecting:
//            [_titleView setTitle:@"连接中..."];
//            [_titleView startAnimating];
            [self setTitle:@"连接中..." font:TITLE_FONT color:HOME_TITLE_COLOR];
            break;
        case TNet_Status_Disconnect:
//            [_titleView setTitle:@"云通信IM(未连接)"];
//            [_titleView stopAnimating];
            [self setTitle:@"云通信IM(未连接)" font:TITLE_FONT color:HOME_TITLE_COLOR];
            break;
        case TNet_Status_ConnFailed:
//            [_titleView setTitle:@"云通信IM(未连接)"];
//            [_titleView stopAnimating];
            [self setTitle:@"云通信IM(未连接)" font:TITLE_FONT color:HOME_TITLE_COLOR];
            break;
            
        default:
            break;
    }
}

#pragma mark - TUIConversationListControllerDelegagte

/**
 *在消息列表内，点击了某一具体会话后的响应函数
 */
- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation
{
    ZXChatViewController *chat = [[ZXChatViewController alloc] init];
    chat.conversationData = conversation.convData;
    [self.navigationController pushViewController:chat animated:YES];
}

@end
