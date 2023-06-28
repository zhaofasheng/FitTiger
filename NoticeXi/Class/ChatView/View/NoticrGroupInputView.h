//
//  NoticrGroupInputView.h
//  NoticeXi
//
//  Created by li lei on 2020/8/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeChatGroupDelegate <NSObject>

@optional
- (void)refreshTableViewWithFrame:(CGRect)frame keyBordyHight:(CGFloat)keybordHeight;
- (void)sendImageDelegate;
- (void)sendContent:(NSString *__nullable)content;
- (void)sendVoiceDelegate;
- (void)refreshTableViewWithHideFrame:(CGRect)frame;
- (void)sendEmotionOpen;
- (void)sendEmotionClose;
@end
NS_ASSUME_NONNULL_BEGIN

@interface NoticrGroupInputView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIImageView *sendImageView;
@property (nonatomic, weak) id <NoticeChatGroupDelegate>delegate;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, assign) NSInteger location;

@end

NS_ASSUME_NONNULL_END
