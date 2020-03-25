//
//  ZXChatViewController.h
//  pzhixin
//
//  Created by zhixin on 2019/8/28.
//  Copyright © 2019 zhixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXIMSDK_TUIKit_iOS/TUIChatController.h>
#import <TXIMSDK_TUIKit_iOS/TUnReadView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXChatViewController : UIViewController

@property (nonatomic, strong) TUIConversationCellData *conversationData;
@property (nonatomic, strong) TUnReadView *unRead;
@property (nonatomic, strong) TUIChatController *chat;

@end

NS_ASSUME_NONNULL_END
