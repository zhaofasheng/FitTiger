//
//  NoticeSendChatView.h
//  NoticeXi
//
//  Created by li lei on 2022/7/13.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoticeChatShopDelegate <NSObject>

@optional
- (void)refreshTableViewWithFrame:(CGRect)frame keyBordyHight:(CGFloat)keybordHeight;

- (void)sendContent:(NSString *__nullable)content;

- (void)refreshTableViewWithHideFrame:(CGRect)frame;

@end
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendChatView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *carmBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, weak) id <NoticeChatShopDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
