//
//  VBAddStatusInputView.h
//  VoiceBook
//
//  Created by li lei on 2021/3/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewSendTextDelegate <NSObject>

@optional
- (void)sendTextDelegate:(NSString * __nullable)str;

@end
NS_ASSUME_NONNULL_BEGIN

@interface VBAddStatusInputView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, strong) NSString *saveKey;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic,copy) void (^sendBlock)(BOOL send);
@property (nonatomic, weak) id <NewSendTextDelegate>delegate;
@property (nonatomic, strong) UILabel *plaL;
@end

NS_ASSUME_NONNULL_END
